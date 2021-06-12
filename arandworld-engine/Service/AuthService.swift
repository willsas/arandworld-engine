//
//  AuthService.swift
//  arandworld-engine
//
//  Created by Willa on 24/05/21.
//

import Foundation

public protocol AuthService {
    var user: String? { get }
    func isLoggedIn(completion: @escaping (Result<Bool, ARWError.ARWAuthError>) -> Void)
    func signIn(username: String, password: String, completion: @escaping (Result<Bool, ARWError.ARWAuthError>) -> Void)
    func signUp(username: String, password: String, email: String, completion: @escaping (Result<Bool, ARWError.ARWAuthError>) -> Void)
    func confirmSignUp(username: String, code: String, completion: @escaping (Result<Bool, ARWError.ARWAuthError>) -> Void)
    func signOut(completion: @escaping (Result<Bool, ARWError.ARWAuthError>) -> Void)
}

