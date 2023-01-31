//
//  Countries.swift
//  PocketWorld
//
//  Created by Cristiano Calicchia on 05/12/22.
//

import Foundation

struct VideoList: Codable {
	var nextPageToken: String?
	var items: [Video]
}

struct Video: Codable {

	var contentDetails: ContentDetailsId
}

struct ContentDetailsId: Codable {
	var videoId: String
}

struct VideoDetails: Codable {
	
	var items: [VideoDetail]
}

struct VideoDetail: Codable {
	var id: String
	var snippet: Snippet
	var contentDetails: ContentDetails
}

struct ContentDetails: Codable {
	var duration: String
}

struct Snippet: Codable {

	var publishedAt: Date
	var title: String
	var description: String
	var thumbnails: Thumbnail
}

struct Thumbnail: Codable {
	var high: VideoImage
}

struct VideoImage: Codable {
	var url: String
}

extension Snippet {
	var formattedDate : String {
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		formatter.setLocalizedDateFormatFromTemplate("dd/MM/YY")
		
		return formatter.string(from: publishedAt)
	}
}

extension ContentDetails {
	var formattedDuration: String {
		
		var formattedDuration = String(duration.split(separator: "M")[0])
		
		formattedDuration = formattedDuration.replacingOccurrences(of: "PT", with: "").replacingOccurrences(of: "H", with:":").replacingOccurrences(of: "M", with: "")

		let components = formattedDuration.components(separatedBy: ":")
		var duration = ""
		for component in components {
			duration = duration.count > 0 ? duration + ":" : duration
			if component.count < 2 {
				duration += "0" + component
				continue
			}
			duration += component
		}
		
		duration = duration + ":00"

		return duration
	}
}


struct Comments: Codable {
	var nextPageToken: String?
	var items: [Comment]
}

struct Comment: Codable {
	var snippet: CommentExternalSnippet
}

struct CommentExternalSnippet: Codable {
	var topLevelComment: TopLevelComment
}

struct TopLevelComment: Codable {
	var snippet: CommentInfo
}

struct CommentInfo: Codable {
	var textOriginal: String
	var authorDisplayName: String
	var publishedAt: Date
}

extension CommentInfo {
	var formattedDate : String {
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		formatter.setLocalizedDateFormatFromTemplate("dd/MM/YY")
		
		return formatter.string(from: publishedAt)
	}
}
