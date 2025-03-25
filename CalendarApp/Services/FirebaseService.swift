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

    private init() {}

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

                self.saveUser(authUser) { error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    completion(nil)
                }
            }
        }
    }

    func LogInWithEmail(_ email: String, _ password: String, completion: @escaping (Error?) -> Void) {
        auth.signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }

    private func saveUser(_ user: FirebaseAuth.User, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = [
            "username": user.displayName as Any,
            "email": user.email as Any
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
            if let user = user {
                completion(User(username: user.displayName ?? "", email: user.email ?? ""))
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
