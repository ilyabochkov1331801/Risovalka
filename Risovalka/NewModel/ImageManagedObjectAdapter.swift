//
//  ImageManagedObjectAdapter.swift
//  Risovalka
//
//  Created by Илья Бочков  on 5/28/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import CoreData
import UIKit

class ImageManagedObjectAdapter {
    private let imageManagedObject: ImageManagedObject
    
    init(adoptee: ImageManagedObject) {
        self.imageManagedObject = adoptee
    }
    
    init(image: UIImage, context: NSManagedObjectContext) {
        guard let entity = NSEntityDescription.entity(forEntityName: "ImageManagedObject", in: context) else {
            fatalError()
        }
        imageManagedObject = NSManagedObject(entity: entity, insertInto: context) as! ImageManagedObject
        imageManagedObject.id = UUID().uuidString
        imageManagedObject.image = image.pngData()
    }
    
    lazy var image: UIImage? = {
        guard let imageData = imageManagedObject.image else {
            return nil
        }
        guard let image = UIImage(data: imageData) else {
            return nil
        }
        return image
    }()
    
    func setImage(with image: UIImage) {
        imageManagedObject.image = image.pngData()
    }
    
    lazy var id: String? = {
        guard let id = imageManagedObject.id else {
            return nil
        }
        return id
    }()
}
