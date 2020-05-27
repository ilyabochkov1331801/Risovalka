//
//  DrawingImageCollection.swift
//  Risovalka
//
//  Created by Илья Бочков  on 5/11/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit
import CoreData

class DrawingImageCollection {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private(set) var modelArray: Array<DrawingImage>

    private init() {
        modelArray = []
        let fetchRequest: NSFetchRequest<ImageManagedObject> = ImageManagedObject.fetchRequest()
        do {
            let storedModelArray = try context.fetch(fetchRequest)
            for storedModel in storedModelArray {
                modelArray.append(DrawingImage(id: storedModel.id!, image: UIImage(data: storedModel.image!)!))
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static var shared: DrawingImageCollection = {
        return DrawingImageCollection()
    }()
    
    func addToCollection(image: DrawingImage) {
        let fetchRequest: NSFetchRequest<ImageManagedObject> = ImageManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", image.id)
        do {
            let imageManagedObjects = try context.fetch(fetchRequest)
            guard let imageManagedObject = imageManagedObjects.first else {
                let entity = NSEntityDescription.entity(forEntityName: "ImageManagedObject", in: context)
                let imageManagedObject = NSManagedObject(entity: entity!, insertInto: context) as! ImageManagedObject
                imageManagedObject.id = image.id
                imageManagedObject.image = image.image.pngData()
                modelArray.append(image)
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
                return
            }
            imageManagedObject.image = image.image.pngData()
            for (index, modelImage) in modelArray.enumerated() {
                if modelImage.id == image.id {
                    modelArray[index] = image
                }
            }
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteFromCollection(with index: Int) {
        let fetchRequest: NSFetchRequest<ImageManagedObject> = ImageManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", modelArray[index].id)
        do {
            let imageManagedObjects = try context.fetch(fetchRequest)
            guard let imageManagedObject = imageManagedObjects.first else {
                return
            }
            context.delete(imageManagedObject)
            do {
                try context.save()
                modelArray.remove(at: index)
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
