//
//  Injections.swift
//  RxTodoApp
//
//  Created by Alexander Held on 08.09.18.
//  Copyright © 2018 Alexander Held. All rights reserved.
//

import Foundation

struct Injector {
	static let MapKitService: MapKitAPI = DefaultMapKitAPI()
}

// MARK: MapKitService
// =================================
protocol hasMapKitService { }
extension hasMapKitService { var MapKitService: MapKitAPI {
	get { return Injector.MapKitService } } }
