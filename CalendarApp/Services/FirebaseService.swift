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
        if let assignedToId = event.assignedTo?.id { data["assignedTo"] = assignedToId }

        if let group = event.group {
            firestore.collection("groups").document(group.id).collection("events").document(event.id).setData(data)
        } else if let assignedTo = event.assignedTo {
            firestore.collection("users").document(assignedTo.id).collection("events").document(event.id).setData(data)
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
            firestore.collection("users").document(assignedTo.id).collection("events").document(event.id).delete()
        } else if let currentUser = currentUser {
            firestore.collection("users").document(currentUser.id).collection("events").document(event.id).delete()
        }
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

            self.currentUser = User(username: username, email: email)
        }
    }

    func LogInWithEmail(_ email: String, _ password: String, completion: @escaping (Error?) -> Void) {
        auth.signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(error)
                return
            }
            let user = User(username: self.getCurrentUser()?.username ?? "", email: self.getCurrentUser()?.email ?? "")
            self.currentUser = user
            completion(nil)
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
        return User(username: displayName, email: email)
    }

    func addAuthStateListener(completion: @escaping (User?) -> Void) {
        handle = auth.addStateDidChangeListener { _, user in
            if let user = user, let username = user.displayName, let email = user.email {
                completion(User(username: username, email: email))
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
