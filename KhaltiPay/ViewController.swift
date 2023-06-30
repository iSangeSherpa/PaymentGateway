//
//  ViewController.swift
//  KhaltiPay
//
//  Created by Sange Sherpa on 30/06/2023.
//

import UIKit
import Khalti
import Alamofire
import SnapKit

struct InitiateData: Codable {
    let public_key: String
    let mobile: String
    let transaction_pin: String
    let amount: String
    let product_identity: String
    let product_name: String
    let product_url: String
}

struct ConfirmationData: Codable {
    let public_key: String
    let token: String
    let transaction_pin: String
    let confirmation_code: String
}

struct InitiateResponse: Codable {
    let token: String
}


class ViewController: UIViewController {
    
    let publicKey = "test_public_key_ca4bc8fed33e4c6c83255f6f5f418613"

    var button: UIButton = {
       var btn = UIButton()
        btn.setTitle("Push", for: .normal)
        btn.backgroundColor = .red
        return btn
    }()

    lazy var initiateData = InitiateData(
        public_key: publicKey,
        mobile: "9823312442",
        transaction_pin: "0502",
        amount: "10000",
        product_identity: "book/id-120",
        product_name: "A Song of Ice and Fire",
        product_url: ""
    )
    
    lazy var confirmationData = ConfirmationData(
        public_key: publicKey,
        token: "",
        transaction_pin: "",
        confirmation_code: ""
    )

    lazy var config = Config(
        publicKey: publicKey,
        amount: 10000,
        productId: "12345",
        productName: "A Song of Ice and Fire"
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        view.addSubview(button)

        button.addTarget(self, action: #selector(push), for: .touchUpInside)

        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        initiatePayment()
        confirmPayment()
    }


    @objc func push() {
        Khalti.present(caller: self, with: config, delegate: self)
    }


    private func initiatePayment() {
        AF.request("https://khalti.com/api/v2/payment/initiate/",
                   method: .post,
                   parameters: initiateData,
                   encoder: JSONParameterEncoder.default
        ).response { response in
            debugPrint(response)
        }
    }


    private func confirmPayment() {
        AF.request("https://khalti.com/api/v2/payment/confirm/",
                   method: .post,
                   parameters: initiateData,
                   encoder: JSONParameterEncoder.default
        ).response { response in
            debugPrint(response)
        }
    }

}


extension ViewController: KhaltiPayDelegate {
    
    func onCheckOutSuccess(data: Dictionary<String, Any>) {
        print("\(data)")
    }
    
    func onCheckOutError(action: String, message: String, data: Dictionary<String, Any>?) {
        print("\(message)")
    }
    
}
