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
        view.backgroundColor = UIColor(hex: "#f1f1f1")
        view.addSubview(userCollectionView)
        userCollectionView.alwaysBounceVertical = true
        userCollectionView.delegate = self
        userCollectionView.dataSource = self
        userCollectionView.backgroundColor = UIColor(hex: "#f1f1f1")
        userCollectionView.register(PriceCell.self, forCellWithReuseIdentifier: PriceCellId)
        userCollectionView.register(ShopCell.self, forCellWithReuseIdentifier: ShopCellId)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userCollectionView.reloadData()
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
        var customView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        
        var button = UIButton.init(type: .custom)
        button.setBackgroundImage(UIImage(named: "x"), for: .normal)
        button.frame = CGRect(x: 0, y: 5, width: 32, height: 32)
        button.addTarget(self, action: #selector(handleLeft), for: .touchUpInside)
        customView.addSubview(button)
        
        var marginX = CGFloat(button.frame.origin.x + button.frame.size.width + 15)
        var label = UILabel(frame: CGRect(x: marginX, y: 0, width: 65, height: 44))
        label.text = "Filter"
        label.textColor = UIColor.black
        label.textAlignment = .left
        customView.addSubview(label)
        
        var leftButton = UIBarButtonItem(customView: customView)
        
        navigationItem.leftBarButtonItem = leftButton
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(hex: "#64b157")
        
        navbar.setItems([navigationItem], animated: false)
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor.white
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        
        userCollectionView.topAnchor.constraint(equalTo: navbar.bottomAnchor, constant: 10).isActive = true
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
            cell.backgroundColor = UIColor.white
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopCellId, for: indexPath) as! ShopCell
        cell.GoldSwitch.addTarget(self, action: #selector(handleGold), for: .touchDown)
        cell.OfficialSwitch.addTarget(self, action: #selector(handleOfficial), for: .touchDown)
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0{

            return CGSize(width: view.frame.width, height: 170)
        }
        return CGSize(width: view.frame.width, height: 110)
    }
    @objc func sliderValueDidChange(){
        let index = IndexPath(row: 0, section: 0)
        let cell: PriceCell = self.userCollectionView.cellForItem(at: index) as! PriceCell
        cell.hargaMin.text = "Rp " + String(Int(cell.priceSlider.selectedMinimum))
        cell.hargaMax.text = "Rp " + String(Int(cell.priceSlider.selectedMaximum))
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 1  {
            let shopFilter = ShopFilterPage()
            present(shopFilter, animated: true, completion: {
            })
        }
    }
    
    @objc func handleLeft(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func handleGold(){
        ViewController.varUrl.fshop = false
    }
    @objc func handleOfficial(){
        ViewController.varUrl.official = false
    }
    @objc func handleReset(){
        let index = IndexPath(row: 0, section: 0)
        let cell: PriceCell = self.userCollectionView.cellForItem(at: index) as! PriceCell
        
        cell.priceSlider.selectedMinimum = Float(ViewController.priceRange.pmin)
        cell.priceSlider.selectedMaximum = Float(ViewController.priceRange.pmax)
        cell.wholeSwitch.isOn = false
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
        self.dismiss(animated: true, completion: nil)
    }
}

class PriceCell: BaseCell {
   
    let labelMin : UILabel = {
        let label = UILabel()
        label.text = "Minimum Price"
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    let labelMax : UILabel = {
        let label = UILabel()
        label.text = "Maximum Price"
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()
    let hargaMin : UILabel = {
        let label = UILabel()
        label.text = "Rp " + String(ViewController.varUrl.pmin)
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    let hargaMax : UILabel = {
        let label = UILabel()
        label.text = "Rp " + String(ViewController.varUrl.pmax)
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .right
        return label
    }()
    
    let priceSlider : TTRangeSlider = {
        let slider = TTRangeSlider()
        slider.minValue = Float(ViewController.priceRange.pmin)
        slider.maxValue = Float(ViewController.priceRange.pmax)
        slider.selectedMinimum = Float(ViewController.varUrl.pmin)
        slider.selectedMaximum = Float(ViewController.varUrl.pmax)
        slider.tintColorBetweenHandles = UIColor(hex: "#64b157")
        slider.handleColor = UIColor.white
        slider.handleBorderColor = UIColor(hex: "#64b157")
        slider.handleBorderWidth = 1
        slider.handleDiameter = 33
        slider.hideLabels = true
        return slider
    }()
    
    let wholeLabel : UILabel = {
        let label = UILabel()
        label.text = "Whole Sale"
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()

    let wholeSwitch : UISwitch = {
        let whole = UISwitch()
        whole.setOn(false, animated: false)
        whole.tintColor = UIColor(hex: "#64b157")
        whole.onTintColor = UIColor(hex: "#64b157")
        whole.isOn = ViewController.varUrl.wholesale
        return whole
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        addSubview(dividerLineView)
        
        addConstraintsWithFormat("H:|-10-[v0(150)][v1(150)]-5-|", views: labelMin,labelMax)
        addConstraintsWithFormat("H:|-10-[v0(150)]-5-[v2][v1(150)]-5-|", views: hargaMin,hargaMax,dividerLineView)
        addConstraintsWithFormat("H:|-15-[v0]-15-|", views: priceSlider)
        addConstraintsWithFormat("H:|-10-[v0(150)][v1(50)]-10-|", views: wholeLabel,wholeSwitch)
        
        addConstraintsWithFormat("V:[v0]-5-[v1]-5-[v2]-5-[v3]-10-|", views: labelMin,hargaMin,priceSlider,wholeLabel)
        addConstraintsWithFormat("V:[v0]-5-[v1]-5-[v2]-5-[v3]-10-|", views: labelMax,hargaMax,priceSlider,wholeSwitch)
        
    }
}

class ShopCell: BaseCell {
    
    let TitleLabel : UILabel = {
        let label = UILabel()
        label.text = "Shop Type"
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    let nextImg: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "next")
        iv.layer.masksToBounds = true
        return iv
    }()
    let GoldSwitch : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "gold"), for: .normal)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let OfficialSwitch : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "official"), for: .normal)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(TitleLabel)
        addSubview(nextImg)
        addSubview(GoldSwitch)
        addSubview(OfficialSwitch)
        
        addConstraintsWithFormat("H:|-10-[v0(150)][v1(30)]-5-|", views: TitleLabel,nextImg)
        addConstraintsWithFormat("H:|-10-[v0(150)]-10-[v1(150)]", views: GoldSwitch,OfficialSwitch)
        
        addConstraintsWithFormat("V:|[v0(50)]-25-[v1(50)]-10-|", views: TitleLabel,GoldSwitch)
        addConstraintsWithFormat("V:|-10-[v0(30)]-25-[v1(50)]-10-|", views: nextImg,OfficialSwitch)
        
    }
}


