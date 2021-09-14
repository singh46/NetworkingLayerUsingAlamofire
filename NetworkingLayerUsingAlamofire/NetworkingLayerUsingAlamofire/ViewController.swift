//
//  ViewController.swift
//  NetworkingLayerUsingAlamofire
//
//  Created by VK
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageTitle: UILabel!

    private var countries : [Country]?
    private let countryEndPoint = CountryEndPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        pageTitle.text = "County"
    }
    
    //MARK: - Button Actions
    @IBAction func getAllCountriesAction(_ sender: Any) {
        
        pageTitle.text = "Loading....."
        
        countryEndPoint.getAllCountries {[weak self] countries, networkError in
            if let countries = countries {
                self?.countries = countries
            }else if let error = networkError {
                print("error : \(error.localizedDescription)")
            }
            self?.tableView.reloadData()
            self?.pageTitle.text = "County Count (\(self?.countries?.count ?? 0))"
        }
    }
    
    
    @IBAction func getTenRandomCountriesAction(_ sender: Any) {
        
        pageTitle.text = "Loading....."

        countryEndPoint.getTenRandomCountries {[weak self] countries, networkError in
            if let countries = countries {
                self?.countries = countries
            }else if let error = networkError {
                print("error : \(error.localizedDescription)")
            }
            self?.tableView.reloadData()
            self?.pageTitle.text = "County Count (\(self?.countries?.count ?? 0))"
        }
    }
    
    
    @IBAction func getRandomCountriesInSortedOrderAction(_ sender: Any) {
        
        pageTitle.text = "Loading....."

        let randomCount = Int.random(in: 5..<30)
        
        countryEndPoint.getRandomCountriesInSortedOrder(count: randomCount){[weak self] countries, networkError in
            if let countries = countries {
                self?.countries = countries
            }else if let error = networkError {
                print("error : \(error.localizedDescription)")
            }
            self?.tableView.reloadData()
            self?.pageTitle.text = "County Count (\(self?.countries?.count ?? 0))"
        }
    }
    
}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = countries?[indexPath.row]
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "Identifier")
        cell.textLabel?.text = country?.name
        cell.detailTextLabel?.text = country?.dial_code
        
        return cell
    }
    
}
