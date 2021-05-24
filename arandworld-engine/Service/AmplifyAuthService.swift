//
//  AmplifyAuthService.swift
//  arandworld-engine
//
//  Created by Willa on 24/05/21.
//

import Foundation
import Amplify

class AmplifyAuthService: AuthService {
    
    var isSignIn: String?
    
    var user: String?
    
    weak var authDelegate: AuthServiceDelegate?
    
    func signIn(username: String, password: String) {
        Amplify.Auth.signIn(username: username, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.authDelegate?.onLogin(onError: nil)
            case .failure(let error):
                self?.authDelegate?.onLogin(onError: error)
            }
        }
    }
    
    func signUp(username: String, password: String, email: String) {
        
    }
    
    func confirmSignUp(username: String, code: String) {
        
    }
}
