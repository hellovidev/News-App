//
//  NetworkService.swift
//  News App
//
//  Created by Sergei Romanchuk on 03.09.2021.
//

import Foundation

class NetworkService {
    //GET https://newsapi.org/v2/everything?q=Apple&from=2021-09-04&sortBy=popularity&apiKey=API_KEY

    private var task: URLSessionTask?
    
    func request<Serializer: Deserializer>(
        parameters: [String: String]? = nil,
        path: Endpoint.Path,
        method: HTTPMethod,
        parser: Serializer,
        completion: @escaping (Result<Serializer.Response, Error>) -> Void
    ) {
        let endpoint = Endpoint.baseURL.rawValue + path.rawValue
        var defaultParameters = ["apiKey": API_KEY]
        
        if let additional = parameters {
            defaultParameters = defaultParameters.merging(additional) { (current, _) in current }
        }
        
        var components = URLComponents(string: endpoint)
        
        components?.queryItems = defaultParameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        guard let url = components?.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        request(request: urlRequest) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try parser.parse(data: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func cancel() {
        task?.cancel()
    }
    
    private func request(
        request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let session = URLSession(configuration: .default)
        task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.noHttpResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            let result = self.handleNetworkResponse(response)
            
            switch result {
            case .success(let message):
                print(message)
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        task?.resume()
    }
    
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String, Error> {
        switch response.statusCode {
        case ...299:
            return .success("Status code: \(response.statusCode)")
        case ...499:
            return .failure(NetworkError.authentificationError)
        case ...599:
            return .failure(NetworkError.badRequest)
        case 600:
            return .failure(NetworkError.outdated)
        default:
            return .failure(NetworkError.failed)
        }
    }
    
    func loadImageByURL(endpoint: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        request(request: urlRequest, completion: completion)
    }
    
}
