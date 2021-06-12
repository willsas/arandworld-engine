//
//  ARWError.swift
//  arandworld-engine
//
//  Created by Willa on 12/06/21.
//

import Foundation


public enum ARWError: Error {
    
    public enum ARWAuthError: Error {
        case otpError
        case invalidToken
        case other(String?)
    }
    
    case err(Error?)
    case other(String)
}

extension ARWError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .err(let err):
            return err?.localizedDescription
        case .other(let msg):
            return NSLocalizedString(
                msg,
                comment: msg
            )
        }
    }
}

extension ARWError.ARWAuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .otpError:
            return NSLocalizedString(
                "OTP Error",
                comment: "OTP error, please confirm your account first"
            )
        case .invalidToken:
            return NSLocalizedString(
                "Your token is invalid",
                comment: "Please re-login"
            )
        case .other(let msg):
            return NSLocalizedString(
                msg ?? "",
                comment: msg ?? ""
            )
        }
    }
}

extension ARWError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .err(let err):
            return err?.localizedDescription ?? ""
        case .other(let msg):
            return msg
        }
    }
}

extension ARWError.ARWAuthError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalidToken:
            return "invalid token"
        case .otpError:
            return "OTP Error"
        case .other(let msg):
            return msg ?? ""
        }
    }
}
