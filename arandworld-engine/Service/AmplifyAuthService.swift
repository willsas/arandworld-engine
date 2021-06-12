//
//  AmplifyAuthService.swift
//  arandworld-engine
//
//  Created by Willa on 24/05/21.
//

import Foundation
import Amplify

class AmplifyAuthService: AuthService {
    
    var user: String? = nil
    
    func isLoggedIn(completion: @escaping (Result<Bool, ARWError.ARWAuthError>) -> Void) {
        _ = Amplify.Auth.fetchAuthSession { result in
              switch result {
              case .success(let session):
                completion(.success(session.isSignedIn))
              case .failure(let err):
                completion(.failure(ARWError.ARWAuthError.other(err.errorDescription.description)))
              }
          }
    }
    
    func signIn(username: String, password: String, completion: @escaping (Result<Bool, ARWError.ARWAuthError>) -> Void) {
        Amplify.Auth.signIn(username: username, password: password) { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let err):
                completion(.failure(ARWError.ARWAuthError.other(err.errorDescription.description)))
            }
        }
    }
    
    func signUp(username: String, password: String, email: String, completion: @escaping (Result<Bool, ARWError.ARWAuthError>) -> Void) {
        Amplify.Auth.signUp(username: username,
                            password: password,
                            options: AuthSignUpRequest.Options(userAttributes: [AuthUserAttribute(.email, value: email)], pluginOptions: nil),
                            listener: { result in
                                switch result {
                                case .success(_):
                                    completion(.success(true))
                                case .failure(let err):
                                    completion(.failure(ARWError.ARWAuthError.other(err.errorDescription.description)))
                                }
                            })
    }
    
    func confirmSignUp(username: String, code: String, completion: @escaping (Result<Bool, ARWError.ARWAuthError>) -> Void) {
        Amplify.Auth.confirmSignUp(for: username, confirmationCode: code) { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let err):
                completion(.failure(ARWError.ARWAuthError.other(err.errorDescription.description)))
            }
        }
    }
    
    func signOut(completion: @escaping (Result<Bool, ARWError.ARWAuthError>) -> Void) {
        Amplify.Auth.signOut { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let err):
                completion(.failure(ARWError.ARWAuthError.other(err.errorDescription.description)))
            }
        }
    }
}
