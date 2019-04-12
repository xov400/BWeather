//
//  Created by Александр on 16.02.2019
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import CoreGraphics

final class DrawView: UIView {

    var sunLayerColor = UIColor.christine.cgColor
    var percentage: CGFloat = 0 {
        didSet {
            sunLayer.fillColor = sunLayerColor
            setNeedsDisplay()
        }
    }

    private lazy var sunPathLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.gray.cgColor
        layer.lineWidth = 5.0
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()

    private lazy var sunLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()

    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.gray.cgColor, UIColor.blue.cgColor]
        gradient.locations = [0.0, 1.0]
        return gradient
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(gradientLayer)
        layer.addSublayer(sunPathLayer)
        layer.addSublayer(sunLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        sunPathLayer.frame = bounds
        sunLayer.frame = bounds
    }

    override func draw(_ rect: CGRect) {
        let width = bounds.width
        let scaleRadius = width * 0.4
        let center = CGPoint(x: width / 2, y: width / 2)
        let sunLinePath = UIBezierPath(arcCenter: center,
                                       radius: scaleRadius,
                                       startAngle: .pi,
                                       endAngle: 0,
                                       clockwise: true)
        sunPathLayer.path = sunLinePath.cgPath

        let corner = CGFloat(200 + percentage * 140)
        let sunPath = UIBezierPath(arcCenter: CGPoint(x: scaleRadius * cos(corner * .pi / 180) + width / 2,
                                                      y: scaleRadius * sin(corner * .pi / 180) + width / 2),
                                   radius: bounds.height * 0.15,
                                   startAngle: 0,
                                   endAngle: CGFloat(2 * Double.pi),
                                   clockwise: false)
        sunLayer.path = sunPath.cgPath
    }
}
