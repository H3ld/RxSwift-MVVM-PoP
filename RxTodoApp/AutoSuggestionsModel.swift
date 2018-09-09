//
//  CellModel.swift
//  RxTodoApp
//
//  Created by Alexander Held on 06.09.18.
//  Copyright © 2018 Alexander Held. All rights reserved.
//

import Foundation

struct AutoSuggestionsModel {
    let top: String
    let bot: String
    
    init(top: String, bot: String = "") {
        self.top = top
        self.bot = bot
    }
}
