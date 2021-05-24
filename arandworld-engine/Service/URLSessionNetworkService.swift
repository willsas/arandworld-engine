//
//  URLSessionNetworkService.swift
//  arandworld-engine
//
//  Created by Willa on 24/05/21.
//

import Foundation
import MobileCoreServices


public final class URLSessionNetworkService: NetworkService {
    
    public init() {}
    
    public func clearAllCookies() {
//        let url = URL(string: Environment().configuration(.goxBaseApiURL))!
//        let cstorage = HTTPCookieStorage.shared
//        if let cookies = cstorage.cookies(for: url) {
//            for cookie in cookies {
//                cstorage.deleteCookie(cookie)
//            }
//        }
    }
    
    public func cancelAllService() {
        URLSession.shared.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            dataTasks.forEach {$0.cancel()}
            uploadTasks.forEach {$0.cancel()}
            downloadTasks.forEach {$0.cancel()}
        }
    }
    
    public func perform<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable, T : Encodable {
        
        
        
        // construct all parameters from Resource
        var finalHeader = [
            "Accept": "application/json"
        ]
        var finalParams = [String: String]()
        
        
        if let header = resource.headers{
            finalHeader = finalHeader.merging(header, uniquingKeysWith: { (_, last) in last })
        }
        
        if let param = resource.params{
            finalParams = param
        }
        
        
        // construct and modify url components
        var urlComponents = URLComponents(url: resource.url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = finalParams.map {URLQueryItem(name: $0, value: $1)}
        
        //         construct url request
        guard let url  = urlComponents?.url else {return}
        var urlRequest = URLRequest(url: url)
        
        
        if resource.httpMethod == .post || resource.httpMethod == .put {
            
            urlRequest = URLRequest(multipartFormData: { (formData) in
                
                if let data = resource.data{
                    formData.append(file: data, name: "avatar", fileName: "avatar.jpg", mimeType: "image/jpeg")
                }
                
                _ = finalParams.map {formData.append(value: $1, name: $0)}
                
            }, url: resource.url
            )
            
        }
        
        // modify url request
        _ = finalHeader.map {urlRequest.addValue($1, forHTTPHeaderField: $0)}
        urlRequest.httpMethod = resource.httpMethod.rawValue
        
        
        
        
        // Network call
        URLSessionConfiguration.default.timeoutIntervalForRequest = 20
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, err) in
            
            DispatchQueue.main.async {
                if let err = err{
                    completion(.failure(NetworkError.err(err)))
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    
                    switch response.statusCode {
                    case (200...299), 422, 403:
                        do{
                            guard let data = data else {throw NetworkError.other("No Data")}
                            completion(.success(try JSONDecoder().decode(T.self, from: data)))
                        }catch (let err){
                            completion(.failure(NetworkError.err(err)))
                        }
                    case 401:
                        completion(.failure(NetworkError.other("Error: Unauthorized, (\(response.statusCode))")))
                    case 404:
                        completion(.failure(NetworkError.other("Error: Not found, (\(response.statusCode))")))
                    case 500:
                        completion(.failure(NetworkError.other("Error: Server error, (\(response.statusCode))")))
                    default:
                        completion(.failure(NetworkError.other("Error: Status code \(response.statusCode)")))
                    }
                    
                }
            }
            
        }).resume()
        print("URL request : /nURL:\(urlRequest)")
        print("PERFORM NETWORK WITH RESOURCE: \(resource), with final header: \(finalHeader)")
        
        
        
    }
    
    
}


extension URLRequest {
    public enum HTTPMethod: String {
        case connect
        case delete
        case get
        case head
        case options
        case patch
        case post
        case put
        case trace
    }
    
    class MultipartFormData {
        var request: URLRequest
        private lazy var boundary: String = {
           return String(format: "%08X%08X", arc4random(), arc4random())
        }()
        
        init(request: URLRequest) {
            self.request = request
        }
        
        func append(value: String, name: String) {
            request.httpBody?.append("--\(boundary)\r\n".data())
            request.httpBody?.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data())
            request.httpBody?.append("\(value)\r\n".data())
        }
        
        func append(filePath: String, name: String) throws {
            let url = URL(fileURLWithPath: filePath)
            try append(fileUrl: url, name: name)
        }
        
        func append(fileUrl: URL, name: String) throws {
            let fileName = fileUrl.lastPathComponent
            let mimeType = contentType(for: fileUrl.pathExtension)
            try append(fileUrl: fileUrl, name: name, fileName: fileName, mimeType: mimeType)
        }
        
        func append(fileUrl: URL, name: String, fileName: String, mimeType: String) throws {
            let data = try Data(contentsOf: fileUrl)
            append(file: data, name: name, fileName: fileName, mimeType: mimeType)
        }
        
        func append(file: Data, name: String, fileName: String, mimeType: String) {
            request.httpBody?.append("--\(boundary)\r\n".data())
            request.httpBody?.append("Content-Disposition: form-data; name=\"\(name)\";".data())
            request.httpBody?.append("filename=\"\(fileName)\"\r\n".data())
            request.httpBody?.append("Content-Type: \(mimeType)\r\n\r\n".data())
            request.httpBody?.append(file)
            request.httpBody?.append("\r\n".data())
        }
        
        fileprivate func finalize() {
            request.httpBody?.append("--\(boundary)--\r\n".data())
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        }
    }
    
    init(multipartFormData constructingBlock: @escaping (_ formData: MultipartFormData) -> Void,
         url: URL,
         method: HTTPMethod = .post,
         headers: [String: String] = [:])
    {
        self.init(url: url)
        self.httpMethod = method.rawValue.uppercased()
        self.httpBody = Data()
        let formData = MultipartFormData(request: self)
        constructingBlock(formData)
        formData.finalize()
        self = formData.request
        for (k,v) in headers {
            self.addValue(v, forHTTPHeaderField: k)
        }
    }
}

fileprivate func contentType(for pathExtension: String) -> String {
    guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeRetainedValue() else {
        return "application/octet-stream"
    }
    let contentTypeCString = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue()
    guard let contentType = contentTypeCString as String? else {
        return "application/octet-stream"
    }
    return contentType
}

fileprivate extension String {
    func data() -> Data {
        return self.data(using: .utf8) ?? Data()
    }
}
