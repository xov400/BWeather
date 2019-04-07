//
//  Created by Александр on 8.02.2019
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class InternalCollectionViewCell: UICollectionViewCell {

    var selectionCellViewisHidden = true
    private(set) lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont(name: "Arial", size: 18)
        return label
    }()

    private(set) lazy var weatherConditionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont(name: "Arial", size: 12)
        return label
    }()

    private(set) lazy var weatherConditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private(set) lazy var dayTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.yellow
        label.font = UIFont(name: "Arial", size: 18)
        return label
    }()
    
    private(set) lazy var nightTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont(name: "Arial", size: 18)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 15
        layer.shadowOpacity = 0.7
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowRadius = 1
        layer.shadowOffset = CGSize(width: 2, height: 3)
        backgroundColor = .azureRadiance
        contentView.addSubview(dayLabel)
        contentView.addSubview(weatherConditionLabel)
        contentView.addSubview(weatherConditionImageView)
        contentView.addSubview(dayTemperatureLabel)
        contentView.addSubview(nightTemperatureLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let width = contentView.bounds.width
        let heigth = contentView.bounds.height
        dayLabel.frame = CGRect(x: 0, y: 0, width: width, height: heigth * 0.15)
        weatherConditionLabel.frame = CGRect(x: 0, y: heigth * 0.15, width: width, height: heigth * 0.15)
        weatherConditionImageView.frame = CGRect(x: 0, y: heigth * 0.3, width: width, height: heigth * 0.4)
        dayTemperatureLabel.frame = CGRect(x: 0, y: heigth * 0.7, width: width, height: heigth * 0.15)
        nightTemperatureLabel.frame = CGRect(x: 0, y: heigth * 0.85, width: width, height: heigth * 0.15)
    }
}
