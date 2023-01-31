//
//  CityView.swift
//  PocketWorld
//
//  Created by Cristiano Calicchia on 03/12/22.
//

import SwiftUI

struct VideoDetailView: View {
	
	@ObservedObject var viewModel: VideoDetailViewModel
	
	var body: some View {
		
		ZStack(alignment: .top) {
			Rectangle()
				.fill(appBackground)
				.edgesIgnoringSafeArea(.all)
			
			ScrollView {
				YouTubeView(videoId: viewModel.video.id)
					.frame(maxWidth: .infinity)
					.frame(height: 300)
					.padding(.horizontal)
				
				VStack(alignment: .leading, spacing: 5) {
					Text(viewModel.video.snippet.title)
						.font(.title2.bold())
					Text("Published: \(viewModel.video.snippet.formattedDate)")
						.font(.body.bold())
					Text("Duration: \(viewModel.video.contentDetails.formattedDuration)")
						.font(.body.bold())
					Text(viewModel.video.snippet.description)
						.font(.body)
					
					Text("Comments")
						.font(.title.bold())
						.padding(.top)
					
					if let comments = viewModel.comments {
						if !comments.isEmpty {
							ForEach(Array(comments.enumerated()), id: \.offset) { _,comment in
								CommentRow(comment: comment)
									.padding(.vertical, 4)
							}
							if viewModel.nextPage != "" {
								HStack {
									Spacer()
									Button {
										Task {
											await viewModel.loadNextPage()
										}
									} label: {
										Text("Load more...")
									}
									.buttonStyle(LoadMoreButtonStyle(width: 225, font: Font.title2.bold()))
									Spacer()
								}
								.padding(.bottom, 100)
								
							}
						} else {
							Text("No comments yet!")
								.font(.title2.bold().italic())
						}
					} else {
						Text("Could not load comments")
							.font(.title2.bold().italic())
					}
					
				}
				.padding(.horizontal)
			}
			.foregroundColor(customAccentColor)
		}
		.onAppear {
			viewModel.onAppear()
			let appearance = UINavigationBarAppearance()
				appearance.configureWithTransparentBackground()
				appearance.backgroundColor = navBarColor.withAlphaComponent(0.65)
				UINavigationBar.appearance().standardAppearance = appearance
		}
		.alert(isPresented: $viewModel.networkErrorAlert) {
			Alert(title: Text("Error"), message: Text(viewModel.apiError?.errorDescription ?? "Generic Error"), dismissButton: .default(Text("Ok")) {
			})
		}
//		.navigationBarHidden(true) TODO: navigazione bug
	}
}

struct CommentRow: View {
	var comment: Comment
	
	var body: some View {
		VStack(alignment:.leading) {
			Text(comment.snippet.topLevelComment.snippet.authorDisplayName)
				.font(.headline.bold())
			Text(comment.snippet.topLevelComment.snippet.textOriginal)
				.font(.body)
			Text(comment.snippet.topLevelComment.snippet.formattedDate)
				.font(.caption.bold())
		}
	}
}
