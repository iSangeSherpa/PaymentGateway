//
//  Config.swift
//  Khalti
//
//  Created by Rajendra Karki on 2/19/18.
//  Copyright (c) 2018 khalti. All rights reserved.
//

import Foundation


@objc public class Config: NSObject {
    private var publicKey:String
    private var productId:String
    private var productName:String
    private var productUrl:String?
    private var amount:Int
    private var additionalData:Dictionary<String,String>?
    private var ebankingPayment:Bool = true
    private var cardPayment:Bool = false
    
    @objc public init(publicKey:String,  amount:Int, productId:String,productName:String, productUrl:String? = nil, additionalData:Dictionary<String,String>? = nil, ebankingPayment: Bool = true) {
        self.publicKey = publicKey
        self.productId = productId
        self.productName = productName
        self.productUrl = productUrl
        self.amount = amount
        self.additionalData = additionalData
        self.ebankingPayment = ebankingPayment
        self.cardPayment = false
    }
    
    @objc public func getPublicKey() -> String {
        return self.publicKey
    }
    
    @objc public func getAmount() -> Int {
        return self.amount
    }
    
    @objc public func getProductId() -> String {
        return self.productId
    }
    
    @objc public func getProductName() -> String {
        return self.productName
    }
    
    @objc public func getProductUrl() -> String? {
        return self.productUrl
    }
    
    @objc public func getebankingView() -> Bool {
        return self.ebankingPayment
    }
    
    @objc public func getCardView() -> Bool {
        return self.cardPayment
    }
    
    @objc public func getAdditionalData() -> Dictionary<String,String>? {
        if let data = self.additionalData {
            return data
        }
        return nil
    }
}

