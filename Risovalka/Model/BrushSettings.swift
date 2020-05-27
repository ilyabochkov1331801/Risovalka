//
//  BrushSettings.swift
//  Risovalka
//
//  Created by Илья Бочков  on 5/14/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

class BrushSettings {
    var thickness: CGFloat
    var opacity: CGFloat
    var color: UIColor
    
    static var shared = {
        return BrushSettings()
    }()
    
    private init() {
        thickness = 10.0
        opacity = 1.0
        color = .black
    }
}
