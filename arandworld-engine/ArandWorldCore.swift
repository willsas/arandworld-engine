//
//  ArandWorldCore.swift
//  arandworld-engine
//
//  Created by Willa on 20/05/21.
//

import UIKit
import Amplify
import AmplifyPlugins

public class ArandWorldCore {
    
    public static let shared = ArandWorldCore()
    
    private var appDelegate: UIApplication?
    
    public func initiate(_ appDelegate: UIApplication) {
        self.appDelegate = appDelegate
        configureAmplify()
    }
    
    private func configureAmplify(){
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.configure()
            print("Success configure aws")
        } catch let err {
            print("Failed configure aws: \(err)")
        }
    }
}
