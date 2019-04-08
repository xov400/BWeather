import UIKit

class MainCollectionViewCell: UICollectionViewCell {

    private enum Constants {
        static let insets = UIEdgeInsets(top: 40, left: 20, bottom: 20, right: 20)
    }

    // MARK: - Properties

    var dependencies: HasImageService?
    var locationForecastModel: LocationForecastModel? {
        didSet {
            internalCollectionView.reloadData()
        }
    }
    private var currentSelectedIndexPath : IndexPath?
    private var previousSelectedIndexPath: IndexPath?
    private var currentDataIsVisible = true {
        didSet {
            currentContainerView.isHidden = !currentDataIsVisible
            forecastContainerView.isHidden = currentDataIsVisible
        }
    }

    weak var delegate: SelectCellDelegate?

    private(set) lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 35)
        return label
    }()

    //MARK: currentContainerView

    private lazy var currentContainerView = UIView()

    private(set) lazy var sunDrawView: DrawView = {
        let view = DrawView()
        view.layer.cornerRadius = 10
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 15
        view.clipsToBounds = true
        return view
    }()

    private(set) lazy var weatherConditionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 22)
        return label
    }()

    private(set) lazy var weatherConditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private(set) lazy var degreesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 100)
        return label
    }()

    //MARK: forecastContainerView

    private lazy var forecastContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()

    private(set) lazy var dayOfWeekLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 25)
        return label
    }()

    private private(set) lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 22)
        label.text = "Day"
        return label
    }()

    private(set) lazy var dayWeatherConditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private(set) lazy var dayDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "Arial", size: 15)
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.contentInset = UIEdgeInsets(top: -7, left: 0, bottom: 0, right: 0)
        return textView
    }()

    private private(set) lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    private private(set) lazy var nightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 22)
        label.text = "Night"
        return label
    }()

    private(set) lazy var nightWeatherConditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private(set) lazy var nightDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "Arial", size: 15)
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.contentInset = UIEdgeInsets(top: -7, left: 0, bottom: 0, right: 0)
        return textView
    }()

    private(set) lazy var lastUpdateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont(name: "Arial", size: 15)
        return label
    }()

    private lazy var internalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(InternalCollectionViewCell.self,
                                forCellWithReuseIdentifier: NSStringFromClass(InternalCollectionViewCell.self))
        collectionView.backgroundColor = .white
        collectionView.clipsToBounds = false
        collectionView.layer.shadowOpacity = 1
        collectionView.layer.shadowColor = UIColor.white.cgColor
        collectionView.layer.shadowRadius = 7
        collectionView.layer.shadowOffset = CGSize(width: 0, height: -12)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    // MARK: - Life cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(lastUpdateLabel)
        contentView.addSubview(internalCollectionView)

        contentView.addSubview(currentContainerView)
        currentContainerView.addSubview(sunDrawView)
        currentContainerView.addSubview(weatherConditionLabel)
        currentContainerView.addSubview(weatherConditionImageView)
        currentContainerView.addSubview(degreesLabel)

        contentView.addSubview(forecastContainerView)
        forecastContainerView.addSubview(dayOfWeekLabel)
        forecastContainerView.addSubview(dayLabel)
        forecastContainerView.addSubview(dayWeatherConditionImageView)
        forecastContainerView.addSubview(dayDescriptionTextView)
        forecastContainerView.addSubview(separatorView)
        forecastContainerView.addSubview(nightLabel)
        forecastContainerView.addSubview(nightWeatherConditionImageView)
        forecastContainerView.addSubview(nightDescriptionTextView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let viewsWidth = contentView.bounds.width - Constants.insets.left - Constants.insets.right
        let betweenViewsInset = contentView.bounds.height * 0.025

        cityNameLabel.frame = CGRect(x: Constants.insets.left,
                                     y: Constants.insets.top,
                                     width: viewsWidth, height: 37)

        internalCollectionView.frame = CGRect(x: 0,
                                              y: contentView.bounds.height * 0.73,
                                              width: contentView.bounds.width,
                                              height: contentView.bounds.height * 0.27)

        lastUpdateLabel.frame = CGRect(x: Constants.insets.left,
                                       y: internalCollectionView.frame.minY - betweenViewsInset - 30,
                                       width: viewsWidth,
                                       height: 16)

        let containerHeight = contentView.bounds.height * 0.7 - cityNameLabel.frame.maxY - lastUpdateLabel.bounds.height - 2 * betweenViewsInset

        currentContainerView.frame = CGRect(x: Constants.insets.left,
                                            y: cityNameLabel.frame.maxY + betweenViewsInset,
                                            width: viewsWidth,
                                            height: containerHeight)

        layoutCurrentContainerViewSubviews(betweenCurrentViewsInset: betweenViewsInset)

        forecastContainerView.frame = CGRect(x: Constants.insets.left,
                                            y: cityNameLabel.frame.maxY + betweenViewsInset,
                                            width: viewsWidth,
                                            height: containerHeight)

        layoutForecastContainerViewSubviews()
    }

    private func layoutCurrentContainerViewSubviews(betweenCurrentViewsInset: CGFloat) {
        let subViewsWidth = currentContainerView.bounds.width
        let height = contentView.bounds.height
        sunDrawView.frame = CGRect(x: 0, y: 0,
                                   width: subViewsWidth, height: height * 0.2)

        weatherConditionLabel.frame = CGRect(x: 0, y: sunDrawView.frame.maxY + betweenCurrentViewsInset,
                                             width: subViewsWidth, height: 24)

        weatherConditionImageView.frame = CGRect(x: 0, y: weatherConditionLabel.frame.maxY + betweenCurrentViewsInset,
                                                 width: subViewsWidth * 0.3,
                                                 height: height * 0.15)

        degreesLabel.frame = CGRect(x: weatherConditionImageView.frame.maxX,
                                    y: weatherConditionLabel.frame.maxY + betweenCurrentViewsInset,
                                    width: subViewsWidth * 0.6,
                                    height: height * 0.15)
    }

    private func layoutForecastContainerViewSubviews() {
        let subViewsWidth = forecastContainerView.bounds.width
        let betweenForecastViewsInset = contentView.bounds.height * 0.02
        let height = forecastContainerView.bounds.height
        dayOfWeekLabel.frame = CGRect(x: 0, y: 0,
                                      width: subViewsWidth,
                                      height: 26)

        dayLabel.frame = CGRect(x: 0, y: dayOfWeekLabel.frame.maxY + betweenForecastViewsInset,
                                width: subViewsWidth,
                                height: 24)

        dayWeatherConditionImageView.frame = CGRect(x: 0, y: dayLabel.frame.maxY + betweenForecastViewsInset,
                                                    width: height * 0.25,
                                                    height: height * 0.25)

        dayDescriptionTextView.frame = CGRect(x: dayWeatherConditionImageView.frame.maxX + 15,
                                              y: dayOfWeekLabel.frame.maxY + betweenForecastViewsInset,
                                              width: subViewsWidth - dayWeatherConditionImageView.bounds.width - 15,
                                              height: height * 0.4)

        separatorView.frame = CGRect(x: 0, y: dayDescriptionTextView.frame.maxY + betweenForecastViewsInset,
                                     width: subViewsWidth,
                                     height: 1)

        nightLabel.frame = CGRect(x: 0, y: separatorView.frame.maxY + betweenForecastViewsInset,
                                  width: subViewsWidth,
                                  height: 24)

        nightWeatherConditionImageView.frame = CGRect(x: 0, y: nightLabel.frame.maxY + betweenForecastViewsInset,
                                                      width: height * 0.25,
                                                      height: height * 0.25)

        nightDescriptionTextView.frame = CGRect(x: nightWeatherConditionImageView.frame.maxX + 15,
                                                y: separatorView.frame.maxY + betweenForecastViewsInset,
                                                width: subViewsWidth - nightWeatherConditionImageView.bounds.width - 15,
                                                height: height * 0.4)
    }
}

