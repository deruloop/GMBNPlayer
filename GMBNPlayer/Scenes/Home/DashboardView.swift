//
//  CountriesView.swift
//  PocketWorld
//
//  Created by Cristiano Calicchia on 03/12/22.
//

import SwiftUI
import Combine

struct DashboardView: View {
	
	init(viewModel: DashboardViewModel) {
		self.viewModel = viewModel
	}
	
	@ObservedObject var viewModel: DashboardViewModel

	var body: some View {
		ZStack {
			
			Rectangle()
				.fill(appBackground)
				.edgesIgnoringSafeArea(.all)

			ScrollView {
				VStack(alignment: .center) {
					HStack {
						Spacer()
						
						Text("GMBN Videos")
							.font(.title).bold()
						
						Spacer()
						
						Button {
							Task {
								await viewModel.getData()
							}
						} label: {
							Image(systemName: "arrow.clockwise")
								.font(.title2.bold())
						}
					}
					.padding(.horizontal)
					
					if viewModel.isLoading {
						ShimmerGMBNRowView()
					} else {
						ForEach(Array(viewModel.videos.enumerated()), id: \.offset) { _,video in
							
							VideoRow(videoDetail: video)
								.onNavigation { viewModel.open(video) }
						}
					}
					
					if viewModel.nextPage != "" {
						if viewModel.isLoadingMore {
							ShimmerView()
								.frame(height:300)
								.padding(.horizontal)
								.padding(.bottom, 4)
						} else {
							Button {
								Task {
									await viewModel.loadNextPage()
								}
							} label: {
								Text("Load more...")
							}
							.buttonStyle(LoadMoreButtonStyle(width: 225, font: Font.title2.bold()))
							.padding(.top, 20)
							.padding(.bottom, 100)
						}
						
					}
				}
			}
		}
		.onAppear {
			viewModel.onAppear()
		}
		.alert(isPresented: $viewModel.networkErrorAlert) {
			Alert(title: Text("Error"), message: Text(viewModel.apiError?.errorDescription ?? "Generic Error"), dismissButton: .default(Text("Try again!")) {
				Task {
					await viewModel.getData()
				}
			})
		}
		.navigationBarHidden(true)
	}
}

struct VideoRow : View {

	var videoDetail: VideoDetail

	var body: some View {

		ZStack {
			RoundedRectangle(cornerRadius: 16).fill(secondaryBackgroundColor)
			
			VStack(alignment: .leading) {
				ZStack(alignment: .bottom) {
					LazyVStack {
						Image(systemName: "placeholder image")
							.data(url: URL(string: videoDetail.snippet.thumbnails.high.url)!)
							.aspectRatio(contentMode: .fill)
							.cornerRadius(10)
					}
					
					HStack {
						Text(videoDetail.contentDetails.formattedDuration)
							.font(.headline.bold())
							.foregroundColor(customAccentColor)
						Spacer()
					}
					.frame(height: 30)
					.padding(.horizontal, 8)
					
				}
				
				HStack {
					VStack(alignment: .leading) {
						Text(videoDetail.snippet.title)
							.font(.title2.bold())
							.multilineTextAlignment(.leading)
						Text(videoDetail.snippet.formattedDate)
							.font(.body)
					}
					Spacer()
					Image(systemName: "chevron.right")
				}
				.foregroundColor(customAccentColor)
			}
			.padding(.horizontal)
			.padding(.vertical, 8)
		}
		.padding(.horizontal)
		.padding(.bottom, 4)
	}
}

//MARK: Shimmer

struct ShimmerGMBNRowView: View {
	
	@ViewBuilder
	private var shimmerRow: some View {
		ShimmerView()
			.frame(height:300)
			.padding(.horizontal)
			.padding(.bottom, 4)
	}
	
	var body: some View {
	
		ScrollView {
			
			ForEach(1..<20) {_ in
				shimmerRow
			}
			
		}
		
	}
}

//struct ContentView_Preview: PreviewProvider {
//	static var previews: some View {
//		CountriesView(viewModel: CountriesViewModel(dataProvider: DataProvider()))
//	}
//}
