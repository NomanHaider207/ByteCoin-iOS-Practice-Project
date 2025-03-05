//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCurrency(_ coinManager: CoinManager, currency: CurrencyDataModel)
    func didFailWithError(error: Error)
}
struct CoinManager {
    
    
    let baseURL = "https://api-realtime.exrates.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "d346e7ad-3088-4501-82e4-dd0ab7e362ba"
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR","PKR"]

    func getCurrency(for currency: String) {
        let url = "\(baseURL)\(currency)?apikey=\(apiKey)"
        print(url)
        performRequest(with: url)
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, urlResponse, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let currency = parseJSON(currencyData: safeData) {
                        delegate?.didUpdateCurrency(self, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(currencyData: Data) -> CurrencyDataModel? {
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(CurrencyData.self, from: currencyData)
            let rate = decoderData.rate ?? 0.0
            return CurrencyDataModel(rate: rate)
        } catch {
            print("Decoding Error: \(error)")
            return nil
        }
    }
}
