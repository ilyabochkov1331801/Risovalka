//
//  SettingViewController.swift
//  Risovalka
//
//  Created by Илья Бочков  on 5/14/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    let brushSettings = BrushSettings.shared
    
    @IBOutlet weak var thicknessSliderOutlet: UISlider!
    @IBOutlet weak var opacitySliderOutlet: UISlider!
    @IBOutlet weak var dotViewOutlet: DotView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dotViewOutlet.color = brushSettings.color
        dotViewOutlet.opacity = brushSettings.opacity
        dotViewOutlet.thickness = brushSettings.thickness
        opacitySliderOutlet.value = Float(brushSettings.opacity)
        thicknessSliderOutlet.value = Float(brushSettings.thickness)
    }
    
    @IBAction func thicknessSliderValueChanged(_ sender: UISlider) {
        dotViewOutlet.thickness = CGFloat(sender.value)
        brushSettings.thickness = CGFloat(sender.value)
    }
    
    @IBAction func opacitySliderValueChanged(_ sender: UISlider) {
        dotViewOutlet.opacity = CGFloat(sender.value)
        brushSettings.opacity = CGFloat(sender.value)
    }
    
    @IBAction func doneButtonTaped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
