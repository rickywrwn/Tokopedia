//
//  ShopFilterPage.swift
//  tokopedia
//
//  Created by Ricky Wirawan on 08/09/18.
//  Copyright © 2018 Ricky Wirawan. All rights reserved.
//

import UIKit

class ShopFilterPage: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    fileprivate let ShopTypeCellId = "ShopTypeCellId"
    var goldChecked = ViewController.varUrl.official
    var officialChecked = ViewController.varUrl.fshop
    
    var userCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
        userCollectionView.backgroundColor = UIColor(hex: "#f1f1f1")
        userCollectionView.register(ShopTypeCell.self, forCellWithReuseIdentifier: ShopTypeCellId)
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
        var customView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        
        var button = UIButton.init(type: .custom)
        button.setBackgroundImage(UIImage(named: "x"), for: .normal)
        button.frame = CGRect(x: 0, y: 5, width: 32, height: 32)
        button.addTarget(self, action: #selector(handleLeft), for: .touchUpInside)
        customView.addSubview(button)
        
        var marginX = CGFloat(button.frame.origin.x + button.frame.size.width + 15)
        var label = UILabel(frame: CGRect(x: marginX, y: 0, width: 130, height: 44))
        label.text = "Shop Type"
        label.textColor = UIColor.black
        label.textAlignment = .left
        customView.addSubview(label)
        
        var leftButton = UIBarButtonItem(customView: customView)
        
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(handleReset))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(hex: "#64b157")
        
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

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopTypeCellId, for: indexPath) as! ShopTypeCell
        cell.backgroundColor = UIColor.white
        cell.goldBtn.addTarget(self, action: #selector(handleGold), for: .touchDown)
        cell.officialBtn.addTarget(self, action: #selector(handleOfficial), for: .touchDown)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    @objc func handleLeft(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleOfficial(){
        let index = IndexPath(row: 0, section: 0)
        let cell: ShopTypeCell = self.userCollectionView.cellForItem(at: index) as! ShopTypeCell

        if officialChecked == false{
            cell.officialBtn.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            officialChecked = true
        }else if officialChecked == true{
            cell.officialBtn.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            officialChecked = false
        }
    }
    @objc func handleGold(){
        let index = IndexPath(row: 0, section: 0)
        let cell: ShopTypeCell = self.userCollectionView.cellForItem(at: index) as! ShopTypeCell
        
        if goldChecked == false{
            cell.goldBtn.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            goldChecked = true
        }else if goldChecked == true{
            cell.goldBtn.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            goldChecked = false
        }
    }
    @objc func handleReset(){
        let index = IndexPath(row: 0, section: 0)
        let cell: ShopTypeCell = self.userCollectionView.cellForItem(at: index) as! ShopTypeCell
        cell.officialBtn.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        cell.goldBtn.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        goldChecked = false
        officialChecked = false
    }
    
    @objc func handleApply(){
        ViewController.varUrl.official = officialChecked
        ViewController.varUrl.fshop = goldChecked
        self.dismiss(animated: true, completion: nil)
    }
}


class ShopTypeCell: BaseCell {
    
    let goldLabel : UILabel = {
        let label = UILabel()
        label.text = "Gold Merchant"
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    let goldBtn : UIButton = {
        let button = UIButton()
        if ViewController.varUrl.fshop == true{
            button.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        }else{
            button.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        }
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let officialLabel : UILabel = {
        let label = UILabel()
        label.text = "Official Store"
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    let officialBtn : UIButton = {
        let button = UIButton()
        if ViewController.varUrl.official == true{
            button.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        }else{
            button.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        }
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override func setupViews() {
        super.setupViews()
        
        addSubview(goldLabel)
        addSubview(goldBtn)
        addSubview(dividerLineView)
        addSubview(officialBtn)
        addSubview(officialLabel)
        
        addConstraintsWithFormat("H:|-5-[v0(25)]-10-[v1]|", views: goldBtn,goldLabel)
        addConstraintsWithFormat("H:|-5-[v0(25)]-10-[v1]|", views: officialBtn,officialLabel)
        addConstraintsWithFormat("H:|-35-[v0]|", views: dividerLineView)
        
        addConstraintsWithFormat("V:|-20-[v0(25)]-20-[v1(1)]-20-[v2(25)]-20-|", views:goldBtn,dividerLineView,officialBtn )
        addConstraintsWithFormat("V:|-20-[v0(25)]-20-[v1(1)]-20-[v2(25)]-20-|", views:goldLabel,dividerLineView,officialLabel )
        
    }
}
