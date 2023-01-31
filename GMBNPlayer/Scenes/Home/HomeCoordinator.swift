//
//  HomeCoordinator.swift
//  PocketWorld
//
//  Created by Cristiano Calicchia on 06/12/22.
//

import Foundation
import SwiftUI

class HomeCoordinator: ObservableObject, Identifiable {

	@Published var viewModel: DashboardViewModel!
	@Published var videoDetailViewModel: VideoDetailViewModel?
	
	private let dataProvider: DataProvider
	
	init(title: String,
		 dataProvider: DataProvider) {
		self.dataProvider = dataProvider
		
		self.viewModel = .init(
			title: title,
			dataProvider: dataProvider,
			coordinator: self
		)
	}

	func open(_ video: VideoDetail) {
		self.videoDetailViewModel = .init(coordinator: self, video: video, dataProvider: dataProvider)
	}
	
	func close() {
		self.videoDetailViewModel = nil
	}
	
}
