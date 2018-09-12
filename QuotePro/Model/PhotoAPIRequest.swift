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
    func getNewPhoto (completionHandler: @escaping (Photo?, Error?) -> Void) {
        
        guard let url = buildURL(endpoint: "?method=getQuote&lang=en&format=json") else {
            completionHandler(nil, QuoteAPIError.badURL)
            return
        }
        
        self.networker.requestData(with: url) { (data, urlRequest, error) in
            
            var json: [String: Any] = [:]
            var result: Photo? = nil
            do {
                json = try self.jsonObject(fromData: data, response: urlRequest, error: error)
                result = try self.parseQuoteDetails(fromJSON: json)
            } catch let error {
                completionHandler(nil, error)
                return
            }
            
            completionHandler(result, nil)
        }
    }
}
// https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=85ce434a53c8eaef4a3f5b881794a5e3&tags=beach

/// URL
extension PhotoAPIRequest {
    func buildURL(endpoint: String) -> URLRequest? {
        var componenets = URLComponents()
        componenets.scheme = "http"
        componenets.host = "api.forismatic.com"
        
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
    
    func jsonObject(fromData data: Data?, response: URLResponse?, error: Error?) throws -> [String: String] {
        if let error = error {
            throw error
        }
        guard let data = data else {
            throw QuoteAPIError.requestError
        }
        return try jsonObject(fromData: data)
    }
    func jsonObject(fromData data: Data) throws -> [String: String] {
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        
        guard let results = jsonObject as? [String: String] else {
            throw QuoteAPIError.invalidJSON
        }
        return results
    }
    
    // Parse Quote Details
    func parseQuoteDetails(fromJSON json: [String: Any]) throws -> Photo? {
        guard let content = json["quoteText"] as? String else {
            throw QuoteAPIError.parsingError
        }
        guard let author = json["quoteAuthor"] as? String else {
            throw QuoteAPIError.parsingError
        }
        let newQuote = Photo(name: name, url: string)
        return newQuote
    }
}
