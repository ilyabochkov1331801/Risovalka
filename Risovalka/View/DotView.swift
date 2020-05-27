//
//  DotView.swift
//  Risovalka
//
//  Created by Илья Бочков  on 5/14/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

@IBDesignable class DotView: UIView {
    @IBInspectable var thickness: CGFloat = 10.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var opacity: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var color: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(arcCenter: CGPoint(x: rect.midX,
                                                   y: rect.midY),
                                radius: thickness,
                                startAngle: 0,
                                endAngle: 2 * CGFloat.pi,
                                clockwise: true)
        color.setFill()
        path.fill()
        UIColor.black.setStroke()
        path.stroke()
        layer.opacity = Float(opacity)
    }
}
