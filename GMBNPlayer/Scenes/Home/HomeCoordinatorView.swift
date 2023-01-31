//
//  Homecoo.swift
//  PocketWorld
//
//  Created by Cristiano Calicchia on 06/12/22.
//

import Foundation
import SwiftUI

struct HomeCoordinatorView: View {
	
	@ObservedObject var coordinator: HomeCoordinator
	
	var body: some View {
		NavigationView {
			DashboardView(viewModel: coordinator.viewModel)
				.navigation(item: $coordinator.videoDetailViewModel) { viewModel in
					videoDetailView(viewModel)
				}
		}.accentColor(customAccentColor)
	}
	
	@ViewBuilder
	private func videoDetailView(_ viewModel: VideoDetailViewModel) -> some View {
		VideoDetailView(
			viewModel: viewModel
		)
	}
}
