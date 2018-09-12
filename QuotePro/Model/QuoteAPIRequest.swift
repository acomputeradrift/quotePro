//
//  QuoteAPIRequest.swift
//  QuotePro
//
//  Created by Jamie on 2018-09-12.
//  Copyright © 2018 Jamie. All rights reserved.
//

import Foundation

enum QuoteAPIError: Error {
    case badURL
    case requestError
    case invalidJSON
    case parsingError
}

class QuoteAPIRequest {
    
    var networker: NetworkerType
    
    init(networker: NetworkerType) {
        self.networker = networker
    }
}

/// Methods that should be called by other classes
extension QuoteAPIRequest {
    func getNewQuote (completionHandler: @escaping (Quote?, Error?) -> Void) {
        
        guard let url = buildURL(endpoint: "?method=getQuote&lang=en&format=json") else {
            completionHandler(nil, QuoteAPIError.badURL)
            return
        }
        
        self.networker.requestData(with: url) { (data, urlRequest, error) in
            
            var json: [String: Any] = [:]
            var result: Quote? = nil
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
//http://api.forismatic.com/api/1.0/?method=getQuote&lang=en&format=json

/// URL
extension QuoteAPIRequest {
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
extension QuoteAPIRequest {
    
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
    func parseQuoteDetails(fromJSON json: [String: Any]) throws -> Quote? {
        guard let content = json["quoteText"] as? String else {
            throw QuoteAPIError.parsingError
        }
        guard let author = json["quoteAuthor"] as? String else {
            throw QuoteAPIError.parsingError
        }
        let newQuote = Quote(content: content, author: author)
        return newQuote
}
}

