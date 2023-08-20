//
//  APIService.swift
//  SearchMovieApp
//
//  Created by Alpay Calalli on 20.08.23.
//

import Foundation

class APIService {
    static let shared = APIService()
    private init() { }
    
    func fetch<T: Decodable>(_ type: T.Type, url: URLRequest?, completion: @escaping(Result<T, APIError>) -> Void) {
        
        guard let url = url else {
            let error = APIError.badURL
            completion(Result.failure(error))
            return
        }
       
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error as? URLError {
                completion(Result.failure(APIError.url(error)))
            } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(Result.failure(APIError.badResponse(statusCode: response.statusCode)))
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let decodedItems = try decoder.decode(type, from: data)
                    completion(Result.success(decodedItems))
                } catch {
                    completion(Result.failure(APIError.parsing(error as? DecodingError)))
                }
            }

        }
        task.resume()
        
    }
}
