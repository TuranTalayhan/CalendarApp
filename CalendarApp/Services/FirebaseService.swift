//
//  FirebaseService.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 14/03/2025.
//
import FirebaseAuth
import FirebaseFirestore

class FirebaseService {
    static let shared = FirebaseService()

    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    private var handle: AuthStateDidChangeListenerHandle?
    public var currentUser: User?

    private init() {}

    func saveEvent(_ event: Event) {
        var data: [String: Any] = [
            "name": event.title,
            "allDay": event.allDay,
            "startDate": event.startDate,
            "endDate": event.endDate,
            "alert": event.alert,
            "timestamp": event.timestamp,
        ]

        if let url = event.url?.absoluteString { data["url"] = url }
        if let notes = event.notes { data["notes"] = notes }
        if let groupId = event.group?.id { data["group"] = groupId }
        if let assignedToId = event.assignedTo { data["assignedTo"] = assignedToId }

        if let group = event.group {
            firestore.collection("groups").document(group.id).collection("events").document(event.id).setData(data)
        } else if let assignedTo = event.assignedTo {
            firestore.collection("users").document(assignedTo).collection("events").document(event.id).setData(data)
        } else if let currentUser = currentUser {
            firestore.collection("users").document(currentUser.id).collection("events").document(event.id).setData(data)
        } else {
            print("error saving event")
        }
    }

    func deleteEvent(_ event: Event) {
        if let group = event.group {
            firestore.collection("groups").document(group.id).collection("events").document(event.id).delete()
        } else if let assignedTo = event.assignedTo {
            firestore.collection("users").document(assignedTo).collection("events").document(event.id).delete()
        } else if let currentUser = currentUser {
            firestore.collection("users").document(currentUser.id).collection("events").document(event.id).delete()
        }
    }

    func saveGroup(_ group: Group) {
        let data: [String: Any] = [
            "name": group.name,
            "members": group.members.map(\.id),
            "timestamp": group.timestamp,
        ]

        firestore.collection("groups").document(group.id).setData(data)
    }

    func deleteGroup(id: String) {
        firestore.collection("groups").document(id).delete()
    }

    func fetchGroup(id: String) async -> Group? {
        do {
            let docSnapshot = try await firestore.collection("groups").document(id).getDocument()
            guard let data = docSnapshot.data(),
                  let name = data["name"] as? String,
                  let memberIDs = data["members"] as? [String],
                  let timestamp = data["timestamp"] as? Timestamp
            else {
                return nil
            }

            let group = Group(id: id, name: name, members: memberIDs.map { StringID($0) })
            group.timestamp = timestamp.dateValue()
            return group

        } catch {
            print("Failed to get group:", error)
            return nil
        }
    }

    func fetchUsers(withIDs IDs: [String]) async throws -> [User] {
        // TODO: REMOVE THROWS
        guard !IDs.isEmpty else {
            return []
        }
        var users: [User] = []
        let chunkedIDs = stride(from: 0, to: IDs.count, by: 10).map {
            Array(IDs[$0 ..< min($0 + 10, IDs.count)])
        }

        for chunk in chunkedIDs {
            let userSnapshots = try await firestore.collection("users").whereField(FieldPath.documentID(), in: chunk).getDocuments()

            for document in userSnapshots.documents {
                let data = document.data()
                if let username = data["username"] as? String, let email = data["email"] as? String {
                    let user = User(id: document.documentID, username: username, email: email)
                    users.append(user)
                }
            }
        }
        return users
    }

    func fetchUser(_ id: String) async throws -> User? {
        let userSnapshot = try? await firestore.collection("users").document(id).getDocument()

        if let data = userSnapshot?.data(),
           let username = data["username"] as? String,
           let email = data["email"] as? String
        {
            return User(id: id, username: username, email: email)
        }
        return nil
    }

    // TODO: COMPARE TIMESTAMP
    func fetchGroup(_ id: String) async throws -> Group? {
        let groupSnapshot = try? await firestore.collection("groups").document(id).getDocument()

        if let data = groupSnapshot?.data(),
           let name = data["name"] as? String,
           let memberIDs = data["members"] as? [String],
           let timestamp = data["timestamp"] as? Timestamp
        {
            return Group(id: id, name: name, members: memberIDs.map { StringID($0) })
        } else {
            return nil
        }
    }

    func fetchUserGroups() async throws -> [Group]? {
        // TODO: REMOVE THROWS
        let groupSnapshots = try? await firestore.collection("groups").whereField("members", arrayContains: currentUser?.id ?? "").getDocuments()

        if let documents = groupSnapshots?.documents {
            var groups: [Group] = []
            for document in documents {
                let data = document.data()
                guard let name = data["name"] as? String,
                      let memberIDs = data["members"] as? [String],
                      let timestamp = data["timestamp"] as? Timestamp
                else {
                    return nil
                }
                let group = Group(id: document.documentID, name: name, members: memberIDs.map { StringID($0) })
                group.timestamp = timestamp.dateValue()
                groups.append(group)
            }
            return groups
        }

        return nil
    }

