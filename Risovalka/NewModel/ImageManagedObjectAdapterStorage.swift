//
//  ImageManagedObjectAdapterStorage.swift
//  Risovalka
//
//  Created by Илья Бочков  on 5/28/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import CoreData
import UIKit

class ImageManagedObjectStorage {
    
    static var shared: ImageManagedObjectStorage = {
        return ImageManagedObjectStorage()
    }()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var storage: Array<ImageManagedObject>!
    
    private init() {
        reloadData()
    }
    
    private func reloadData() {
        let fetchRequest: NSFetchRequest<ImageManagedObject> = ImageManagedObject.fetchRequest()
        do {
            storage = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func imageModel(with index: Int) -> ImageManagedObjectAdapter {
        return ImageManagedObjectAdapter(adoptee: storage[index])
    }
    
    private func appendExistModel(with id: String, image: UIImage) {
        let fetchRequest: NSFetchRequest<ImageManagedObject> = ImageManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let imageManagedObjects = try context.fetch(fetchRequest)
            guard let imageManagedObject = imageManagedObjects.first else {
                appendNewModel(image: image)
                return
            }
            ImageManagedObjectAdapter(adoptee: imageManagedObject).setImage(with: image)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func appendNewModel(image: UIImage) {
        let _ = ImageManagedObjectAdapter(image: image, context: context)
    }
    
    func appendModel(with id: String?, image: UIImage) {
        if let id = id {
            appendExistModel(with: id, image: image)
        } else {
            appendNewModel(image: image)
        }
        saveContext()
    }
}
