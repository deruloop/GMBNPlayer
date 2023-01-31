//
//  CityListDataProvider.swift
//  PocketWorld
//
//  Created by Cristiano Calicchia on 03/12/22.
//

import Foundation
import Combine

protocol DataProviderProtocol {
	func fetchVideosDetails(ids: [String]) async throws -> [VideoDetail]
	func fetchVideosIds(page: String?) async throws -> VideoList
	func fetchComments(id: String, page: String?) async throws -> Comments
}

protocol CallServiceCompliant: AnyObject {
	func fetch<T: Decodable>(url: URL) -> AnyPublisher<T, APIError>
}

public class DataProvider : DataProviderProtocol {
	let communicationManager : CommunicationManagerProtocol
	private var cancellables = Set<AnyCancellable>()
	
	init(communicationManager: CommunicationManagerProtocol) {
		self.communicationManager = communicationManager
	}
	
	func fetchVideosDetails(ids: [String]) async throws -> [VideoDetail] {
		
		try await withCheckedThrowingContinuation { continuation in
					
			var components = URLComponents()
			components.scheme = "https"
			components.host = "www.googleapis.com"
			components.path = "/youtube/v3/videos"
			components.queryItems = [
				URLQueryItem(name: "part", value: "snippet,contentDetails"),
				URLQueryItem(name: "id", value: ids.joined(separator: ",")),
				URLQueryItem(name: "key", value: "AIzaSyBxTODcXfJY6kp-ys0zVenzS1B2LoUWlCE")
			]
			
			
			if let url = components.url {
				communicationManager.fetch(url: url)
					.sink(receiveCompletion: { completion in
						switch completion {
						case .finished:
							break
						case .failure(let error):
							continuation.resume(throwing: error)
						}
					}, receiveValue: { (videoDetails: VideoDetails) in
						continuation.resume(returning: videoDetails.items)
					})
					.store(in: &cancellables)
			}
			
		}
		
	}
	
	func fetchVideosIds(page: String?) async throws -> VideoList {
		
		try await withCheckedThrowingContinuation { continuation in
					
			var components = URLComponents()
			components.scheme = "https"
			components.host = "www.googleapis.com"
			components.path = "/youtube/v3/playlistItems"
			components.queryItems = [
				URLQueryItem(name: "order", value: "date"),
				URLQueryItem(name: "part", value: "contentDetails"),
				URLQueryItem(name: "playlistId", value: "UU_A--fhX5gea0i4UtpD99Gg"),
				URLQueryItem(name: "maxResults", value: "10"),
				URLQueryItem(name: "key", value: "AIzaSyBxTODcXfJY6kp-ys0zVenzS1B2LoUWlCE")
			]
			
			if let page = page {
				components.queryItems?.append(URLQueryItem(name: "pageToken", value: page))
			}
			
			if let url = components.url {
				communicationManager.fetch(url: url)
					.sink(receiveCompletion: { completion in
						switch completion {
						case .finished:
							break
						case .failure(let error):
							continuation.resume(throwing: error)
						}
					}, receiveValue: { (videoList: VideoList) in
						continuation.resume(returning: videoList)
					})
					.store(in: &cancellables)
			}
			
		}
		
	}
	
	func fetchComments(id: String, page: String?) async throws -> Comments {
		
		try await withCheckedThrowingContinuation { continuation in
					
			var components = URLComponents()
			components.scheme = "https"
			components.host = "www.googleapis.com"
			components.path = "/youtube/v3/commentThreads"
			components.queryItems = [
				URLQueryItem(name: "order", value: "time"),
				URLQueryItem(name: "part", value: "snippet"),
				URLQueryItem(name: "videoId", value: id),
				URLQueryItem(name: "key", value: "AIzaSyBxTODcXfJY6kp-ys0zVenzS1B2LoUWlCE")
			]
			
			if let page = page {
				components.queryItems?.append(URLQueryItem(name: "pageToken", value: page))
			}
			
			if let url = components.url {
				print(url)
				communicationManager.fetch(url: url)
					.sink(receiveCompletion: { completion in
						switch completion {
						case .finished:
							break
						case .failure(let error):
							continuation.resume(throwing: error)
						}
					}, receiveValue: { (comments: Comments) in
						continuation.resume(returning: comments)
					})
					.store(in: &cancellables)
			}
			
		}
		
	}
	
}
