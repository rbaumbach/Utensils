import Foundation
import Capsule

public class PequenoNetworkingV2 {
    // MARK: - Private properties
    
    private let urlSession: URLSessionProtocol
    private let jsonSerializationWrapper: JSONSerializationWrapperProtocol
    private let jsonDecoder: JSONDecoderProtocol
    private let dispatchQueueWrapper: DispatchQueueWrapperProtocol
    
    // MARK: - Readonly properties
    
    public let baseURL: String
    public let headers: [String: String]?
        
    // MARK: - Init methods
    
    public init(baseURL: String,
                headers: [String: String]?,
                urlSession: URLSessionProtocol = URLSession.shared,
                jsonSerializationWrapper: JSONSerializationWrapperProtocol = JSONSerializationWrapper(),
                jsonDecoder: JSONDecoderProtocol = JSONDecoder(),
                dispatchQueueWrapper: DispatchQueueWrapperProtocol = DispatchQueueWrapper()) {
        self.baseURL = baseURL
        self.headers = headers
        self.urlSession = urlSession
        self.jsonSerializationWrapper = jsonSerializationWrapper
        self.jsonDecoder = jsonDecoder
        self.dispatchQueueWrapper = dispatchQueueWrapper
    }
    
    // MARK: - Public methods
    
    // MARK: - JSONSerialization (ol' skoo)
    
    public func get(endpoint: String,
                    parameters: [String: String]?,
                    completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        guard let urlRequest = buildURLRequest(httpMethod: "GET", 
                                               endpoint: endpoint,
                                               parameters: parameters) else {
            completionHandler(.failure(.requestError(String.empty)))
            
            return
        }
        
        executeJSONSerialization(urlRequest: urlRequest, completionHandler: completionHandler)
    }
    
    public func delete(endpoint: String,
                       parameters: [String: String]?,
                       completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        guard let urlRequest = buildURLRequest(httpMethod: "DELETE",
                                               endpoint: endpoint,
                                               parameters: parameters) else {
            completionHandler(.failure(.requestError(String.empty)))
            
            return
        }
        
        executeJSONSerialization(urlRequest: urlRequest, completionHandler: completionHandler)
    }
    
    public func post(endpoint: String,
                     body: [String: Any]?,
                     completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        guard let urlRequest = buildURLRequest(httpMethod: "POST",
                                               endpoint: endpoint,
                                               body: body) else {
            completionHandler(.failure(.requestError(String.empty)))
            
            return
        }
        
        executeJSONSerialization(urlRequest: urlRequest, completionHandler: completionHandler)
    }
    
    public func put(endpoint: String,
                    body: [String: Any]?,
                    completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        guard let urlRequest = buildURLRequest(httpMethod: "PUT",
                                               endpoint: endpoint,
                                               body: body) else {
            completionHandler(.failure(.requestError(String.empty)))
            
            return
        }
        
        executeJSONSerialization(urlRequest: urlRequest, completionHandler: completionHandler)
    }
    
    public func patch(endpoint: String,
                      body: [String: Any]?,
                      completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        guard let urlRequest = buildURLRequest(httpMethod: "PATCH",
                                               endpoint: endpoint,
                                               body: body) else {
            completionHandler(.failure(.requestError(String.empty)))
            
            return
        }
        
        executeJSONSerialization(urlRequest: urlRequest, completionHandler: completionHandler)
    }
    
    // MARK: - Codable
    
    public func get<T: Codable>(endpoint: String,
                                parameters: [String: String]?,
                                completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        guard let urlRequest = buildURLRequest(httpMethod: "GET",
                                               endpoint: endpoint,
                                               parameters: parameters) else {
            completionHandler(.failure(.requestError(String.empty)))
            
            return
        }
        
        executeCodable(urlRequest: urlRequest, completionHandler: completionHandler)
    }
    
    public func delete<T: Codable>(endpoint: String,
                                   parameters: [String: String]?,
                                   completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        guard let urlRequest = buildURLRequest(httpMethod: "DELETE",
                                               endpoint: endpoint,
                                               parameters: parameters) else {
            completionHandler(.failure(.requestError(String.empty)))
            
            return
        }
        
        executeCodable(urlRequest: urlRequest, completionHandler: completionHandler)
    }
    
    public func post<T: Codable>(endpoint: String,
                                 body: [String: Any]?,
                                 completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        guard let urlRequest = buildURLRequest(httpMethod: "POST",
                                               endpoint: endpoint,
                                               body: body) else {
            completionHandler(.failure(.requestError(String.empty)))
            
            return
        }
        
        executeCodable(urlRequest: urlRequest, completionHandler: completionHandler)
    }
    
