//
//  ArandWorldCore.swift
//  arandworld-engine
//
//  Created by Willa on 20/05/21.
//

import UIKit
import Amplify
import AmplifyPlugins

public final class ArandWorldCore {
    
    public static let shared = ArandWorldCore()
    private var appDelegate: UIApplication?
    private var dependency: DependencyContainer
    
    init(dependencyContainer: DependencyContainer = DependencyContainer(networkService: URLSessionNetworkService())) {
        self.dependency = dependencyContainer
    }
}

// MARK: - Public dependencies
extension ArandWorldCore {
    public final class Service {
        public static var authService: AuthService = ArandWorldCore.shared.dependency.createAuthService()
        public static var userNetworkSession: UserNetworkSessionService = ArandWorldCore.shared.dependency.userNetworkSession
    }
}



// MARK: - Public Function
extension ArandWorldCore {
    public func initiate(_ appDelegate: UIApplication) {
        self.appDelegate = appDelegate
        self.configureAmplify()
    }
    
    private func configureAmplify(){
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.configure()
            print("\(String(describing: self)) \(#function): Success configure AWS")
        } catch let err {
            print("ERROR: \(String(describing: self)) \(#function): \(err)")
            fatalError(err.localizedDescription)
        }
    }
}
