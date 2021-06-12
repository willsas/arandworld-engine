//
//  NetworkService.swift
//  arandworld-engine
//
//  Created by Willa on 24/05/21.
//

import Foundation

// Resource for every networking request
public struct Resource<T: Codable>{
    var url: URL
    var httpMethod: URLRequest.HTTPMethod
    var params: [String: String]?
    var headers: [String: String]?
    var isUserAuthHeader: Bool
    var cacheID: String?
    var data: Data?
}


/// Comform to this protocol if you want to make a new networking object
public protocol NetworkService {
    
    /// Perform a networking service
    /// - Parameters:
    ///   - resource: **Use BaseModel as a base generic resource : BaseModel<Resouce<T>>**
    ///   - completion: Generic type of resource
    func perform<T>(resource: Resource<T>, completion: @escaping (Swift.Result<T, NetworkError>) -> Void)
    
    
    /// To Cancel all the on going network call
    func cancelAllService()
    
    /// Clear coocies
    func clearAllCookies()
}






public enum NetworkError: Error{
    case decodingError(Error?)
    case noNetwork(Error?)
    case noDataReceived(Error?)
    case phoneNumberIsNotVerified(Error?)
    case other(String)
    case err(Error?)
}

extension NetworkError: LocalizedError{
    public var errorDescription: String? {
        switch self {
        case .decodingError(let err):
            return NSLocalizedString("Error: Failed to get data", comment: "\(err?.localizedDescription ?? "")")
        case .noNetwork(let err):
            return NSLocalizedString("Error: No Network", comment: "\(err?.localizedDescription ?? "")")
        case .noDataReceived(let err):
            return NSLocalizedString("Error: No Data Received", comment: "\(err?.localizedDescription ?? "")")
        case .phoneNumberIsNotVerified(_):
            return NSLocalizedString("Your phone number is not verified.", comment: "")
        case .other(let msg):
            return NSLocalizedString("\(msg)", comment: "")
        case .err(let err):
            return NSLocalizedString("\(err?.localizedDescription ?? "Failed to get data")", comment: "")
        }
    }
}