    func fetchUserEvents() async -> [Event] {
        guard let userId = currentUser?.id else { return [] }
        var allEvents: [Event] = []

        do {
            let groupSnapshot = try await firestore
                .collection("groups")
                .whereField("members", arrayContains: userId)
                .getDocuments()

            for groupDoc in groupSnapshot.documents {
                let groupId = groupDoc.documentID
                let eventsSnapshot = try await firestore
                    .collection("groups")
                    .document(groupId)
                    .collection("events")
                    .getDocuments()

                for doc in eventsSnapshot.documents {
                    if let event = try? await parseEvent(doc: doc, groupId: groupId) {
                        allEvents.append(event)
                    }
                }
            }

            let userEventSnapshot = try await firestore
                .collection("users")
                .document(userId)
                .collection("events")
                .getDocuments()

            for doc in userEventSnapshot.documents {
                if let event = try? await parseEvent(doc: doc, groupId: nil) {
                    allEvents.append(event)
                }
            }

        } catch {
            print("Error fetching events: \(error)")
        }

        return allEvents
    }

    private func parseEvent(doc: QueryDocumentSnapshot, groupId: String?) async throws -> Event? {
        let data = doc.data()

        guard let name = data["name"] as? String,
              let allDay = data["allDay"] as? Bool,
              let startDate = data["startDate"] as? Timestamp,
              let endDate = data["endDate"] as? Timestamp,
              let alert = data["alert"] as? Int,
              let timestamp = data["timestamp"] as? Timestamp
        else {
            return nil
        }

        let urlString = data["url"] as? String
        let url = urlString.flatMap { URL(string: $0) }

        let notes = data["notes"] as? String
        let assignedToId = data["assignedTo"] as? String
        let assignedUser = assignedToId != nil ? try? await fetchUsers(withIDs: [assignedToId!]).first : nil

        var group: Group?

        if let groupId = groupId {
            group = try? await fetchGroup(groupId)
        }

        let event = Event(
            id: doc.documentID,
            title: name,
            allDay: allDay,
            startTime: startDate.dateValue(),
            endTime: endDate.dateValue(),
            url: url,
            notes: notes,
            alert: alert,
            group: group,
            assignedTo: assignedUser?.id
        )
        event.timestamp = timestamp.dateValue()

        return event
    }

    func RegisterWithEmail(_ username: String, _ email: String, _ password: String, completion: @escaping (Error?) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error)
                return
            }

            guard let authUser = result?.user else {
                completion(NSError(domain: "FirebaseService", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not found after registration"]))
                return
            }

            let changeRequest = authUser.createProfileChangeRequest()
            changeRequest.displayName = username

            changeRequest.commitChanges { error in
                if let error = error {
                    completion(error)
                    return
                }
                self.saveUser(authUser, username: username) { error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    completion(nil)
                }
            }

            self.currentUser = User(id: self.currentUser?.id ?? UUID().uuidString, username: username, email: email)
        }
    }

    func LogInWithEmail(_ email: String, _ password: String, completion: @escaping (Error?) -> Void) {
        auth.signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(error)
                return
            }
            let user = User(id: self.getCurrentUser()?.id ?? UUID().uuidString, username: self.getCurrentUser()?.username ?? "", email: self.getCurrentUser()?.email ?? "")
            self.currentUser = user
            completion(nil)
        }
    }

    func LogInChecked(email: String, password: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            self.LogInWithEmail(email, password) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    private func saveUser(_ user: FirebaseAuth.User, username: String, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = [
            "username": username,
            "email": user.email as Any,
        ]

        firestore.collection("users").document(user.uid).setData(data) { error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }

    func ResetPassword(_ email: String, completion: @escaping (Error?) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }

    func getCurrentUser() -> User? {
        guard let user = auth.currentUser, let displayName = user.displayName, let email = user.email else {
            return nil
        }
        return User(id: user.uid, username: displayName, email: email)
    }

    func addAuthStateListener(completion: @escaping (User?) -> Void) {
        handle = auth.addStateDidChangeListener { _, user in
            if let user = user, let username = user.displayName, let email = user.email {
                completion(User(id: user.uid, username: username, email: email))
            } else {
                completion(nil)
            }
        }
    }

    func removeAuthStateListener() {
        if let handle = handle {
            auth.removeStateDidChangeListener(handle)
        }
    }

    func signOut() {
        do {
            try auth.signOut()
        } catch {
            print("Error signing out: \(error)")
        }
    }
}
