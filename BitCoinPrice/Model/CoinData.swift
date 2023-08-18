//
//  CoinData.swift
//  BitCoinPrice
//
//  Created by Akash Arafat on 2023/08/17.
//  Copyright © 2023 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Decodable {
    let asset_id_quote: String
    let rate: Double
}
