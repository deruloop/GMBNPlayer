//
//  Extensions+.swift
//  GMBNPlayer
//
//  Created by Cristiano Calicchia on 31/01/23.
//

import Foundation
import SwiftUI

extension Image {
	
	func data(url:URL) -> Self {
		
		if let data = try? Data(contentsOf: url) {
			return Image(uiImage: UIImage(data: data)!)
				.resizable()
		}
		return self
			.resizable()
	}
	
}
