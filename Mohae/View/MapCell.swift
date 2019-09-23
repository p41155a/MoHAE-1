//
//  MapCell.swift
//  Mohae
//
//  Created by 권혁준 on 10/09/2019.
//  Copyright © 2019 권혁준. All rights reserved.
//

import Foundation

class MapCell : UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    var mapx: Double?
    var mapy: Double?
    
    var title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()

    var address: UILabel = {
        let address = UILabel()
        address.translatesAutoresizingMaskIntoConstraints = false
        return address
    }()
    
    var link: UILabel = {
        let link = UILabel()
        link.translatesAutoresizingMaskIntoConstraints = false
        return link
    }()
    
    var phone: UILabel = {
        let phone = UILabel()
        phone.translatesAutoresizingMaskIntoConstraints = false
        return phone
    }()
    
    var category: UILabel = {
        let category = UILabel()
        category.translatesAutoresizingMaskIntoConstraints = false
        return category
    }()
    
    
    func setupView(){
        
        addSubview(phone)
        addSubview(address)
        addSubview(category)
        addSubview(link)
        addSubview(title)
        
        title.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        title.widthAnchor.constraint(equalToConstant: 200).isActive = true
        title.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        category.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 3).isActive = true
        category.widthAnchor.constraint(equalToConstant: 200).isActive = true
        category.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        phone.topAnchor.constraint(equalTo: category.bottomAnchor, constant: 3).isActive = true
        phone.widthAnchor.constraint(equalToConstant: 200).isActive = true
        phone.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        link.topAnchor.constraint(equalTo: phone.bottomAnchor, constant: 3).isActive = true
        link.widthAnchor.constraint(equalToConstant: 200).isActive = true
        link.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        address.topAnchor.constraint(equalTo: link.bottomAnchor, constant: 3).isActive = true
        address.widthAnchor.constraint(equalToConstant: 200).isActive = true
        address.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
        address.text = nil
        link.text = nil
        phone.text = nil
        category.text = nil
    }
}

