//
//  ExchangeVC.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 20/10/2022.
//

import UIKit

class ExchangeVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        ExchangeService.shared.getExchangeRate(to: "EUR", from: "USD", amount: "200") { success, result in
            guard let result = result, success == true else {
                return
            }
            
            
        }
    }
}
