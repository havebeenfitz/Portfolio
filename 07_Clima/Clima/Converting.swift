//
//  Converting.swift
//  Clima
//
//  Created by Max Kraev on 03/04/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

func fahrenheitToCelcius(_ tempInFahrenheit: Double) -> Int {
    return Int((tempInFahrenheit - 32) * 0.555)
}
