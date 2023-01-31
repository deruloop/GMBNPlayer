//
//  ApiError.swift
//  GMBNPlayer
//
//  Created by Cristiano Calicchia on 30/01/23.
//

import Foundation

enum APIError: Error, LocalizedError, Equatable {
	case unknown, apiError(reason: String), parserError(reason: String)

	var errorDescription: String? {
		switch self {
		case .unknown:
			return "Unknown error"
		case .apiError(let reason), .parserError(let reason):
			return reason
		}
	}
}
