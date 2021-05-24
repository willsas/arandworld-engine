//
//  DependencyContainer.swift
//  arandworld-engine
//
//  Created by Willa on 24/05/21.
//

import Foundation

public final class DependencyContainer {
    
    private let networkService: NetworkService
    
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
}


extension DependencyContainer: AuthFactory {
    public func createAuthService() -> AuthService {
        return AmplifyAuthService()
    }
}
