//
//  FilterPage.swift
//  tokopedia
//
//  Created by Ricky Wirawan on 06/09/18.
//  Copyright © 2018 Ricky Wirawan. All rights reserved.
//

import UIKit
import TTRangeSlider

class FilterPage: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    fileprivate let PriceCellId = "PriceCellId"
    fileprivate let ShopCellId = "ShopCellId"
    var userCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.white
        return cv
    }()
    let ApplyButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        button.setTitle("Apply", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: "#64b157")
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleApply), for: UIControlEvents.touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.gray
        view.addSubview(userCollectionView)
        userCollectionView.alwaysBounceVertical = true
        userCollectionView.delegate = self
        userCollectionView.dataSource = self
        userCollectionView.backgroundColor = UIColor.white
        userCollectionView.register(PriceCell.self, forCellWithReuseIdentifier: PriceCellId)
        userCollectionView.register(ShopCell.self, forCellWithReuseIdentifier: ShopCellId)
        setupView()
    }
    
    func setupView(){
        let screenSize: CGRect = UIScreen.main.bounds
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 0))
        navbar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(navbar)
        navbar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        navbar.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor).isActive = true
        navbar.backgroundColor = UIColor.white
        
        let navigationItem = UINavigationItem()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .done, target: self, action: #selector(handleLeft))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(handleLeft))
        
        navbar.setItems([navigationItem], animated: false)
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor.white
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        
        userCollectionView.topAnchor.constraint(equalTo: navbar.bottomAnchor, constant: 0).isActive = true
        userCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        userCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        userCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        view.addSubview(ApplyButton)
        ApplyButton.leftAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        ApplyButton.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true
        ApplyButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        ApplyButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        ApplyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PriceCellId, for: indexPath) as! PriceCell
            cell.priceSlider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
            cell.wholeSwitch.addTarget(self, action: #selector(switchChanged(sender:)), for: .valueChanged)

            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopCellId, for: indexPath) as! ShopCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0{

            return CGSize(width: view.frame.width, height: 250)
        }
        return CGSize(width: view.frame.width, height: 150)
    }
    @objc func sliderValueDidChange(){
        let index = IndexPath(row: 0, section: 0)
        let cell: PriceCell = self.userCollectionView.cellForItem(at: index) as! PriceCell
        cell.hargaMin.text = "Rp " + String(Int(cell.priceSlider.selectedMinimum))
        cell.hargaMax.text = "Rp " + String(Int(cell.priceSlider.selectedMaximum))
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
    }
    
    @objc func handleLeft(){
        print(ViewController.varUrl.pmin)
        print(ViewController.varUrl.pmax)
        print(ViewController.varUrl.wholesale)
    }
    
    @objc func switchChanged(sender: UISwitch!) {
        print("Switch value is \(sender.isOn)")
        if sender.isOn == false{
            print("matek")
        }
    }
    
    @objc func handleApply(){
        let index = IndexPath(row: 0, section: 0)
        let cell: PriceCell = self.userCollectionView.cellForItem(at: index) as! PriceCell
        
        ViewController.varUrl.pmin = Int(cell.priceSlider.selectedMinimum)
        ViewController.varUrl.pmax = Int(cell.priceSlider.selectedMaximum)
        ViewController.varUrl.wholesale = cell.wholeSwitch.isOn
    }
}

class PriceCell: BaseCell {
   
    let labelMin : UILabel = {
        let label = UILabel()
        label.text = "Minimum Price"
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 15)
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    let labelMax : UILabel = {
        let label = UILabel()
        label.text = "Maximum Price"
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 15)
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        label.textAlignment = .right
        return label
    }()
    let hargaMin : UILabel = {
        let label = UILabel()
        label.text = String(ViewController.varUrl.pmin)
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 15)
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    let hargaMax : UILabel = {
        let label = UILabel()
        label.text = String(ViewController.varUrl.pmin)
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 15)
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        label.textAlignment = .right
        return label
    }()
    
    let priceSlider : TTRangeSlider = {
        let slider = TTRangeSlider()
        slider.minValue = 10000
        slider.maxValue = 100000
        slider.selectedMinimum = 10000
        slider.selectedMaximum = 100000
        slider.tintColor = UIColor.green
        slider.hideLabels = true
        return slider
    }()
    
    let wholeLabel : UILabel = {
        let label = UILabel()
        label.text = "Whole Sale"
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 15)
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        label.textAlignment = .left
        return label
    }()

    let wholeSwitch : UISwitch = {
        let whole = UISwitch()
        whole.setOn(false, animated: false)
        whole.tintColor = UIColor.blue
        whole.onTintColor = UIColor.cyan
        whole.thumbTintColor = UIColor.red
        whole.backgroundColor = UIColor.yellow
        return whole
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(labelMin)
        addSubview(labelMax)
        addSubview(hargaMax)
        addSubview(hargaMin)
        addSubview(priceSlider)
        addSubview(wholeLabel)
        addSubview(wholeSwitch)
        
        addConstraintsWithFormat("H:|-10-[v0(150)][v1(150)]-5-|", views: labelMin,labelMax)
        addConstraintsWithFormat("H:|-10-[v0(150)][v1(150)]-5-|", views: hargaMin,hargaMax)
        addConstraintsWithFormat("H:|-10-[v0]-10-|", views: priceSlider)
        addConstraintsWithFormat("H:|-10-[v0(150)][v1(50)]-5-|", views: wholeLabel,wholeSwitch)
        
        addConstraintsWithFormat("V:[v0]-5-[v1]-5-[v2]-5-[v3]|", views: labelMin,hargaMin,priceSlider,wholeLabel)
        addConstraintsWithFormat("V:[v0]-5-[v1]-5-[v2]-5-[v3]|", views: labelMax,hargaMax,priceSlider,wholeSwitch)
        
    }
}

class ShopCell: BaseCell {
    
    let TitleLabel : UILabel = {
        let label = UILabel()
        label.text = "labelMin"
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 15)
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    let nextImg: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = UIColor.green
        iv.layer.masksToBounds = true
        return iv
    }()
    let GoldenSwitch : UISwitch = {
        let whole = UISwitch()
        whole.setOn(false, animated: false)
        whole.tintColor = UIColor.blue
        whole.onTintColor = UIColor.cyan
        whole.thumbTintColor = UIColor.red
        whole.backgroundColor = UIColor.yellow
        return whole
    }()
    let OfficialSwitch : UISwitch = {
        let whole = UISwitch()
        whole.setOn(false, animated: false)
        whole.tintColor = UIColor.blue
        whole.onTintColor = UIColor.cyan
        whole.thumbTintColor = UIColor.red
        whole.backgroundColor = UIColor.yellow
        return whole
    }()
    override func setupViews() {
        super.setupViews()
        
        addSubview(TitleLabel)
        addSubview(nextImg)
        addSubview(GoldenSwitch)
        addSubview(OfficialSwitch)
        
        addConstraintsWithFormat("H:|-10-[v0(150)][v1(50)]-5-|", views: TitleLabel,nextImg)
        addConstraintsWithFormat("H:|-10-[v0(150)][v1(150)]-5-|", views: GoldenSwitch,OfficialSwitch)
        
        addConstraintsWithFormat("V:[v0(50)]-5-[v1]|", views: TitleLabel,GoldenSwitch)
        addConstraintsWithFormat("V:[v0(50)]-5-[v1]|", views: nextImg,OfficialSwitch)
        
    }
}


