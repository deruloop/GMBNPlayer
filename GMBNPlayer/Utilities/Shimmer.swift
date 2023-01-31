//
//  Shimmer.swift
//  PocketWorld
//
//  Created by Cristiano Calicchia on 12/12/22.
//

import Foundation
import SwiftUI

struct ShimmerView: View {
	
	private struct Constants {
		static let duration: Double = 0.9
		static let minOpacity: Double = 0.25
		static let maxOpacity: Double = 0.7
		static let cornerRadius: CGFloat = 16.0
	}
	
	@State private var opacity: Double = Constants.minOpacity
	
	public init() {}
	
	public var body: some View {
		RoundedRectangle(cornerRadius: Constants.cornerRadius)
			.fill(Color.white)
			.opacity(opacity)
			.transition(.opacity)
			.onAppear {
				let baseAnimation = Animation.easeInOut(duration: Constants.duration)
				let repeated = baseAnimation.repeatForever(autoreverses: true)
				withAnimation(repeated) {
					self.opacity = Constants.maxOpacity
				}
			}
	}
}
