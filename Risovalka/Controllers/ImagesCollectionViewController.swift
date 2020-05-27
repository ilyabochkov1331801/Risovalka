//
//  ImagesCollectionViewController.swift
//  Risovalka
//
//  Created by Илья Бочков  on 5/11/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ImagesCollectionViewController: UICollectionViewController {

    let drawingImageCollection = DrawingImageCollection.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drawingImageCollection.modelArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        let imageView = UIImageView(frame: cell.contentView.bounds)
        cell.contentView.addSubview(imageView)
        imageView.image = drawingImageCollection.modelArray[indexPath.row].image
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return cell
    }

    @IBAction func addNewImage(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: "Add image", preferredStyle: .actionSheet)
        let galleryButton = UIAlertAction(title: "Gallery", style: .default) {
            [weak self] _ in
            self?.addPhotoViewController()
        }
        let cameraButton = UIAlertAction(title: "Take photo", style: .default) {
            [weak self] _ in
            self?.addCameraViewController()
        }
        let emptyImageButton = UIAlertAction(title: "Empty image", style: .default) {
            [weak self] _ in
            self?.openEditViewController(with: DrawingImage(image: nil))
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(galleryButton)
        alert.addAction(cameraButton)
        alert.addAction(emptyImageButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
        
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openEditViewController(with: drawingImageCollection.modelArray[indexPath.row])
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {
            actions -> UIMenu? in
            let delete = UIAction(title: "Delete",
                                  image: UIImage(systemName: "trash"),
                                  identifier: nil,
                                  discoverabilityTitle: nil,
                                  attributes: .destructive,
                                  state: .off) {
                                    [weak self] _ in
                                    self?.drawingImageCollection.deleteFromCollection(with: indexPath.row)
                                    self?.collectionView.reloadData()}
            let share = UIAction(title: "Share",
                                 image: UIImage(systemName: "square.and.arrow.up"),
                                 identifier: nil,
                                 discoverabilityTitle: nil,
                                 attributes: .init(),
                                 state: .off) {
                                    [weak self] _ in
                                    guard let sharedImage = self?.drawingImageCollection.modelArray[indexPath.row].image else {
                                        return
                                    }
                                    let activityVC = UIActivityViewController(activityItems: [ sharedImage ], applicationActivities: nil)
                                    self?.present(activityVC, animated: true, completion: nil)
            }
            return UIMenu(title: "Image", image: nil, identifier: nil, options: .init(), children: [ share, delete ])
        }
        return configuration
    }
}

extension ImagesCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func addPhotoViewController() {
        let photoViewController = UIImagePickerController()
        photoViewController.sourceType = .photoLibrary
        photoViewController.delegate = self
        present(photoViewController, animated: true)
    }
    
    private func addCameraViewController() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraViewController = UIImagePickerController()
            cameraViewController.sourceType = .camera
            cameraViewController.delegate = self
            present(cameraViewController, animated: true)
        } else {
            showNoCameraAlert()
        }
    }
    
    private func showNoCameraAlert() {
        let alertViewController = UIAlertController(title: "No Camera", message: "Sorry, this device hasn't got camera", preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style:.default))
        present(alertViewController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let newPhoto = info[.originalImage] as? UIImage {
            openEditViewController(with: DrawingImage(image: newPhoto))
        }
    }
    
    private func openEditViewController(with drawingImage: DrawingImage) {
        let editImageViewController = EditImageUIViewController(drawingImage: drawingImage)
        navigationController?.pushViewController(editImageViewController, animated: true)
    }
}

