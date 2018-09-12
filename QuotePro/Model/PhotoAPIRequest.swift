//
//  PhotoAPIRequest.swift
//  QuotePro
//
//  Created by Jamie on 2018-09-12.
//  Copyright © 2018 Jamie. All rights reserved.
//

import Foundation

enum PhotoAPIError: Error {
    case badURL
    case requestError
    case invalidJSON
    case parsingError
}

class PhotoAPIRequest {
    
    var networker: NetworkerType
    
    init(networker: NetworkerType) {
        self.networker = networker
    }
}

/// Methods that should be called by other classes
extension PhotoAPIRequest {
    func getUpdatedList (completionHandler: @escaping ([Photo], Error?) -> Void) {
        
        guard let url = buildURL(endpoint: "list") else {
            completionHandler([], QuoteAPIError.badURL)
            return
        }
        
        self.networker.requestData(with: url) { (data, urlRequest, error) in
            var json: [[String:Any]] = []
            var result = [Photo]()
            do {
                json = try self.jsonObject(fromData: data, response: urlRequest, error: error)
                result = try self.parseQuoteDetails(fromJSON: json)
            } catch let error {
                completionHandler([], error)
                return
            }
            
            completionHandler(result, nil)
        }
    }
}

/// URL
extension PhotoAPIRequest {
    func buildURL(endpoint: String) -> URLRequest? {
        var componenets = URLComponents()
        componenets.scheme = "https"
        componenets.host = "picsum.photos"
        
        guard var componentsURL = componenets.url else{
            print("could not buld URL request")
            return nil
        }
        componentsURL = componentsURL.appendingPathComponent(endpoint)
        let urlRequest = URLRequest(url: componentsURL)
        return urlRequest
    }
}

/// JSON Parsing
extension PhotoAPIRequest {
    
    func jsonObject(fromData data: Data?, response: URLResponse?, error: Error?) throws -> [[String: Any]]{
        if let error = error {
            throw error
        }
        guard let data = data else {
            throw QuoteAPIError.requestError
        }
        return try jsonObject(fromData: data)
    }
    func jsonObject(fromData data: Data) throws -> [[String: Any]] {
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        
        guard let results = jsonObject as? [[String: Any]] else {
            throw QuoteAPIError.invalidJSON
        }
        return results
    }
    
    // Parse Photo Details
    func parseQuoteDetails(fromJSON json: [[String: Any]]) throws -> [Photo] {
        var photoArray = [Photo]()
        for index in json {
            guard let id = index["id"] as? Int else {
                throw QuoteAPIError.parsingError
            }
            guard let url = index["post_url"] as? String else {
                throw QuoteAPIError.parsingError
            }
            guard let width = index["width"] as? Int else {
                throw QuoteAPIError.parsingError
            }
            guard let height = index["height"] as? Int else {
                throw QuoteAPIError.parsingError
            }
            let newPhoto = Photo(id: id, url: url, width: width, height: height)
            photoArray.append(newPhoto)
        }
        return photoArray
    }
}
