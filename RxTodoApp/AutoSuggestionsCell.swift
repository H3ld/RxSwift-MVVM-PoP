//
//  AutoSuggestionCell.swift
//  RxTodoApp
//
//  Created by Alexander Held on 07.09.18.
//  Copyright © 2018 Alexander Held. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AutoSuggestionsCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        try? setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        try? setupViews()
    }
    
    func setupViews() throws {
        guard let textLabel = textLabel, let detailTextLabel = detailTextLabel
            else { throw NSError(domain: "Error while unwrap optional subview", code: 100, userInfo: nil) }
        
        textLabel.font = UIFont(name: "gibson-semibold", size: 15)
        detailTextLabel.font = UIFont(name: "gibson-semibold", size: 15)
        
        textLabel.textColor = #colorLiteral(red: 0.3409999907, green: 0.451000005, blue: 1, alpha: 1)
        detailTextLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}

