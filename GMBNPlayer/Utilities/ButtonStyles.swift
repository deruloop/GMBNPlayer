//
//  ButtonStyles.swift
//  GMBNPlayer
//
//  Created by Cristiano Calicchia on 31/01/23.
//

import Foundation
import SwiftUI

struct LoadMoreButtonStyle: ButtonStyle {

	var width : CGFloat
	var height : CGFloat?
	var font : Font
	
	init(width: CGFloat, height: CGFloat? = nil, font: Font) {
		self.width = width
		self.height = height
		self.font = font
		
	}

	func makeBody(configuration: Configuration) -> some View {
		
		ZStack {
			RoundedRectangle(cornerRadius: 15)
				.fill(customAccentColor)
			
			configuration.label
				.foregroundColor(secondaryBackgroundColor)
				.font(font)
		}
		.frame(width: width, height: height ?? 50, alignment: .center)
		.opacity(configuration.isPressed ? 0.3 : 1)
		
	}

}
