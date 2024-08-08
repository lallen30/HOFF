//
//  APIManager.swift
//  Youtube MVVM Products
//
//  Created by Yogesh Patel on 23/12/22.
//

import Foundation
import UIKit


// Singleton Design Pattern
// final - inheritance nahi hoga theek hai final ho gya

enum DataError: Error {
    case invalidResponse(Data?)
    case invalidURL
    case invalidData
    case network(Error?)
    case tokenExpired
}

// typealias Handler = (Result<[Product], DataError>) -> Void

typealias Handler<T> = (Result<T, DataError>) -> Void

final class APIManager {
    
    static let shared = APIManager()
    private init() {}
    
    func requestPost<T: Codable>(
        modelType: T.Type,
        type: EndPointType,
        header: Bool,
        completion: @escaping Handler<T>
    ) {
        print("API Request - - - - - - - - - - >>>>>")
        guard let url = type.url else {
            completion(.failure(.invalidURL))
            return
        }
        print("URL >> \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = type.method.rawValue
        print("Method >> \(type.method.rawValue)")
        if let parameters = type.body {
            request.httpBody = try? JSONEncoder().encode(parameters)
            print("Parameters >> \(parameters)")
        }
        
        
        request.allHTTPHeaderFields = type.headers
        if header {
//            if let token: String = UserDefaults.accessToken {
                request.allHTTPHeaderFields = ["Authorization":"\(UserDefaults.accessToken)"]
//            }
        }
        
        print("Headers >>> \(request.allHTTPHeaderFields ?? [:])")
        
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 120
        URLSession(configuration: config).dataTask(with: request) { data, response, error in
            guard let data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            guard let response = response as? HTTPURLResponse,
                  200 ... 599 ~= response.statusCode else {
                do {
                    let products = try JSONDecoder().decode(modelType, from: data)
                    completion(.success(products))
                }catch {
                    completion(.failure(.invalidResponse(data)))
                }
                return
            }
            // JSONDecoder() - Data ka Model(Array) mai convert karega
            
//            guard response.statusCode != 401 else {
//                completion(.failure(.tokenExpired))
//                return
//            }
            
            do {
                print("API Response >>> \(String(data: data, encoding: .utf8) ?? "")")
                let products = try JSONDecoder().decode(modelType, from: data)
                completion(.success(products))
            }catch {
                completion(.failure(.network(error)))
            }
            
        }.resume()
        
    }
    
    
    func dictionaryRequest<T: Codable>(
        modelType: T.Type,
        type: EndPointType,
        header: Bool,
        completion: @escaping Handler<T>
    ) {
        print("API Request - - - - - - - - - - >>>>>")
        guard let url = type.url else {
            completion(.failure(.invalidURL))
            return
        }
        print("URL >> \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = type.method.rawValue
        print("Method >> \(type.method.rawValue)")
        if JSONSerialization.isValidJSONObject(type.jsonBody!) {
            if let parameters = type.jsonBody {
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
                print("Parameters >> \(parameters)")
            }
        }
        request.allHTTPHeaderFields = type.headers
        if header {
//            if let token: String = UserDefaults.accessToken {
                request.allHTTPHeaderFields = ["Authorization":"\(UserDefaults.accessToken)"]
//            }
        }
        print("Headers >>> \(request.allHTTPHeaderFields ?? [:])")
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 120
        URLSession(configuration: config).dataTask(with: request) { data, response, error in
            guard let data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            guard let response = response as? HTTPURLResponse,
                  200 ... 599 ~= response.statusCode else {
                do {
                    let products = try JSONDecoder().decode(modelType, from: data)
                    completion(.success(products))
                }catch {
                    completion(.failure(.invalidResponse(data)))
                }
                return
            }
            // JSONDecoder() - Data ka Model(Array) mai convert karega
            do {
                print("API Response >>> \(String(data: data, encoding: .utf8) ?? "")")
                let products = try JSONDecoder().decode(modelType, from: data)
                completion(.success(products))
            }catch {
                completion(.failure(.network(error)))
            }
            
        }.resume()
        
    }
    
    
    func requestGet<T: Codable>(modelType: T.Type,
                                type: EndPointType,
                                header: Bool,
                                parameters: [String: Any],
                                completion: @escaping Handler<T>
    ) {
        var urlComponents = URLComponents(string: type.url!.absoluteString)
        urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = type.method.rawValue
        request.allHTTPHeaderFields = type.headers
        if header{
            request.allHTTPHeaderFields = ["Authorization":"Bearer \(UserDefaults.accessToken)"]
        }
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 120
        URLSession(configuration: config).dataTask(with: request) { data, response, error in
            guard let data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            print(data)
            print(response as Any)
            guard let response = response as? HTTPURLResponse,
                  200 ... 599 ~= response.statusCode else {
                do {
                    print(type.body as Any)
                    let products = try JSONDecoder().decode(modelType, from: data)
                    completion(.success(products))
                }catch {
                    completion(.failure(.invalidResponse(data)))
                }
                return
            }
            // JSONDecoder() - Data ka Model(Array) mai convert karega
            do {
                let products = try JSONDecoder().decode(modelType, from: data)
                completion(.success(products))
            }catch {
                completion(.failure(.network(error)))
            }
        }.resume()
    }
    
    
    func postApiDataWithMultipartForm<T:Decodable>(
        type: EndPointType,
        imageRequest: ImageRequest,
        modelType: T.Type,
        header: Bool,
        completion: @escaping Handler<T>
    ){
        
        guard let url = type.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = type.method.rawValue
        
        if let parameters = type.body {
            request.httpBody = try? JSONEncoder().encode(parameters)
        }
        
        
        request.allHTTPHeaderFields = type.headers
        if header{
            request.allHTTPHeaderFields = ["Authorization":"Bearer \(UserDefaults.accessToken)"]
        }
        
        //        var urlRequest = URLRequest(url: requestUrl.url)
        let lineBreak = "\r\n"
        
        //        urlRequest.httpMethod = "post"
        let boundary = "---------------------------------\(UUID().uuidString)"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "content-type")
        
        var requestData = Data()
        
        requestData.append("--\(boundary)\r\n" .data(using: .utf8)!)
        requestData.append("content-disposition: form-data; name=\"attachment\" \(lineBreak + lineBreak)" .data(using: .utf8)!)
        requestData.append(imageRequest.attachment .data(using: .utf8)!)
        
        requestData.append("\(lineBreak)--\(boundary)\r\n" .data(using: .utf8)!)
        requestData.append("content-disposition: form-data; name=\"fileName\" \(lineBreak + lineBreak)" .data(using: .utf8)!)
        requestData.append("\(imageRequest.fileName + lineBreak)" .data(using: .utf8)!)
        
        requestData.append("--\(boundary)--\(lineBreak)" .data(using: .utf8)!)
        
        request.addValue("\(requestData.count)", forHTTPHeaderField: "content-length")
        request.httpBody = requestData
        
        // let multipartStr = String(decoding: requestData, as: UTF8.self) //to view the multipart form string
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 120
        URLSession(configuration: config).dataTask(with: request) { (data, response, error) in
            guard let data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            print(response as Any)
            guard let response = response as? HTTPURLResponse,
                  200 ... 599 ~= response.statusCode else {
                do {
                    print(type.body as Any)
                    let products = try JSONDecoder().decode(modelType, from: data)
                    completion(.success(products))
                }catch {
                    completion(.failure(.invalidResponse(data)))
                }
                return
            }
            // JSONDecoder() - Data ka Model(Array) mai convert karega
            do {
                let products = try JSONDecoder().decode(modelType, from: data)
                completion(.success(products))
            }catch {
                completion(.failure(.network(error)))
            }
            
        }.resume()
        
    }
    
    func uploadImage<T:Decodable>(
        type: EndPointType,
        image: UIImage,
        modelType: T.Type,
        header: Bool,
        completion: @escaping Handler<T>
    ) {
        print("API Request - - - - - - - - - - >>>>>")
        guard let url = type.url else {
            completion(.failure(.invalidURL))
            return
        }
        print("URL >> \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = type.method.rawValue
        print("Method >> \(type.method.rawValue)")
        
        let boundary = generateBoundary()
        
        guard let mediaImage = Media(withImage: image, forKey: "file") else { return }
        
        let params: [String: String] = [:]
        
//        if let role: String = UserDefaultsManager.shared.value(forKey: .userRole) {
//            params["folder"] = role
//        }
        
        request.allHTTPHeaderFields = type.headers
//        if header {
//            if let token: String = UserDefaultsManager.shared.value(forKey: .token) {
//                request.allHTTPHeaderFields = ["Authorization":"Bearer \(token)"]
//            }
//        }
        
        request.allHTTPHeaderFields = [
            "X-User-Agent": "ios",
            "Accept-Language": "en",
            "Accept": "application/json",
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]
        
        let dataBody = createDataBody(withParameters: params, media: [mediaImage], boundary: boundary)
        
        request.httpBody = dataBody
        
        print("Headers >>> \(request.allHTTPHeaderFields ?? [:])")
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 120
        
        URLSession(configuration: config).dataTask(with: request) { data, response, error in
            guard let data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            guard let response = response as? HTTPURLResponse,
                  200 ... 599 ~= response.statusCode else {
                do {
                    let products = try JSONDecoder().decode(modelType, from: data)
                    completion(.success(products))
                }catch {
                    completion(.failure(.invalidResponse(data)))
                }
                return
            }
            do {
                print("API Response >>> \(String(data: data, encoding: .utf8) ?? "")")
                let products = try JSONDecoder().decode(modelType, from: data)
                completion(.success(products))
            }catch {
                completion(.failure(.network(error)))
            }
            
        }.resume()
    }
    
//    func uploadVideo<T: Decodable>(
//        type: EndPointType,
//        videoURL: URL,
//        modalType: T.Type,
//        header: Bool,
//        completion: @escaping Handler<T>
//    ) {
//        print("API Request - - - - - - - - - - >>>>>")
//        guard let url = type.url else {
//            completion(.failure(.invalidURL))
//            return
//        }
//        print("URL >> \(url)")
//        var request = URLRequest(url: url)
//        request.httpMethod = type.method.rawValue
//        print("Method >> \(type.method.rawValue)")
//        
//        let boundary = generateBoundary()
//        
//        guard let media = MediaData(withURL: videoURL.absoluteString, forKey: "file[]") else { return }
//        
//        var params: [String: String] = [:]
//        
//        if let role: String = UserDefaultsManager.shared.value(forKey: .userRole) {
//            params["folder"] = role
//        }
//        
//        request.allHTTPHeaderFields = type.headers
//        if header {
//            if let token: String = UserDefaultsManager.shared.value(forKey: .token) {
//                request.allHTTPHeaderFields = ["Authorization":"Bearer \(token)"]
//            }
//        }
//        
//        request.allHTTPHeaderFields = [
//            "X-User-Agent": "ios",
//            "Accept-Language": "en",
//            "Accept": "application/json",
//            "Content-Type": "multipart/form-data; boundary=\(boundary)"
//        ]
//        
//        let dataBody = createDataBody1(withParameters: params, media: [media], boundary: boundary)
//        
//        request.httpBody = dataBody
//        
//        print("Headers >>> \(request.allHTTPHeaderFields ?? [:])")
//        
//        let config = URLSessionConfiguration.default
//        config.waitsForConnectivity = true
//        config.timeoutIntervalForResource = 120
//        
//        URLSession(configuration: config).dataTask(with: request) { data, response, error in
//            guard let data, error == nil else {
//                completion(.failure(.invalidData))
//                return
//            }
//            guard let response = response as? HTTPURLResponse,
//                  200 ... 599 ~= response.statusCode else {
//                do {
//                    let products = try JSONDecoder().decode(modalType, from: data)
//                    completion(.success(products))
//                }catch {
//                    completion(.failure(.invalidResponse(data)))
//                }
//                return
//            }
//            do {
//                print("API Response >>> \(String(data: data, encoding: .utf8) ?? "")")
//                let products = try JSONDecoder().decode(modalType, from: data)
//                completion(.success(products))
//            }catch {
//                completion(.failure(.network(error)))
//            }
//            
//        }.resume()
//    }
    
    func uploadFile<T: Decodable>(
        type: EndPointType,
        urlArray: [String],
        mimeType: String,
        modalType: T.Type,
        header: Bool,
        completion: @escaping Handler<T>
    ) {
        print("Upload File API Request - - - - - - - - - - >>>>>")
        guard let url = type.url else {
            completion(.failure(.invalidURL))
            return
        }
        print("URL >> \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = type.method.rawValue
        print("Method >> \(type.method.rawValue)")
        
        let boundary = generateBoundary()
        
        var media: [MediaData] = []
        
        urlArray.forEach { url in
            if url.contains("media") {
                guard let med = MediaData(withURL: "https://imperium.betaplanets.com/\(url)", forKey: "file[]", mimeType: mimeType) else { return }
                media.append(med)
            } else {
                guard let med = MediaData(withURL: url, forKey: "file[]", mimeType: mimeType) else { return }
                media.append(med)
            }
        }
    
        let params: [String: String] = [:]
        
//        if let role: String = UserDefaultsManager.shared.value(forKey: .userRole) {
//            params["folder"] = role
//        }
        
        request.allHTTPHeaderFields = type.headers
//        if header {
//            if let token: String = UserDefaultsManager.shared.value(forKey: .token) {
//                request.allHTTPHeaderFields = ["Authorization":"Bearer \(token)"]
//            }
//        }
        
        request.allHTTPHeaderFields = [
            "X-User-Agent": "ios",
            "Accept-Language": "en",
            "Accept": "application/json",
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]
        
        let dataBody = createDataBody1(withParameters: params, media: media, boundary: boundary)
        
        request.httpBody = dataBody
        
        print("Headers >>> \(request.allHTTPHeaderFields ?? [:])")
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 120
        
        URLSession(configuration: config).dataTask(with: request) { data, response, error in
            guard let data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            guard let response = response as? HTTPURLResponse,
                  200 ... 599 ~= response.statusCode else {
                do {
                    let products = try JSONDecoder().decode(modalType, from: data)
                    completion(.success(products))
                }catch {
                    completion(.failure(.invalidResponse(data)))
                }
                return
            }
            do {
                print("API Response >>> \(String(data: data, encoding: .utf8) ?? "")")
                let products = try JSONDecoder().decode(modalType, from: data)
                completion(.success(products))
            }catch {
                completion(.failure(.network(error)))
            }
            
        }.resume()
    }
    
    struct ImageRequest : Encodable {
        let attachment: String
        let fileName : String
    }
    
    static var commonHeaders: [String: String] {
        return [
            "Content-Type": "application/json"
        ]
    }
    
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}


struct Media {
    let key: String
    let fileName: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpg"
        self.fileName = "\(arc4random()).jpeg"
        
        guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }
        self.data = data
    }
}

struct MediaData {
    let key: String
    let fileName: String
    let data: Data
    let mimeType: String
    
