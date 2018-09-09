//
//  ViewController.swift
//  RxTodoApp
//
//  Created by Alexander Held on 06.09.18.
//  Copyright © 2018 Alexander Held. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MapKit

class ViewController: UIViewController {    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttonPressed(_ sender: Any) {

    }
    
	var viewModel: RxViewModelType!
	
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(AutoSuggestionsCell.self,
						   forCellReuseIdentifier: "AutoSuggestions")
		
		let query = textField.rx.text.orEmpty
			.asDriver()
			.throttle(0.3)
			.distinctUntilChanged()
		
		let buttonTapped = button.rx.tap
			.asSignal()
		
		let cellTapped = tableView.rx.itemSelected
			.asDriver()
			.flatMap { (indexPath) -> Driver<(Int,Int)> in
				return Observable.just((indexPath.row,indexPath.count))
					.asDriver(onErrorJustReturn: (0, 0))
			}

		
		viewModel = RxViewModel(input: RxViewModel.Input(query: query,
														 buttonTapped: buttonTapped,
														 cellTapped: cellTapped),
			dependencies: RxViewModel.Dependencies())
		
		
		viewModel.output.models.debug("models", trimOutput: false)
			.asObservable()
			.bind(to: tableView.rx.items(cellIdentifier: "AutoSuggestions",
										 cellType: AutoSuggestionsCell.self))
				{ (row, model, cell) in
					cell.textLabel?.text = model.top
					cell.detailTextLabel?.text = model.bot
				}.disposed(by: bag)
		
		
		
    }

	func working() {
		let completer = MKLocalSearchCompleter()
		let completions = textField.rx.text
			.orEmpty
			.asDriver()
			.throttle(0.3)
			.distinctUntilChanged()
			.flatMapLatest { (query) -> Driver<[MKLocalSearchCompletion]> in
				completer.queryFragment = query
				
				return Observable.just(completer.results).asDriver(onErrorJustReturn: [])
		}
		
		let models = completions.flatMapLatest { (completions: [MKLocalSearchCompletion]) -> Driver<[AutoSuggestionsModel]> in
			
			let mod = completions.compactMap { aCompletion -> AutoSuggestionsModel in
				let _model = AutoSuggestionsModel(top: aCompletion.title, bot: aCompletion.subtitle)
				return _model
			}
			
			return Observable.just(mod).asDriver(onErrorJustReturn: []).debug()
		}
	
		
		models.asObservable()
			.bind(to: tableView.rx.items(cellIdentifier: "AutoSuggestions", cellType: AutoSuggestionsCell.self)) { (row, model, cell) in
					cell.textLabel?.text = model.top
					cell.detailTextLabel?.text = model.bot
		}.disposed(by: bag)
	}
}

//
//extension Reactive where Base: AutoSuggestionsCell {
//	var labels: Binder<AutoSuggestionsModel> {
//		base.textLabel?.text =
//	}
//}
