//
//  GMBNPlayerApp.swift
//  GMBNPlayer
//
//  Created by Cristiano Calicchia on 30/01/23.
//

import SwiftUI

@main
struct GMBNPlayerApp: App {
   
	@StateObject var coordinator = HomeCoordinator(title: "GMBN", dataProvider: DataProvider(communicationManager: CommunicationManager()))

	var body: some Scene {
		WindowGroup {
			HomeCoordinatorView(coordinator: coordinator)
		}
	}

	
}
