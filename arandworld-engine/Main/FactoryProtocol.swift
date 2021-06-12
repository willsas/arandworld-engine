//
//  FactoryProtocol.swift
//  arandworld-engine
//
//  Created by Willa on 24/05/21.
//

import Foundation

protocol AuthFactory {
    func createAuthService() -> AuthService
}

protocol NetworkSession {
    var userNetworkSession: UserNetworkSessionService { get }
}


