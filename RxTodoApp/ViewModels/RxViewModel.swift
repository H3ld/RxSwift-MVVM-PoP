//
//  ViewModel2.swift
//  RxTodoApp
//
//  Created by Alexander Held on 07.09.18.
//  Copyright © 2018 Alexander Held. All rights reserved.
//
import RxSwift
import RxCocoa
import Foundation
import MapKit


/** RxViewModelInputs
```
query: Driver<String>
buttonTapped: Signal<()>
cellTapped: Driver<(Int,Int)>
```
*/
protocol RxViewModelInputType {
	var query: Driver<String> { get }
	var buttonTapped: Signal<()> { get }
	var cellTapped: Driver<(Int,Int)> { get }
}


protocol RxViewModelOutputType {
	var models: Driver<[AutoSuggestionsModel]> { get }
	var unbind: Signal<()> { get }
}
protocol RxViewModelDependencyType: hasMapKitService {}

struct RxViewModelDependencies: RxViewModelDependencyType { }

/** RxViewModelOutputs
```
models: Driver<[AutoSuggestionsModel]>
unbind: Signal<()>
cellTapped: Driver<(Int,Int)>
```
*/
struct RxViewModelOutputs: RxViewModelOutputType {
	let models: Driver<[AutoSuggestionsModel]>
	let unbind: Signal<()>
}

/** RxViewModelInputs
```
query: Driver<String>
buttonTapped: Signal<()>
cellTapped: Driver<(Int,Int)>
```
*/
struct RxViewModelInputs: RxViewModelInputType {
	let query: Driver<String>
	let buttonTapped: Signal<()>
	let cellTapped: Driver<(Int,Int)>
}

protocol RxViewModelType {
	typealias Input = RxViewModelInputs
	typealias Output = RxViewModelOutputs
	typealias Dependencies = RxViewModelDependencies
	
	init(input: Input, dependencies: Dependencies)
	
	var input: Input { get }
	var output: Output { get }
	var depencencies: Dependencies { get }
}

struct RxViewModel: RxViewModelType {
	
	let input: Input
	let output: Output
	let depencencies: Dependencies
	
	/// ViewModel for AutoSuggestions
	/// - Parameter input: RxViewModelInputs
	/// -
	init(input: Input, dependencies: Dependencies ) {
		self.input = input
		self.depencencies = dependencies
		
		let completions = input.query.flatMapLatest { _query -> Driver<[MKLocalSearchCompletion]> in
				return dependencies.MapKitService.startSearch(_query)
			}
			
		let models = completions.flatMapLatest { (_completions) -> Driver<[AutoSuggestionsModel]> in
			let model = _completions.map { (_completion) -> AutoSuggestionsModel in
				return AutoSuggestionsModel(top: _completion.title,
											bot: _completion.subtitle)
			}
			
			return Observable.just(model).asDriver(onErrorJustReturn: [])
		}
		
		let unbindAll = input.buttonTapped
		self.output = Output(models: models, unbind: unbindAll)
	}
}
