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
    private var groupListener: ListenerRegistration?
    private var eventListener: ListenerRegistration?
    private var groupEventListeners: [ListenerRegistration] = []
    public var currentUser: User?

    private init() {}

    deinit {
        removeListeners()
    }

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
        if let groupId = event.group { data["group"] = groupId }
        if let assignedToId = event.assignedTo { data["assignedTo"] = assignedToId }

        if let group = event.group {
            firestore.collection("groups").document(group).collection("events").document(event.id).setData(data)
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
            firestore.collection("groups").document(group).collection("events").document(event.id).delete()
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

    func deleteGroup(id: String) async {
        let groupRef = firestore.collection("groups").document(id)
        let eventsRef = groupRef.collection("events")

        do {
            let snapshot = try await eventsRef.getDocuments()
            for doc in snapshot.documents {
                try await doc.reference.delete()
            }

            try await groupRef.delete()
            print("Successfully deleted group and all its events.")
        } catch {
            print("Error deleting group or its events: \(error.localizedDescription)")
        }
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

    func listenToUserGroups(update: @escaping ([Group]) -> Void) {
        guard let userId = currentUser?.id else {
            update([])
            return
        }

        groupListener = firestore.collection("groups")
            .whereField("members", arrayContains: userId)
            .addSnapshotListener(includeMetadataChanges: true) { snapshot, error in
                if let error = error {
                    print("Error listening to user groups: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    update([])
                    return
                }

                var groups: [Group] = []
                for document in documents {
                    let data = document.data()
                    guard let name = data["name"] as? String,
                          let memberIDs = data["members"] as? [String],
                          let timestamp = data["timestamp"] as? Timestamp
                    else {
                        continue
                    }
                    let group = Group(id: document.documentID, name: name, members: memberIDs.map { StringID($0) })
                    group.timestamp = timestamp.dateValue()
                    groups.append(group)
                }
                return update(groups)
            }
    }

    func listenToUserEvents(update: @escaping ([Event]) -> Void) {
        guard let userId = currentUser?.id else {
            update([])
            return
        }

        let eventUpdateQueue = DispatchQueue(label: "com.calendarApp.eventUpdateQueue")
        var allEvents: [Event] = []

        eventListener = firestore.collection("users")
            .document(userId)
            .collection("events")
            .addSnapshotListener(includeMetadataChanges: true) { snapshot, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }

                Task {
                    var events: [Event] = []

                    for doc in snapshot?.documents ?? [] {
                        if let event = try? await self.parseEvent(doc: doc, groupId: nil) {
                            events.append(event)
                        }
                    }

                    eventUpdateQueue.async {
                        allEvents.removeAll(where: { $0.group == nil })
                        allEvents.append(contentsOf: events)
                        DispatchQueue.main.async {
                            update(allEvents)
                        }
                    }
                }
            }

        firestore.collection("groups")
            .whereField("members", arrayContains: userId)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching groups for event listeners: \(error?.localizedDescription ?? "unknown")")
                    return
                }

                for doc in documents {
                    let groupId = doc.documentID

                    let listener = self.firestore
                        .collection("groups")
                        .document(groupId)
                        .collection("events")
                        .addSnapshotListener(includeMetadataChanges: true) { snapshot, error in
                            if let error = error {
                                print("Error listening to events in group \(groupId): \(error.localizedDescription)")
                                return
                            }

                            Task {
                                var groupEvents: [Event] = []

                                for doc in snapshot?.documents ?? [] {
                                    if let event = try? await self.parseEvent(doc: doc, groupId: groupId) {
                                        groupEvents.append(event)
                                    }
                                }

                                eventUpdateQueue.async {
                                    allEvents.removeAll(where: { $0.group == groupId })
                                    allEvents.append(contentsOf: groupEvents)
                                    DispatchQueue.main.async {
                                        update(allEvents)
                                    }
                                }
                            }
                        }

                    self.groupEventListeners.append(listener)
                }
            }
    }

    func removeListeners() {
        groupListener?.remove()
        eventListener?.remove()

        for listener in groupEventListeners {
            listener.remove()
        }
        groupEventListeners.removeAll()
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

        let event = Event(
            id: doc.documentID,
            title: name,
            allDay: allDay,
            startTime: startDate.dateValue(),
            endTime: endDate.dateValue(),
            url: url,
            notes: notes,
            alert: alert,
            group: groupId,
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
