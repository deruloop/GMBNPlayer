//
//  YoutubeViewPlayer.swift
//  GMBNPlayer
//
//  Created by Cristiano Calicchia on 31/01/23.
//

import Foundation
import WebKit
import SwiftUI

struct YouTubeView: UIViewRepresentable {
	let videoId: String
	func makeUIView(context: Context) ->  WKWebView {
		return WKWebView()
	}
	func updateUIView(_ uiView: WKWebView, context: Context) {
		guard let demoURL = URL(string: "https://www.youtube.com/embed/\(videoId)") else { return }
		uiView.scrollView.isScrollEnabled = true
		uiView.load(URLRequest(url: demoURL))
	}
}
