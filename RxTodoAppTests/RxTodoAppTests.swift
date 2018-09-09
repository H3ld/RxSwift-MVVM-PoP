//
//  RxTodoAppTests.swift
//  RxTodoAppTests
//
//  Created by Alexander Held on 06.09.18.
//  Copyright © 2018 Alexander Held. All rights reserved.
//
import Foundation
import XCTest
import RxTest
import RxCocoa
import RxBlocking
import RxSwift
import MapKit

@testable import RxTodoApp

class RxTodoAppTests: XCTestCase {
    
	var viewModel: RxViewModelType!
    var bag: DisposeBag!
    var scheduler: TestScheduler!
    
	
	// MARK: testIndexPathes Driver<(int,int)>
	// =================================
	let testIndexPathes = Observable
		.from([(0,0),(0,1),(0,2),
			   (1,0),(1,1),(1,2),
			   (2,0),(2,1),(2,2)])
		.debug("№", trimOutput: false)
		.asDriver(onErrorJustReturn: (100,100))
	
	
	// MARK: userQueries: Driver<String>
	// =================================
	var passQuery: Driver<String>!
	var failQuery: Driver<String>!
	
	
	// MARK: buttonTapped = Observable.empty()
	// 			.asSignal(onErrorJustReturn: _ )
	// =================================
	let buttonTapped: Signal<()> = Observable
		.empty()
		.asSignal(onErrorJustReturn: ())
	
	
	// MARK: - SETUP
	// =================================
	
	override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0, resolution: 0.2, simulateProcessingDelay: false)
		
		passQuery = scheduler
			.createHotObservable(["pulheim", "köln"]
				.enumerated()
				.compactMap { Recorded.next(100 * ($0.offset + 1), "\($0.element)") })
			.debug("✅", trimOutput: false)
			.asDriver(onErrorJustReturn: "⭕️")
		
		
		failQuery = scheduler
			.createHotObservable(["⚇🇱🇦🚺fd/!!", "9912309214"]
				.enumerated()
				.compactMap { Recorded.next(100 * ($0.offset + 1), "\($0.element)") })
			.debug("⛔️", trimOutput: true)
			.asDriver(onErrorJustReturn: "🚫")
		
        bag = DisposeBag()
    }

    override func tearDown() {
        super.tearDown()
        viewModel = nil
        bag = nil
        scheduler = nil
    }
    
    
    func testValidInput() {
		self.measure {
			let passInput = RxViewModelInputs(query: passQuery, buttonTapped: buttonTapped, cellTapped: testIndexPathes)
			
			viewModel = RxViewModel(input: passInput, dependencies: RxViewModel.Dependencies())
			
			viewModel.output.models.debug("✅", trimOutput: false)
				.drive(onNext: {
					debugPrint($0.debugDescription)
					XCTAssert($0.first?.top == "pulheim", "✅")
				}).disposed(by: bag)
		}
	}
	
	func testBadInput() {
		self.measure {
			let passInput = RxViewModelInputs(query: failQuery, buttonTapped: buttonTapped, cellTapped: testIndexPathes)
			
			viewModel = RxViewModel(input: passInput, dependencies: RxViewModel.Dependencies())
			
			viewModel.output.models.debug("⛔️", trimOutput: false)
				.drive(onNext: {
					XCTAssert($0.first?.top == "pulheim", "✅")
				}).disposed(by: bag)
		}
		
	}
}
