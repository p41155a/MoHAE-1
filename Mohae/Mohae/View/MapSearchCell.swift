//
//  MapSearchCell.swift
//  Mohae
//
//  Created by 권혁준 on 25/09/2019.
//  Copyright © 2019 권혁준. All rights reserved.
//

import UIKit

class MapSearchCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder :) has not been implemented")
    }
    
    var lat : Double?
    var lng : Double?
    var id : String?
    var place_id : String?
    
    var name: UILabel = {
       let name  = UILabel()
       name.translatesAutoresizingMaskIntoConstraints = false
       return name
    }()
    
    var icon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    var type: UILabel = {
        let type = UILabel()
        type.translatesAutoresizingMaskIntoConstraints = false
        return type
    }()
    
    var type2: UILabel = {
        let type = UILabel()
        type.translatesAutoresizingMaskIntoConstraints = false
        return type
    }()
    
    func setupView(){
        addSubview(name)
        addSubview(icon)
        addSubview(type)
        addSubview(type2)
        
        name.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        name.widthAnchor.constraint(equalToConstant: 400).isActive = true
        name.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        icon.topAnchor.constraint(equalTo: type.bottomAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 200).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        type.topAnchor.constraint(equalTo: name.bottomAnchor).isActive = true
        type.widthAnchor.constraint(equalToConstant: 100).isActive = true
        type.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        type2.topAnchor.constraint(equalTo: type.topAnchor).isActive = true
        type2.leftAnchor.constraint(equalTo: type.rightAnchor).isActive = true
        type2.widthAnchor.constraint(equalToConstant: 100).isActive = true
        type2.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        name.text = nil
        type.text = nil
    }
}
