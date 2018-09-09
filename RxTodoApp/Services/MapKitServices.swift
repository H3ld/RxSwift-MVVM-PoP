//
//  MapKitServices.swift
//  RxTodoApp
//
//  Created by Alexander Held on 07.09.18.
//  Copyright © 2018 Alexander Held. All rights reserved.
//

import MapKit
import RxCocoa
import RxSwift

protocol MapKitAPI {
	func startSearch(_ query: String) -> Driver<[MKLocalSearchCompletion]>
}

enum ErrorMapKitAPI: Error {
	case noCompletions
}

extension MKLocalSearchCompleter {
	static let shared = MKLocalSearchCompleter()
}

class DefaultMapKitAPI: MapKitAPI {
	let completer: MKLocalSearchCompleter
	static let sharedAPI = DefaultMapKitAPI()

	
	init() {
		self.completer = MKLocalSearchCompleter()
	}
	
	/// # Starts a search for geolocations
	/// - Parameter query: `String` which to search for
	/// - Returns: `Driver` of found locations
	func startSearch(_ query: String) -> Driver<[MKLocalSearchCompletion]> {
		completer.queryFragment = query
		
		let completions = Observable.just(self.completer.results)
			.do(onNext: { (_completions) in
				guard !_completions.isEmpty else { throw ErrorMapKitAPI.noCompletions }
			})
			.asDriver(onErrorJustReturn: [])
		return completions
		
	}
}
//
//
//
//
//enum LocalSearchResult {
//	case ok(message: String)
//	case empty
//	case searching
//	case failed(message: String)
//}
//
//extension LocalSearchResult {
//	var isValid: Bool {
//		switch self {
//		case .ok:
//			return true
//		default:
//			return false
//		}
//	}
//}
