//
//  ListCell.swift
//  Khalti
//
//  Created by Rajendra Karki on 2/21/18.
//  Copyright (c) 2018 khalti. All rights reserved.
//

import Foundation
import UIKit

class ListCell: UICollectionViewCell {
    
    @objc var itemNameLabel: UILabel!
    @objc var itemButton: UIButton!
    @objc var image:UIImage?
    
    override func awakeFromNib() {
        // Please check Main.storyboard with PaymentCell for the tag.
        itemNameLabel = (self.viewWithTag(202) as! UILabel)
        itemButton = (self.viewWithTag(203) as! UIButton)
        itemButton.isHidden = false
        itemButton.layer.cornerRadius = 53/2
        itemButton.layer.masksToBounds = true
    }
    
    @objc func setImage(with url:String?) {
        image = UIImage(named: "khalti_small")
        self.itemButton.setImage(image, for: .normal)
        self.setImageWithoutLibrary(with: url)
    }
    
    @objc func setImageWithoutLibrary(with url:String?) {
        
        if let imageUrl = url, let urll = URL(string: imageUrl) {
            let session = URLSession(configuration: .default)
            let downloadPicTask = session.dataTask(with: urll) { [weak self] (data, response, error) in
                if let e = error {
                    if Khalti.shared.debugLog {
                        print("Error downloading bank logo: \(e)")
                    }
                    DispatchQueue.main.async {
                        self?.itemButton.setImage(self?.image, for: .normal)
                    }
                } else {
                    if let _ = response as? HTTPURLResponse {
                        if let imageData = data {
                            let imagee = UIImage(data: imageData)
                            DispatchQueue.main.async {
                                self?.itemButton.setImage(imagee, for: .normal)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self?.itemButton.setImage(self?.image, for: .normal)
                            }
                            if Khalti.shared.debugLog {
                                print("Couldn't get image: Image is nil")
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.itemButton.setImage(self?.image, for: .normal)
                        }
                        if Khalti.shared.debugLog {
                            print("Couldn't get response code for some reason")
                        }
                    }
                }
            }
            downloadPicTask.resume()
        } else {
            self.itemButton.setImage(image, for: .normal)
        }
    }
    
}
