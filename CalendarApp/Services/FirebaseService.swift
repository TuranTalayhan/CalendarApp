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
    private var currentUser: User?

    private init() {}

    func RegisterWithEmail(_ username: String, _ email: String, _ password: String, completion: @escaping (Error?) -> Void) {
        auth.createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(error)
                return
            }

            self.LogInWithEmail(email, password) { error in
                if let error = error {
                    completion(error)
                    return
                }

                let authUser = self.auth.currentUser!

                authUser.displayName = username

                self.currentUser = User(id: authUser.uid, username: username, email: email)

                self.saveUser(self.currentUser!) { error in
                    if let error = error {
                        completion(error)
                        return
                    }
                }
                completion(nil)
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

    private func saveUser(_ user: User, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = [
            "username": user.username,
            "email": user.email
        ]

        firestore.collection("users").document(user.id).setData(data) { error in
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

    func getCurrentUser() -> User {
        return currentUser!
    }
}
