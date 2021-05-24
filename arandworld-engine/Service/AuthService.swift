//
//  AuthService.swift
//  arandworld-engine
//
//  Created by Willa on 24/05/21.
//

import Foundation

public protocol AuthService {
    var isSignIn: String? { get }
    var user: String? { get }
    var authDelegate: AuthServiceDelegate? { get set }
    func signIn(username: String, password: String)
    func signUp(username: String, password: String, email: String)
    func confirmSignUp(username: String, code: String)
}

public protocol AuthServiceDelegate: class {
    func onLogin(onError: Error?)
}