    init?(withURL url: String, forKey key: String, mimeType type: String) {
        self.key = key
        self.mimeType = type
        self.fileName = "\(arc4random()).\(type.split(separator: "/").last ?? "")"
        
        do {
            self.data = try Data(contentsOf: URL(string: url)!, options: Data.ReadingOptions.alwaysMapped)
        } catch _ {
            self.data = Data()
        }
    }
}

func generateBoundary() -> String {
    return "Boundary-\(NSUUID().uuidString)"
}

func createDataBody(withParameters params: [String: Any]?, media: [Media]?, boundary: String) -> Data {
    
    let lineBreak = "\r\n"
    var body = Data()
    
    if let parameters = params {
        for (key, value) in parameters {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
            body.append("\("\(value)" + lineBreak)")
        }
    }
    
    if let media = media {
        for photo in media {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
            body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
            body.append(photo.data)
            body.append(lineBreak)
        }
    }
    
    body.append("--\(boundary)--\(lineBreak)")
    
    return body
}

func createDataBody1(withParameters params: [String: Any]?, media: [MediaData]?, boundary: String) -> Data {
    
    let lineBreak = "\r\n"
    var body = Data()
    
    if let parameters = params {
        for (key, value) in parameters {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
            body.append("\("\(value)" + lineBreak)")
        }
    }
    
    if let media = media {
        for photo in media {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
            body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
            body.append(photo.data)
            body.append(lineBreak)
        }
    }
    
    body.append("--\(boundary)--\(lineBreak)")
    
    return body
}