    public func put<T: Codable>(endpoint: String,
                                body: [String: Any]?,
                                completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        guard let urlRequest = buildURLRequest(httpMethod: "PUT",
                                               endpoint: endpoint,
                                               body: body) else {
            completionHandler(.failure(.requestError(String.empty)))
            
            return
        }
        
        executeCodable(urlRequest: urlRequest, completionHandler: completionHandler)
    }
    
    public func patch<T: Codable>(endpoint: String,
                                  body: [String: Any]?,
                                  completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        guard let urlRequest = buildURLRequest(httpMethod: "PATCH",
                                               endpoint: endpoint,
                                               body: body) else {
            completionHandler(.failure(.requestError(String.empty)))
            
            return
        }
        
        executeCodable(urlRequest: urlRequest, completionHandler: completionHandler)
    }
    
    // MARK: - Private methods
    
    // MARK: - URLRequest - GET, DELETE
    
    private func buildURLRequest(httpMethod: String,
                                 endpoint: String,
                                 parameters: [String: String]?) -> URLRequest? {
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.path = endpoint
                
        urlComponents.queryItems = parameters?.map { (key, value) in
            return URLQueryItem(name: key, value: value)
        }
        
        guard let urlComponentsURL = urlComponents.url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: urlComponentsURL)
        urlRequest.httpMethod = httpMethod
        
        headers?.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
    
    // MARK: - URLRequest - POST, PUT, PATCH
    
    private func buildURLRequest(httpMethod: String,
                                 endpoint: String,
                                 body: Any?) -> URLRequest? {
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.path = endpoint
        
        guard let urlComponentsURL = urlComponents.url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: urlComponentsURL)
        urlRequest.httpMethod = httpMethod
        
        headers?.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        if let body = body {
            guard let body = try? JSONSerialization.data(withJSONObject: body) else {
                return nil
            }
            
            urlRequest.httpBody = body
        }
        
        return urlRequest
    }
    
    // MARK: - JSONSerialization (ol' skoo)
    
    private func executeJSONSerialization(urlRequest: URLRequest,
                                          completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        buildAndExecute(urlRequest: urlRequest) { [weak self] data, error in
            self?.handleResponseWithJSONSerializer(data: data, error: error) { [weak self] result in
                self?.dispatchQueueWrapper.mainAsync {
                    completionHandler(result)
                }
            }
        }
    }
    
    private func handleResponseWithJSONSerializer(data: Data?,
                                                  error: PequenoNetworking.Error?,
                                                  completionHandler: @escaping (Result<Any, PequenoNetworking.Error>) -> Void) {
        if let error = error {
            completionHandler(.failure(error))
            
            return
        }
        
        guard let data = data else {
            completionHandler(.failure(.dataError))
            
            return
        }
        
        let result: Result<Any, PequenoNetworking.Error>
        
        do {
            let jsonResponse = try self.jsonSerializationWrapper.jsonObject(with: data,
                                                                            options: .mutableContainers)
            
            result = .success(jsonResponse)
        } catch {
            result = .failure(.jsonObjectDecodeError(wrappedError: error))
        }
        
        completionHandler(result)
    }
    
    // MARK: - Codable
    
    private func executeCodable<T: Codable>(urlRequest: URLRequest,
                                            completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        buildAndExecute(urlRequest: urlRequest) { [weak self] data, error in
            self?.handleResponseOnCodable(data: data, error: error) { [weak self] result in
                self?.dispatchQueueWrapper.mainAsync {
                    completionHandler(result)
                }
            }
        }
    }
    
    private func handleResponseOnCodable<T: Codable>(data: Data?,
                                                     error: PequenoNetworking.Error?,
                                                     completionHandler: @escaping (Result<T, PequenoNetworking.Error>) -> Void) {
        if let error = error {
            completionHandler(.failure(error))
            
            return
        }
        
        guard let data = data else {
            completionHandler(.failure(.dataError))
            
            return
        }
        
        let result: Result<T, PequenoNetworking.Error>
        
        do {
            let jsonResponse = try self.jsonDecoder.decode(T.self, from: data)
            
            result = .success(jsonResponse)
        } catch {
            result = .failure(.jsonObjectDecodeError(wrappedError: error))
        }
        
        completionHandler(result)
    }
    
    // MARK: - URLSession execution
    
    private func buildAndExecute(urlRequest: URLRequest,
                                 completionHandler: @escaping (Data?, PequenoNetworking.Error?) -> Void) {
        let dataTask: URLSessionDataTaskProtocol = urlSession.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completionHandler(nil, .dataTaskError(wrappedError: error))
                
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(nil, .malformedResponseError)
                
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                completionHandler(nil, .invalidStatusCodeError(statusCode: response.statusCode))
                
                return
            }
            
            completionHandler(data, nil)
        }
        
        dataTask.resume()
    }
}
