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

                if let authUser = self.auth.currentUser {
                    authUser.displayName = username

                    self.saveUser(authUser) { error in
                        if let error = error {
                            completion(error)
                            return
                        }
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
}
