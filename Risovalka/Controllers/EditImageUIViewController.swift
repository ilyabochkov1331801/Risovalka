//
//  EditImageUIVViewController.swift
//  Risovalka
//
//  Created by Илья Бочков  on 5/11/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class EditImageUIViewController: UIViewController {

    var drawingImage: DrawingImage
    let drawingImageCollection = DrawingImageCollection.shared
    let brushSettings = BrushSettings.shared
    var swiped = false
    var lastPoint: CGPoint!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    init(drawingImage: DrawingImage) {
        self.drawingImage = drawingImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = drawingImage.image
        navigationItem.rightBarButtonItems = [ UIBarButtonItem(barButtonSystemItem: .save,
                                                               target: self,
                                                               action: #selector(saveNewImage)),
                                               UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                                               style: .plain,
                                                               target: self, action: #selector(share)),
                                               UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                               style: .plain,
                                                               target: self, action: #selector(settings)) ]
    }
    
    @objc func saveNewImage() {
        drawingImageCollection.addToCollection(image: drawingImage)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func settings() {
        let settingViewController = SettingViewController()
        present(settingViewController, animated: true, completion: nil)
    }
    
    @objc func share() {
        let activityVC = UIActivityViewController(activityItems: [ drawingImage.image ], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func markerButtonTaped(_ sender: UIButton) {
        guard let colorName = sender.restorationIdentifier else {
            return
        }
        guard let color = UIColor(named: colorName) else {
            return
        }
        brushSettings.color = color
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        swiped = false
        if let touch = touches.first{
            lastPoint = touch.location(in: imageView)
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(tempImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.draw(in: CGRect(x: 0,
                                         y: 0,
                                         width: tempImageView.frame.size.width,
                                         height: tempImageView.frame.size.height))
        
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        context?.setLineCap(.round)
        context?.setLineWidth(brushSettings.thickness)
        context?.setStrokeColor(brushSettings.color.cgColor)
        context?.setBlendMode(.normal)
        context?.strokePath()
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = brushSettings.opacity
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: imageView)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if !swiped {
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
        UIGraphicsBeginImageContext(imageView.frame.size)
        imageView.image?.draw(in: CGRect(x: 0,
                                         y: 0,
                                         width: imageView.frame.size.width,
                                         height: imageView.frame.size.height),
                              blendMode: .normal,
                              alpha: 1.0)
        tempImageView.image?.draw(in: CGRect(x: 0,
                                             y: 0,
                                             width: tempImageView.frame.size.width,
                                             height: tempImageView.frame.size.height),
                                  blendMode: .normal,
                                  alpha: brushSettings.opacity)
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        drawingImage.image = UIGraphicsGetImageFromCurrentImageContext()!
    }
}
