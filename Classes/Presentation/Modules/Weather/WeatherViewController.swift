import UIKit


final class WeatherViewController: UIViewController {

    // MARK: - Properties

    private var currentSelectedIndexPathInternalCollectionView: IndexPath?
    private var previousSelectedIndexPathInternalCollectionView: IndexPath?
    private var currentDataIsVisible = true

    typealias Dependencies = HasWeatherService & HasImageService & HasLocationService
    private let dependencies: Dependencies

    private var models: [LocationForecastModel] = []
    private var lacationsForecastsArray: [WeatherForecastResponseModel] = []

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        indicator.color = UIColor.black
        indicator.backgroundColor = UIColor.malibu
        return indicator
    }()

    private lazy var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(MainCollectionViewCell.self,
                                forCellWithReuseIdentifier: NSStringFromClass(MainCollectionViewCell.self))
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .malibu
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    // MARK: - Life cycle

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.addSubview(mainCollectionView)
        view.addSubview(activityIndicatorView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainCollectionView.frame = CGRect(x: 0, y: 0, width: view.bounds.width,
                                          height: view.bounds.height - safeAreaInsets.bottom)
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        models = dependencies.locationService.getFavouritesLocations().map { locationInformation -> LocationForecastModel in
            return LocationForecastModel(location: locationInformation)
        }
        fetchData()
    }

    //    MARK: - Fetch data

    private func fetchData() {
        if models.count == 0 {
            tabBarController?.selectedIndex = 2
            checkUpdatesLocationFile(dispatchGroup: nil)
            return
        }
        lacationsForecastsArray = []
        activityIndicatorView.startAnimating()

        DispatchQueue.global(qos: .background).async {
            let dispatchGroup = DispatchGroup()

            self.checkUpdatesLocationFile(dispatchGroup: dispatchGroup)

            self.models.forEach { model in
                self.sendWeatherForecastRequest(model: model,
                                                location: "\(model.location.name),\(model.location.country)",
                                                dispatchGroup: dispatchGroup)
            }

            dispatchGroup.wait()

            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.mainCollectionView.reloadData()
            }
        }
    }

    private func checkUpdatesLocationFile(dispatchGroup: DispatchGroup?) {
        let defaults = UserDefaults.standard

        if let updateDate = defaults.value(forKey: "Update date") as? Date, updateDate != Date() {
            return
        }

        self.dependencies.locationService.fetchLocationFile(dispatchGroup: dispatchGroup, failure: { error in
            self.presentAlert(message: error.localizedDescription, handler: nil)
        })

        let updateDate = Date().addingTimeInterval(60 * 60 * 24 * 7)
        defaults.setValue(updateDate, forKey: "Update date")
    }

    private func sendWeatherForecastRequest(model: LocationForecastModel,
                                            location: String,
                                            dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        dependencies.weatherService.fatchWeatherForecasts(location: location,
                                                          success: { weatherForecastModel in
                                                            self.lacationsForecastsArray.append(weatherForecastModel)
                                                            model.daysForecastModels = self.createDaysForecastArray(from: weatherForecastModel)
                                                            dispatchGroup.leave()
        }, failure: { error in
            self.activityIndicatorView.stopAnimating()
            self.presentAlert(message: error.localizedDescription, handler: nil)
            dispatchGroup.leave()
        })
    }

    private func createDaysForecastArray(from weatherForecastModel: WeatherForecastResponseModel) -> [DayForecastModel] {
        let dailyWeatherInformationArray = createDailyWeatherInformationArray(from: weatherForecastModel)
        return dailyWeatherInformationArray.compactMap { dayWeatherInformation -> DayForecastModel? in
            let maxElem = dayWeatherInformation.max {
                $0.mainWeatherInformation.maximalTemp < $1.mainWeatherInformation.maximalTemp
            }

            let minElem = dayWeatherInformation.min {
                $0.mainWeatherInformation.minimalTemp < $1.mainWeatherInformation.minimalTemp
            }
            guard let maxTempElem = maxElem, let minTempElem = minElem else {
                return nil
            }
            let dayData = DayData(temp: Int(maxTempElem.mainWeatherInformation.temp),
                                  pressure: Int(maxTempElem.mainWeatherInformation.pressure),
                                  humidity: maxTempElem.mainWeatherInformation.humidity,
                                  cloudiness: maxTempElem.cloudiness.percent,
                                  windSpeed: maxTempElem.wind.speed,
                                  direction: maxTempElem.wind.deg.windDirection,
                                  rainVolume: maxTempElem.rain?.volume,
                                  snowVolume: maxTempElem.snow?.volume,
                                  parameters: maxTempElem.weatherCondition[0].parameters,
                                  description: maxTempElem.weatherCondition[0].description,
                                  imageName: maxTempElem.weatherCondition[0].iconName)

            let nightData = NightData(temp: Int(minTempElem.mainWeatherInformation.temp),
                                      pressure: Int(minTempElem.mainWeatherInformation.pressure),
                                      humidity: minTempElem.mainWeatherInformation.humidity,
                                      cloudiness: minTempElem.cloudiness.percent,
                                      windSpeed: minTempElem.wind.speed,
                                      direction: minTempElem.wind.deg.windDirection,
                                      rainVolume: minTempElem.rain?.volume,
                                      snowVolume: minTempElem.snow?.volume,
                                      parameters: minTempElem.weatherCondition[0].parameters,
                                      description: minTempElem.weatherCondition[0].description,
                                      imageName: minTempElem.weatherCondition[0].iconName)
            return DayForecastModel(date: dayWeatherInformation[0].timeOfForecast,
                                    dayData: dayData,
                                    nightData: nightData)
        }
    }

    private func createDailyWeatherInformationArray(from weatherForecastModel: WeatherForecastResponseModel) -> [[ThreeHoursWeatherInformation]] {
        var currentDay = Calendar.current.component(.day, from: Date())
        var dailyWeatherInformationArray: [[ThreeHoursWeatherInformation]] = []
        var dayWeatherInformation: [ThreeHoursWeatherInformation] = []
        var iteration = 1

        weatherForecastModel.threeHoursWeatherInformationArray.forEach { threeHoursWeatherInformation in
            let day = Calendar.current.component(.day, from: threeHoursWeatherInformation.timeOfForecast)
            if iteration == weatherForecastModel.threeHoursWeatherInformationArray.count {
                dayWeatherInformation.append(threeHoursWeatherInformation)
                dailyWeatherInformationArray.append(dayWeatherInformation)
            } else if day == currentDay {
                dayWeatherInformation.append(threeHoursWeatherInformation)
            } else {
                dailyWeatherInformationArray.append(dayWeatherInformation)
                dayWeatherInformation.removeAll()
                dayWeatherInformation.append(threeHoursWeatherInformation)
                currentDay = day
            }
            iteration += 1
        }
        return dailyWeatherInformationArray
    }
}

