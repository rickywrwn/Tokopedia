//
//  ViewController.swift
//  tokopedia
//
//  Created by Ricky Wirawan on 06/09/18.
//  Copyright © 2018 Ricky Wirawan. All rights reserved.
//

import UIKit

struct tokped: Decodable {
    let data: [data]
}

struct data: Decodable {
    let id: Int
    let name: String
    let image_uri: String
    let image_uri_700: String
    let price: String
}

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    struct varUrl {
        static var q = "samsung"
        static var pmin = 10000
        static var pmax = 100000
        static var wholesale = true
        static var official = true
        static var fshop = "2"
        static var start = "0"
        static var row = "10"
    }
    
    static var url : String = "https://ace.tokopedia.com/search/v2.5/product?q=\(String(describing: varUrl.q))&pmin=\(String(describing: varUrl.pmin))&pmax=\(String(describing: varUrl.pmax))&wholesale=\(String(describing: varUrl.wholesale))&official=\(String(describing: varUrl.official))&fshop=\(String(describing: varUrl.fshop))&start=\(String(describing: varUrl.start))&rows=\(String(describing: varUrl.row))"
    var products : tokped?
    var jml : Int = 0
    func fetchJSON(){
        let urlString = ViewController.url
        
        URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: { (data, response, error) -> Void in
            
            guard let data = data else { return }
            
            if let error = error {
                print(error)
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                let product = try decoder.decode(tokped.self, from: data)
                print(product)
                self.jml = product.data.count
                self.products = product
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.collectionView!.reloadData()
                })
                
            } catch let err {
                print(err)
            }
            
            
        }).resume()
    }
    
    fileprivate let ProductCellId = "ProductCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchJSON()
        setupView()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ProductCell.self, forCellWithReuseIdentifier: ProductCellId)
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
        navigationItem.title = "Search"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(handleLeft))
        
        navbar.setItems([navigationItem], animated: false)
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor.white
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        
        collectionView?.frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - 124))
        
        view.addSubview(filterButton)
        filterButton.leftAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        filterButton.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true
        filterButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        filterButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
    }
    
    let filterButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        button.setTitle("Filter", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: "#64b157")
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleFilter), for: UIControlEvents.touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleLeft(){
        
    }
    
    @objc func handleFilter(){
        let filterPage = FilterPage()
        present(filterPage, animated: true, completion: {
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return jml
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCellId, for: indexPath) as! ProductCell
        cell.app = products?.data[indexPath.row]

        cell.layer.borderWidth = 1
        let black = UIColor(hex: "#000000")
        let blackAlpha = black.alpha(0.3)
        cell.layer.borderColor = blackAlpha.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/2, height: 275)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(varUrl.pmin)
        print(varUrl.pmax)
    }


}

