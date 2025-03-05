//
//  CurrencyDataModel.swift
//  ByteCoin
//
//  Created by dev on 06/03/2025.
//  Copyright © 2025 The App Brewery. All rights reserved.
//

import Foundation

struct CurrencyDataModel{
    var rate: Double
    
    var rateString: String {
        return String(format: "%.2f", rate)
    }
}
