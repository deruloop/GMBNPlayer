//
//  CountryViewModel.swift
//  PocketWorld
//
//  Created by Cristiano Calicchia on 06/12/22.
//

import Foundation

public class VideoDetailViewModel : ObservableObject, Identifiable {
	
	@Published var video: VideoDetail
	@Published var comments: [Comment]? = nil
	@Published var networkErrorAlert: Bool = false
	var apiError: APIError? = nil
	var nextPage: String = ""
	private unowned let coordinator: HomeCoordinator
	
	private var dataProvider: DataProvider
	
	init(coordinator: HomeCoordinator, video: VideoDetail, dataProvider: DataProvider) {
		self.coordinator = coordinator
		self.video = video
		self.dataProvider = dataProvider
	}
	
	func close() {
		self.coordinator.close()
	}
	
	@MainActor
	func loadNextPage() async {
		let comments = await fetchComments(page: nextPage)
		if let comments = comments {
			self.comments = (self.comments ?? []) + comments
		}
	}
	
	func fetchComments(page: String?) async -> [Comment]?  {
		
		var comments : [Comment]? = nil
		
		do {
			let commentsDecoded = try await dataProvider.fetchComments(id: video.id, page: page)
			self.nextPage = commentsDecoded.nextPageToken ?? ""
			comments = commentsDecoded.items
			
		} catch {
			apiError = error as? APIError
			Task {
				await MainActor.run {
					networkErrorAlert.toggle()
				}
			}
		}
		
		return comments
		
	}
	
	@MainActor
	func getData() async {
		self.comments = await fetchComments(page: nil)
	}
	
	// MARK: - entrypoint
	func onAppear() {
		
		Task {
			await getData()
		}
		
	}
	
}
