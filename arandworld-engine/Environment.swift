//
//  Environment.swift
//  arandworld-engine
//
//  Created by Willa on 24/05/21.
//

import Foundation

class Environment {
    
    static let shared = Environment()
    
    var status: String?
    
    
    func configure() {
        #if PROD
            status = "PROD"
        #elseif STAG
            status = "STAG"
        #endif
    }
    
}
