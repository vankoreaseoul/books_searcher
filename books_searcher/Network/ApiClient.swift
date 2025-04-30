//
//  ApiClient.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/29/25.
//

import Foundation
import Combine

protocol ApiRequest {
    var baseURL: URL { get }
    var path: String { get }
    var method: String { get }
}

class ApiClient {
    
    static let shared = ApiClient()
    private init() {}
    
    func request<T: Codable>(_ apiRequest: ApiRequest) -> AnyPublisher<T, ApiError> {
        do {
            let request = try makeRequest(apiRequest)
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { [weak self] result in
                    guard let hasSelf = self else { throw ApiError.selfDeallocated }
                    try hasSelf.validateResponse(result.response)
//                    print("data = \(String(data: result.data, encoding: .utf8))")
                    return result.data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .mapError { self.handleError($0) }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
            
        } catch {
            return Fail(error: handleError(error))
                .eraseToAnyPublisher()
        }
    }
    
    private func makeRequest(_ apiRequest: ApiRequest) throws -> URLRequest {
        let components = URLComponents(url: apiRequest.baseURL.appendingPathComponent(apiRequest.path), resolvingAgainstBaseURL: false)
        guard let url = components?.url else { throw ApiError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = apiRequest.method
        return request
    }

    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else { throw ApiError.unknown }
        guard (200...299).contains(httpResponse.statusCode) else { throw ApiError.responseError(res: httpResponse) }
    }

    private func handleError(_ error: Error) -> ApiError {
        if let apiError = error as? ApiError {
            return apiError
        } else if error is DecodingError {
            return .decodingError
        } else {
            return .networkError(error)
        }
    }
    
    
    
}
