//
//  CheckOutView.swift
//  Khalti
//
//  Created by Rajendra Karki on 2/15/18.
//  Copyright (c) 2018 khalti. All rights reserved.
//

import UIKit

extension URL {
    
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self.absoluteURL, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        return parameters
    }
}

class CheckOutViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var firstLine: UIView!
    @IBOutlet weak var ebankingView:UIView!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var secondLine: UIView!
    @IBOutlet weak var cardView:UIView!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var thirdLine: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var optionsWidthConstraints: NSLayoutConstraint!
    
    @objc var config:Config?
    @objc var delegate:KhaltiPayDelegate?

    private lazy var khaltiPayViewController: KhaltiPaymentViewController = {
        let viewController = KhaltiPayment.viewController()
        viewController.config = self.config
        viewController.delegate = self.delegate
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var ebankingViewController:EbankingViewController = {
        let viewController = Ebanking.viewController()
        viewController.config = self.config
        viewController.delegate = self.delegate
        viewController.loadType = KhaltiAPIUrl.ebankList
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var cardPayViewController: EbankingViewController = {
        let viewController = Ebanking.viewController()
        viewController.config = self.config
        viewController.delegate = self.delegate
        viewController.loadType = KhaltiAPIUrl.cardBankList
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    //MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.optionsWidthConstraints.constant = self.view.bounds.width/3
        if let card = config?.getCardView(), let bank = config?.getebankingView() {
            let cardHide = !card
            let bankHide = !bank
            
            self.cardView.isHidden = cardHide
            self.ebankingView.isHidden = bankHide
            
            if bankHide && cardHide {
                self.optionsWidthConstraints.constant = self.view.bounds.width
            } else if cardHide || bankHide {
                self.optionsWidthConstraints.constant = self.view.bounds.width/2
            }
        }
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        self.addBackButton()
        self.updateView(to: .khalti)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handle(withNotification:)), name: Notification.Name(rawValue: Khalti.shared.appUrlScheme!), object: nil)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let config = config, let _ = delegate else {
            let alertController = UIAlertController(title: "Missing Configuration", message: "Cannot process for payment.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK" , style: .default, handler: {_ in
                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let cardHide = !config.getCardView()
        let bankHide = !config.getebankingView()
        
        if bankHide && cardHide {
            self.cardView.isHidden = true
            self.ebankingView.isHidden = true
            self.optionsWidthConstraints.constant = self.view.bounds.width
        } else if bankHide {
            self.secondButton.setTitle("Card", for: .normal)
            self.optionsWidthConstraints.constant = self.view.bounds.width/2
            self.ebankingView.isHidden = false
            self.cardView.isHidden = true
        } else if cardHide {
            self.optionsWidthConstraints.constant = self.view.bounds.width/2
            self.cardView.isHidden = true
        }
    }
    
    @objc func handle(withNotification notification : Notification) {
        if let url = notification.userInfo!["url"] as? URL {
            NotificationCenter.default.removeObserver(self, name:notification.name, object: nil)
            if let params = url.queryParameters {
                self.dismiss(animated: true, completion: {
                    self.delegate?.onCheckOutSuccess(data: params)
                })
            }
        }
        if Khalti.shared.debugLog {
            print("RECEIVED SPECIFIC NOTIFICATION: \(notification)")
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func addBackButton() {
        let menuBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action:  #selector(self.navigateBack))
        menuBarButtonItem.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = menuBarButtonItem
    }
    
    @objc func navigateBack() {
        self.dismiss(animated: true, completion: {
            // do pass navigation back data
            
        })
    }
    
    // MARK: - Actions
    @IBAction func ebankingPay(_ sender: UIButton) {
        if let _value = config?.getebankingView(), _value {
            self.updateView(to: .ebanking)
        }
        else if let _value = config?.getCardView(), _value {
            self.updateView(to: .card)
        }
    }
    
    @IBAction func khaltiPay(_ sender: UIButton) {
        self.updateView(to: .khalti)
    }
    
    @IBAction func cardPay(_ sender: UIButton) {
        self.updateView(to: .card)
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        
         // Add Child View Controller
        #if swift(>=4.2)
            addChild(viewController)
        #else
            addChildViewController(viewController)
        #endif
        containerView.addSubview(viewController.view) // Add Child View as Subview
        
        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        #if swift(>=4.2)
        viewController.didMove(toParent: self)
        #else
        viewController.didMove(toParentViewController: self)
        #endif
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        
         // Notify Child View Controller
        #if swift(>=4.2)
        viewController.willMove(toParent: nil)
        #else
        viewController.willMove(toParentViewController: nil)
        #endif
        viewController.view.removeFromSuperview() // Remove Child View From Superview
        
        // Notify Child View Controller
        #if swift(>=4.2)
        viewController.removeFromParent()
        #else
        viewController.removeFromParentViewController()
        #endif
    }
    
    fileprivate func updateView(to:PaymentType) {
        let khaltiBaseColor = UIColor(red: 76.0/255.0, green: 39.0/255.0, blue: 109.0/255.0, alpha: 1.0)
        let khaltiOrangeColor = UIColor(red:247.0/255.0, green: 147.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        
        self.firstButton.setTitleColor(khaltiBaseColor, for: .normal)
        self.firstLine.backgroundColor = UIColor.clear
        self.secondButton.setTitleColor(khaltiBaseColor, for: .normal)
        self.secondLine.backgroundColor = UIColor.clear
        self.thirdButton.setTitleColor(khaltiBaseColor, for: .normal)
        self.thirdLine.backgroundColor = UIColor.clear
        if to == .khalti {
            UIView.animate(withDuration: 0.3, animations: {
                self.firstButton.setTitleColor(khaltiOrangeColor, for: .normal)
                self.firstLine.backgroundColor = khaltiOrangeColor
            })
            
            if let _value = self.config?.getebankingView(), _value {
                self.remove(asChildViewController: self.ebankingViewController)
            }
            if let _value = self.config?.getCardView(), _value {
                self.remove(asChildViewController: self.cardPayViewController)
            }
            self.add(asChildViewController: self.khaltiPayViewController)
        } else if to == .ebanking {
            UIView.animate(withDuration: 0.3, animations: {
                self.secondButton.setTitleColor(khaltiOrangeColor, for: .normal)
                self.secondLine.backgroundColor = khaltiOrangeColor
            })
            self.remove(asChildViewController: self.khaltiPayViewController)
            if let card = self.config?.getCardView(), card {
                self.remove(asChildViewController: self.cardPayViewController)
            }
            self.add(asChildViewController: self.ebankingViewController)
        } else if to == .card {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let _value = self?.config?.getebankingView(), !_value {
                    self?.secondButton.setTitleColor(khaltiOrangeColor, for: .normal)
                    self?.secondLine.backgroundColor = khaltiOrangeColor
                } else {
                    self?.thirdButton.setTitleColor(khaltiOrangeColor, for: .normal)
                    self?.thirdLine.backgroundColor = khaltiOrangeColor
                }
            })
            
            self.remove(asChildViewController: self.khaltiPayViewController)
            if let _value = self.config?.getebankingView(), _value {
                self.remove(asChildViewController: self.ebankingViewController)
            }
            self.add(asChildViewController: self.cardPayViewController)
        }
    }
}
