//
//  Rx+.swift
//  RxTodoApp
//
//  Created by Alexander Held on 07.09.18.
//  Copyright © 2018 Alexander Held. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit



extension Reactive where Base: AutoSuggestionsCell {
	
    /// textLabel.text & detailTextLabel.text
    var labels: Binder<AutoSuggestionsModel> {
        return Binder(self.base, scheduler: MainScheduler.instance, binding: { (base, model) in
            
            // making sure an error ist thrown if something gets a bit messy in the future
            guard base.textLabel != nil && base.detailTextLabel != nil
                else { fatalError("AutoSuggestionsCell unexpected behavoir!") }
            
            // linking these two
            base.textLabel?.text = model.top
            base.detailTextLabel?.text = model.bot
        })
    }
}
