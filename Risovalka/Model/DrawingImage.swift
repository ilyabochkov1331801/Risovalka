//
//  DrawingImage.swift
//  Risovalka
//
//  Created by Илья Бочков  on 5/11/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit
import CoreData

class DrawingImage {
    var image: UIImage
    let id: String
    
    init(id: String = UUID().uuidString, image: UIImage?) {
        self.id = id
        self.image = image ?? UIImage(named: "whitePicture")!
    }
    
}
