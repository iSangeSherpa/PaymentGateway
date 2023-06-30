//
//  KhaltiWireframe.swift
//  Khalti
//
//  Created by Rajendra Karki on 2/19/18.
//  Copyright (c) 2018 khalti. All rights reserved.
//

import Foundation

class KhaltiPayment {
    
    public static func viewController() -> KhaltiPaymentViewController {
        let storyboard = UIStoryboard(name: "CheckOut", bundle: bundle)
        let vc = storyboard.instantiateViewController(withIdentifier: "KhaltiPaymentViewController") as! KhaltiPaymentViewController
        return vc
    }
    
    private static var bundle:Bundle {
        let podBundle = Bundle(for: KhaltiPaymentViewController.self)
        let bundleURL = podBundle.url(forResource: "Khalti", withExtension: "bundle")
        return Bundle(url: bundleURL!)!
    }
    
    func payInitiate(with params:Dictionary<String,Any>) {
        
    }
}
