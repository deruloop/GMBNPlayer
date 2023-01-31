//
//  CountriesViewModel.swift
//  PocketWorld
//
//  Created by Cristiano Calicchia on 03/12/22.
//

import Foundation

extension Identifiable where ID: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}

public class DashboardViewModel : ObservableObject {
	
	@Published var title: String
	@Published var videos: [VideoDetail] = []
	@Published var networkErrorAlert: Bool = false
	@Published var isLoading: Bool = false
	@Published var isLoadingMore: Bool = false
	var apiError: APIError? = nil
	var nextPage: String = ""
	private unowned let coordinator: HomeCoordinator
	
	private var dataProvider: DataProvider
	
	init(title: String, dataProvider: DataProvider, coordinator: HomeCoordinator) {
		self.title = title
		self.dataProvider = dataProvider
		self.coordinator = coordinator
	}
	
	func open(_ video: VideoDetail) {
		self.coordinator.open(video)
	}
	
	@MainActor
	func loadNextPage() async {
		isLoadingMore = true
		let videos = await fetchVideos(page: nextPage)
		self.videos = self.videos + videos
		isLoadingMore = false
	}
	
	func fetchVideos(page: String?) async -> [VideoDetail]  {
		
		var videoDetails : [VideoDetail] = []
		
		do {
			let videoList = try await dataProvider.fetchVideosIds(page: page)
			self.nextPage = videoList.nextPageToken ?? ""
			var ids : [String] = []
			for video in videoList.items {
				ids.append(video.contentDetails.videoId)
			}
			
			videoDetails = try await dataProvider.fetchVideosDetails(ids: ids)
			
		} catch {
			apiError = error as? APIError
			Task {
				await MainActor.run {
					networkErrorAlert.toggle()
				}
			}
		}
		
		return videoDetails
	}
	
	@MainActor
	func getData() async {
		isLoading = true
		self.videos = await fetchVideos(page: nil)
		isLoading = false
	}
	
	// MARK: - entrypoint
	func onAppear() {
		
		Task {
			await getData()
		}
		
	}
	
}
