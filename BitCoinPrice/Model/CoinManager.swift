//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDeligate {
    func didUpdateCoin(price: String, currency: String)
    func didFailedWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "0F5ABB5A-599F-4C76-9BA7-53E4F2B69880"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var deligate: CoinManagerDeligate?

//    func getCoinPrice(for currency: String){
//        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
//        performRequest(with: urlString)
//    }
    
    func getCoinPrice(with currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        //1. Create a URL
        if let url = URL(string: urlString) {
            
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.deligate?.didFailedWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let bitCoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitCoinPrice)
                        self.deligate?.didUpdateCoin(price: priceString, currency: currency)
                    }
                }
            }
            
            //4. Start the task
            task.resume()
            
        }
        
        
    }
    
    func parseJSON (_ coinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            print(decodedData)
            let lastPrice = decodedData.rate
            print(lastPrice)
            
            return lastPrice
            
            
        } catch {
            deligate?.didFailedWithError(error: error)
            return nil
        }
    }
}