// MARK: - CollectionView delegates

extension MainCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let locationForecastModel = locationForecastModel,
            let daysForecastModels = locationForecastModel.daysForecastModels {
            return daysForecastModels.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(InternalCollectionViewCell.self),
                                                          for: indexPath) as! InternalCollectionViewCell
            collectInternalCollectionViewCell(cell: cell, indexPath: indexPath)
            return cell
    }

    private func collectInternalCollectionViewCell(cell: InternalCollectionViewCell, indexPath: IndexPath) {
        if let locationForecastModel = locationForecastModel,
            let daysForecastModels = locationForecastModel.daysForecastModels,
            let dependencies = dependencies {
            let dayForecast = daysForecastModels[indexPath.row]
            var weekday = Calendar.current.component(.weekday, from: dayForecast.date)
            cell.dayLabel.text = weekday.getShortWeekDay()
            cell.weatherConditionLabel.text = dayForecast.dayData.description
            cell.weatherConditionImageView.image = UIImage(named: "no-image")
            dependencies.imageService.fatchImage(imageName: dayForecast.dayData.imageName, success: { image in
                cell.weatherConditionImageView.image = image
            }, failure: { error in
                print(error.localizedDescription)
            })
            cell.dayTemperatureLabel.text = "\(dayForecast.dayData.temp)\u{00B0}"
            cell.nightTemperatureLabel.text = "\(dayForecast.nightData.temp)\u{00B0}"

            // (1) how could I come up it and it-> (2)
            if currentSelectedIndexPath != nil, currentSelectedIndexPath == indexPath, !currentDataIsVisible {
                cell.backgroundColor = UIColor.azureRadiance.withAlphaComponent(0.5)
            } else {
                cell.backgroundColor = UIColor.azureRadiance.withAlphaComponent(1.0)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentDataIsVisible || (!currentDataIsVisible && indexPath == previousSelectedIndexPath) {
            currentDataIsVisible = !currentDataIsVisible
        }
        
        delegate?.internalCollectionView(didSelectItemAt: indexPath, currentDataIsVisible: currentDataIsVisible)

        // (2) how could I come up it and it-> (1)
        if previousSelectedIndexPath != nil {
            if let cell = collectionView.cellForItem(at: previousSelectedIndexPath!) {
                cell.backgroundColor = UIColor.azureRadiance.withAlphaComponent(1.0)
            }
        }
        currentSelectedIndexPath = indexPath
        previousSelectedIndexPath = indexPath
        collectionView.reloadItems(at: [indexPath])
    }
}

extension MainCollectionViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 40) / 4, height: collectionView.bounds.height - 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: contentView.bounds.height * 0.01, right: 5)
    }
}