// MARK: - CollectionView delegates

extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(MainCollectionViewCell.self),
                                                      for: indexPath) as! MainCollectionViewCell

        if lacationsForecastsArray.count > 0 {
            cell.delegate = self
            cell.locationForecastModel = models[indexPath.row]
            cell.dependencies = dependencies
            cell.cityNameLabel.text = lacationsForecastsArray[indexPath.row].cityInformation.name
            cell.currentDataIsVisible = currentDataIsVisible
            cell.currentSelectedIndexPath = currentSelectedIndexPathInternalCollectionView
            cell.previousSelectedIndexPath = previousSelectedIndexPathInternalCollectionView

            if currentDataIsVisible {
                collectCurrentMainCollectionViewCell(cell: cell, indexPath: indexPath)
            } else {
                collectForecastMainCollectionViewCell(cell: cell, indexPath: indexPath)
            }

            cell.lastUpdateLabel.text = "Last update: \(Date().toFormattedString)"
        }

        return cell
    }

    private func collectCurrentMainCollectionViewCell(cell: MainCollectionViewCell, indexPath: IndexPath) {
        let nowForecast = lacationsForecastsArray[indexPath.row].threeHoursWeatherInformationArray[0]
        cell.sunDrawView.percentage = calculatePercentage(cell: cell)
        cell.weatherConditionLabel.text = nowForecast.weatherCondition[0].description
        cell.degreesLabel.text = "\(Int(nowForecast.mainWeatherInformation.temp))\u{00B0}"
        cell.weatherConditionImageView.image = UIImage(named: "no-image")
        dependencies.imageService.fatchImage(imageName: nowForecast.weatherCondition[0].iconName, success: { image in
            cell.weatherConditionImageView.image = image
        })
    }

    private func calculatePercentage(cell: MainCollectionViewCell) -> CGFloat {
        let hour = CGFloat(Calendar.current.component(.hour, from: Date()))
        if (7...19).contains(hour) {
            cell.sunDrawView.sunLayerColor = UIColor.christine.cgColor
            return (hour - 7.0) / 12.0
        } else if (19...23).contains(hour) {
            cell.sunDrawView.sunLayerColor = UIColor.mintTulip.cgColor
            return (hour - 20.0) / 10.0
        } else {
            cell.sunDrawView.sunLayerColor = UIColor.mintTulip.cgColor
            return 0.4 + hour * 0.1
        }
    }

    private func collectForecastMainCollectionViewCell(cell: MainCollectionViewCell, indexPath mainIndexPath: IndexPath) {
        if let daysForecastModels = models[mainIndexPath.row].daysForecastModels,
            let selectedIndexPath = currentSelectedIndexPathInternalCollectionView {
            let dayForecast = daysForecastModels[selectedIndexPath.row]
            var weekday = Calendar.current.component(.weekday, from: dayForecast.date)
            cell.dayOfWeekLabel.text = weekday.getWeekDay()

            cell.dayWeatherConditionImageView.image = UIImage(named: "no-image")
            dependencies.imageService.fatchImage(imageName: dayForecast.dayData.imageName, success: { image in
                cell.dayWeatherConditionImageView.image = image
            })
            cell.dayDescriptionTextView.text = """
            temperature: \(dayForecast.dayData.temp)\u{00B0}
            presure: \(dayForecast.dayData.pressure) mm Hg
            humidity: \(dayForecast.dayData.humidity)%
            wind: \(dayForecast.dayData.windSpeed) m/s
            wind direction \(dayForecast.dayData.direction)
            cloudiness: \(dayForecast.dayData.cloudiness)%
            \(dayForecast.dayData.description)
            """
            if let rainVolume = dayForecast.dayData.rainVolume {
                cell.dayDescriptionTextView.text.append("\nrain volume: \(rainVolume) mm")
            }
            if let snowVolume = dayForecast.dayData.snowVolume {
                cell.dayDescriptionTextView.text.append("\nsnow volume: \(snowVolume) mm")
            }

            cell.nightWeatherConditionImageView.image = UIImage(named: "no-image")
            dependencies.imageService.fatchImage(imageName: dayForecast.nightData.imageName, success: { image in
                cell.nightWeatherConditionImageView.image = image
            })
            cell.nightDescriptionTextView.text = """
            temperature: \(dayForecast.nightData.temp)\u{00B0}
            presure: \(dayForecast.nightData.pressure) mm Hg
            humidity: \(dayForecast.nightData.humidity)%
            wind: \(dayForecast.nightData.windSpeed) m/s
            wind direction \(dayForecast.nightData.direction)
            cloudiness: \(dayForecast.nightData.cloudiness)%
            \(dayForecast.nightData.description)
            """
            if let rainVolume = dayForecast.nightData.rainVolume {
                cell.nightDescriptionTextView.text.append("\nrain volume: \(rainVolume) mm")
            }
            if let snowVolume = dayForecast.nightData.snowVolume {
                cell.nightDescriptionTextView.text.append("\nsnow volume: \(snowVolume) mm")
            }
        }
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mainCollectionView.bounds.width, height: mainCollectionView.bounds.height)
    }
    
}

extension WeatherViewController: WeatherViewControllerDelegate {

    func applicationWillEnterForeground() {
        fetchData()
    }
}

extension WeatherViewController: SelectCellDelegate {

    func internalCollectionView(didSelectItemAt currentSelectedInternalIndexPath: IndexPath,
                                previousSelectedInternalIndexPath: IndexPath?,
                                currentDataIsVisible: Bool) {
        currentSelectedIndexPathInternalCollectionView = currentSelectedInternalIndexPath
        previousSelectedIndexPathInternalCollectionView = previousSelectedInternalIndexPath
        self.currentDataIsVisible = currentDataIsVisible
        mainCollectionView.reloadData()
    }
}
