//
//  GMBNPlayerTests.swift
//  GMBNPlayerTests
//
//  Created by Cristiano Calicchia on 31/01/23.
//

import XCTest
import Combine
@testable import GMBNPlayer

final class GMBNPlayerTests: XCTestCase {
	
	func testFetchVideosService_KO() async throws {
		do {
			let sut = DataProvider(communicationManager: CommunicationManagerMock(success: false))
			try await sut.fetchVideosIds(page: nil)
		} catch {
			let error = error as? APIError
			XCTAssertTrue(error == .apiError(reason: "Unknown error"))
		}
	}
	
	func testFetchVideosService_OK() async throws {
		do {
			var videoList : VideoList? = nil
			let sut = DataProvider(communicationManager: CommunicationManagerMock(success: true))
			videoList = try await sut.fetchVideosIds(page: nil)
			XCTAssertTrue(videoList != nil)
		} catch {
			XCTAssertTrue(false)
		}
	}
	
	func testFetchVideosDetailsService_KO() async throws {
		do {
			let sut = DataProvider(communicationManager: CommunicationManagerMock(success: false))
			try await sut.fetchVideosDetails(ids: [])
		} catch {
			let error = error as? APIError
			XCTAssertTrue(error == .apiError(reason: "Unknown error"))
		}
	}
	
	func testFetchVideosDetailsService_OK() async throws {
		do {
			var video : [VideoDetail]? = nil
			let sut = DataProvider(communicationManager: CommunicationManagerMock(success: true))
			video = try await sut.fetchVideosDetails(ids: [])
			XCTAssertTrue(video != nil)
		} catch {
			XCTAssertTrue(false)
		}
	}
	
	func testFetchVideoCommentsService_KO() async throws {
		do {
			let sut = DataProvider(communicationManager: CommunicationManagerMock(success: false))
			try await sut.fetchComments(id: "", page: nil)
		} catch {
			let error = error as? APIError
			XCTAssertTrue(error == .apiError(reason: "Unknown error"))
		}
	}

	func testFetchVideoCommentsService_OK() async throws {
		do {
			var comments : Comments? = nil
			let sut = DataProvider(communicationManager: CommunicationManagerMock(success: true))
			comments = try await sut.fetchComments(id: "WmDdelzbyLE", page: nil)
			XCTAssertTrue(comments != nil)
		} catch {
			XCTAssertTrue(false)
		}
	}

}

class CommunicationManagerMock : CommunicationManagerProtocol {
	let success: Bool
	
	init(success: Bool) {
		self.success = success
	}
	
	func fetch<T>(url: URL) -> AnyPublisher<T, GMBNPlayer.APIError> where T : Decodable {
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
	
	func fetch(url: URL) -> AnyPublisher<Data, GMBNPlayer.APIError> {
		let request = URLRequest(url: url)

		return URLSession.DataTaskPublisher(request: request, session: .shared)
			.tryMap { data, response in
				if !self.success {
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
