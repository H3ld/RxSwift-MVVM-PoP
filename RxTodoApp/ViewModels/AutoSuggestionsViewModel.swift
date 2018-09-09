//
//  AutoSuggestionsViewModel.swift
//  RxTodoApp
//
//  Created by Alexander Held on 06.09.18.
//  Copyright © 2018 Alexander Held. All rights reserved.
//


import RxSwift
import RxCocoa
import Foundation
import MapKit


/// ViewModelType Protocol
protocol ViewModelType {
	
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}


/// ViewModel responsible for processing the user input
class AutoSuggestionsViewModel: ViewModelType {
    
    /// Input IO-Socket
    var input: Input
    
    /// Output IO-Socket
    var output: Output
    
    
    // MARK: Private Subjects
    // =================================
    private let queryDidChangedSubject = ReplaySubject<String>.create(bufferSize: 1)
    
    
    // MARK: Initializer
    // =================================
    init() {
        
        // helper, responsible for quering
        let completer = MKLocalSearchCompleter()
        
        /// - Parameter queryDidChangedSubject: String
        /// - Returns: Observable<[MKLocalSearchCompletion]>
        let results = queryDidChangedSubject
            .distinctUntilChanged()  // make sure there are no same queries after another
            .throttle(0.3, scheduler: MainScheduler.instance) // make sure only one query at a time in 0.3 seconds (... on the main thread)
            .map { completer.queryFragment = $0 } // starting the query
            .flatMapLatest { _ -> Observable<[MKLocalSearchCompletion]> in // fetching completions
                return Observable.just(completer.results) // return Observable sequence of completions
        }
        
        /// - Parameter completions: [MKLocalSearchCompletion]
        /// - Note: Mapping each completion to a CellModel
        /// - Returns: Driver<CellModel>
        let cellModels = results.flatMapLatest { completions -> Observable<[AutoSuggestionsModel]> in
            return Observable.just(completions.compactMap { AutoSuggestionsModel(top: $0.title, bot: $0.subtitle) })
        }.asDriver(onErrorJustReturn: [])
        

        /// - Note: Set Output first, because of timing
        self.output = Output(models: cellModels)
        self.input = Input(queryDidChanged: queryDidChangedSubject.asObserver())
    }
    
    
    // MARK: Associated Typedef
    // =================================
    struct Input {
        let queryDidChanged: AnyObserver<String>
    }
    struct Output {
        let models: Driver<[AutoSuggestionsModel]>
    }
}
