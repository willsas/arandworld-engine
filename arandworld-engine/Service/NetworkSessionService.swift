//
//  NetworkSession.swift
//  arandworld-engine
//
//  Created by Willa on 05/06/21.
//

import Foundation


public protocol UserNetworkSessionService {
    func editUser(username: String)
}

public final class AWSUserNetworkSession: UserNetworkSessionService {
    public func editUser(username: String) {
        print("\(String(describing: self)) \(#function)")
    }
}
