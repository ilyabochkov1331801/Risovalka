//
//  ImageCollectionViewCell.swift
//  Risovalka
//
//  Created by Илья Бочков  on 5/11/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var contentImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateData() {
        contentImageView.image = UIImage(systemName: "pencil")
    }
}
