//
//  Networking.swift
//  GMBNPlayer
//
//  Created by Cristiano Calicchia on 31/01/23.
//

import Foundation
import Combine

protocol CommunicationManagerProtocol {
	func fetch<T: Decodable>(url: URL) -> AnyPublisher<T, APIError>
	func fetch(url: URL) -> AnyPublisher<Data, APIError>
}

class CommunicationManager : CommunicationManagerProtocol {
	
	func fetch<T: Decodable>(url: URL) -> AnyPublisher<T, APIError> {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		
		return fetch(url: url)
			.decode(type: T.self, decoder: decoder)
			.mapError { error in
				if let error = error as? DecodingError {
					var errorToReport = error.localizedDescription
					switch error {
					case .dataCorrupted(let context):
						let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
						errorToReport = "\(context.debugDescription) - (\(details))"
					case .keyNotFound(let key, let context):
						let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
						errorToReport = "\(context.debugDescription) (key: \(key), \(details))"
					case .typeMismatch(let type, let context), .valueNotFound(let type, let context):
						let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
						errorToReport = "\(context.debugDescription) (type: \(type), \(details))"
					@unknown default:
						break
					}
					return APIError.parserError(reason: errorToReport)
				}  else {
					return APIError.apiError(reason: error.localizedDescription)
				}
			}
			.eraseToAnyPublisher()
	}
	
	func fetch(url: URL) -> AnyPublisher<Data, APIError> {
		let request = URLRequest(url: url)

		return URLSession.DataTaskPublisher(request: request, session: .shared)
			.tryMap { data, response in
				guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
					throw APIError.unknown
				}
				return data
			}
			.mapError { error in
				if let error = error as? APIError {
					return error
				} else {
					return APIError.apiError(reason: error.localizedDescription)
				}
			}
			.eraseToAnyPublisher()
	}
	
}
