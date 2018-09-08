//
//  ProductCell.swift
//  tokopedia
//
//  Created by Ricky Wirawan on 06/09/18.
//  Copyright © 2018 Ricky Wirawan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Hue

class ProductCell: BaseCell {
    var app: data? {
        didSet {
            nameLabel.text = app?.name
            priceLabel.text = app?.price
            
            DispatchQueue.main.async{
                if let imageName = self.app?.image_uri {
                    Alamofire.request(imageName).responseImage { response in
                        if let image = response.result.value {
                            self.imageView.image = image
                        }
                    }
                }
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor(hex: "#ed6532")
        return label
    }()
    
    override func setupViews() {
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(priceLabel)
        
        imageView.frame = CGRect(x: 15, y: 10, width: frame.width-25, height: frame.width-25)
        nameLabel.frame = CGRect(x: 15, y: frame.width - 2, width: frame.width-30, height: 40)
        priceLabel.frame = CGRect(x: 15, y: frame.width + 38, width: frame.width-30, height: 20)
        
    }
    
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}

extension UIView {
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}


