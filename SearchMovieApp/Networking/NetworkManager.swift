//
//  NetworkManager.swift
//  SearchMovieApp
//
//  Created by Alpay Calalli on 18.08.23.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    let baseUrl = "https://api.themoviedb.org/3/movie/"
    
    let cache = NSCache<NSString, UIImage>()
    
    func fetchMovies(type: MovieType, completion: @escaping(Result<MovieResponse, APIError>) -> Void ) {
        let headers = [
            "Authorization": Const.auth,
            "accept": Const.accept
        ]
        let endpointUrl = baseUrl + type.rawValue + "?language=en-US&page=1"
        var urlRequest = URLRequest(url: URL(string: endpointUrl)!)
        
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = headers
        
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if let _ = error {
                completion(.failure(APIError.badURL))
                return
            }
            
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(.failure(APIError.badResponse(statusCode: response.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.url(error as? URLError)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode(MovieResponse.self, from: data)
                completion(.success(followers))
            } catch {
                completion(.failure(APIError.parsing(error as? DecodingError)))
            }
        }
        
        task.resume()
        
        
    }
    
    func downloadImage(urlString: String, completion: @escaping(UIImage?) -> Void ) {
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completion(image)
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode),
                  let data = data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }

            
            self.cache.setObject(image, forKey: cacheKey)
            
            completion(image)
        }
        
        task.resume()
        
    }

}


enum APIError: Error, CustomStringConvertible {
    case badURL
    case badResponse(statusCode: Int)
    case url(URLError?)
    case parsing(DecodingError?)
    case unknown
    
    var localizedDescription: String {
        // for user
        switch self {
        case .badURL, .parsing, .unknown:
            return "Something went wrong"
        case .badResponse(_):
            return "Sorry, your connection lost with our server"
        case .url(let error):
            return error?.localizedDescription ?? "Something went wrong"
        }
    }
    
    var description: String {
        // for debugging
        switch self {
        case .badURL:
            return "Invalid URL"
        case .parsing(let error):
            return "parsing error: \(error?.localizedDescription ?? "")"
        case .badResponse(statusCode: let statusCode):
            return "Bad response with \(statusCode)"
        case .url(let error):
            return error?.localizedDescription ?? "url session over"
        case .unknown:
            return "Something went wrong"
        }
    }
}
