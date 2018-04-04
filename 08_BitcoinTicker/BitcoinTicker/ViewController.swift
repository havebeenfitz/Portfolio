//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
 
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL", "CAD", "CNY", "EUR", "GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let symbolsArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    
    //MARK: Picker View Delegate methods
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        bitcoinPriceLabel.text = symbolsArray[row]
        getPrice(forCurrency: currencyArray[row])

    }

    //MARK: - Networking

    func getPrice(forCurrency currency: String) {
        
        finalURL = baseURL + currency
        
        Alamofire.request(finalURL).responseJSON { response in
            
            if let responseAny = response.value {
            
                let responseJSON = JSON(responseAny)
                self.updatePrice(json: responseJSON)
                
                print(responseJSON)
            
            } else if let error = response.error{
                print(error)
            }
        }
    
        
    }
   
    //MARK: - JSON Parsing
    
    func updatePrice(json: JSON) {
        
        
        bitcoinPriceLabel.text = bitcoinPriceLabel.text! + json["last"].stringValue

    }


}
