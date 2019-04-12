//
//  Created by Александр on 6.02.2019
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

final class LocationsViewController: UIViewController {

    private var downloadedLocations: [LocationInformation] = []
    private var showedLocations: [LocationInformation] = []
    private var favouritesLocations: [LocationInformation]

    typealias Dependencies = HasLocationService
    private let dependencies: Dependencies

    private lazy var inputSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter the location name"
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        return searchBar
    }()

    private lazy var locationsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        indicator.color = .black
        return indicator
    }()

    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapRecognizer.isEnabled = false
        tapRecognizer.cancelsTouchesInView = false
        return tapRecognizer
    }()

    // MARK: - Life cycle

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        favouritesLocations = dependencies.locationService.getFavouritesLocations()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        view.addSubview(inputSearchBar)
        view.addSubview(locationsTableView)
        view.addSubview(activityIndicator)
        view.addGestureRecognizer(tapRecognizer)

        showedLocations = favouritesLocations

        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let width = view.bounds.width
        activityIndicator.frame = view.bounds
        inputSearchBar.frame = CGRect(x: 0, y: safeAreaInsets.top, width: width, height: 50)
        locationsTableView.frame = CGRect(x: 0, y: 50 + safeAreaInsets.top,
                                          width: width, height: view.bounds.height - 70)
    }

    // MARK: - Showing keyboard

    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        tapRecognizer.isEnabled = true
        let keyboardFrameEndUserInfoKey = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        if let keyboardFrame = keyboardFrameEndUserInfoKey?.cgRectValue {
            locationsTableView.contentInset.bottom = keyboardFrame.height
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        tapRecognizer.isEnabled = false
        locationsTableView.contentInset.bottom = 0
    }

    // MARK: - Logic

    private func fetchData() {
        activityIndicator.startAnimating()
        DispatchQueue.global().async {
            self.dependencies.locationService.fetchLocationsFromFile(success: { citiesInformations in
                self.downloadedLocations = citiesInformations
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if self.favouritesLocations.count == 0 {
                        self.presentAlert(message: "Please, add the desired location", handler: nil)
                    }
                }
            }, failure: { error in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                self.presentAlert(message: error.localizedDescription, handler: nil)
            })
        }
    }
}

extension LocationsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showedLocations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = locationsTableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self),
                                                          for: indexPath)
        cell.textLabel?.text = "\(showedLocations[indexPath.row].name) \(showedLocations[indexPath.row].country)"
        return cell
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let searchText = inputSearchBar.text,
            !searchText.isEmpty,
            searchText.isEmpty,
            searchText != " " else {
                return nil
        }
        if favouritesLocations.contains(showedLocations[indexPath.row]) {
            presentAlert(message: "Location alredy exists", handler: nil)
        } else {
            favouritesLocations.append(showedLocations[indexPath.row])
            dependencies.locationService.setFavouritesLocations(favouritesLocations: favouritesLocations)
            showedLocations = self.favouritesLocations
            inputSearchBar.text = nil
            locationsTableView.reloadData()
        }
        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { _, indexPath in
            self.favouritesLocations.remove(at: indexPath.row)
            self.showedLocations = self.favouritesLocations
            self.dependencies.locationService.setFavouritesLocations(favouritesLocations: self.favouritesLocations)
            self.locationsTableView.reloadData()
        }

        return [deleteAction]
    }
}

extension LocationsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text,
            !searchText.isEmpty,
            searchText.isEmpty,
            searchText != " " {
            showedLocations = downloadedLocations
                .filter { $0.name.lowercased().hasPrefix(searchText.lowercased()) }
                .sorted { $0.name < $1.name }
            locationsTableView.reloadData()
        } else {
            showedLocations = favouritesLocations
            locationsTableView.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return text.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil
    }
}
