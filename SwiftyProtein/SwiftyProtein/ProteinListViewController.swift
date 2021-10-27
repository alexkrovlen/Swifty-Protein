//
//  ProteinListViewController.swift
//  SwiftyProtein
//
//  Created by Flash Jessi on 10/21/21.
//  Copyright © 2021 Svetlana Frolova. All rights reserved.
//

import UIKit

class ProteinListViewController: UIViewController {

    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var proteins: [String] = {
        let protein = "ligands.txt".readFile().split(separator: "\n").map { String($0) }
        return protein
    }()
    var filterProteins = [String]()
    var protein: String?
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor(red: 62 / 255, green: 99 / 255, blue: 246 / 255, alpha: 0.5).cgColor,
            UIColor(red: 167 / 255, green: 55 / 255, blue: 246 / 255, alpha: 0.5).cgColor
        ]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.1)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.cornerRadius = 12
        return gradient
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gradient.frame = view.bounds
        self.view.layer.insertSublayer(gradient, at: 0)
        myTable.backgroundColor = .clear
        
//        searchBar.delegate = self
        filterProteins = proteins
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

}

extension ProteinListViewController: UITableViewDelegate {
    
}

extension ProteinListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterProteins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = .clear
        cell.textLabel?.text = filterProteins[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        protein = filterProteins[indexPath.row]
        getProteinInformation(protein: protein!)
    }
    
    func getProteinInformation(protein: String) {
        activityIndicator.startAnimating()
        self.performSegue(withIdentifier: "protein", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ProteinViewController else { return }
        vc.protein = protein
    }
    
}

extension ProteinListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterProteins = []
        
        if searchText == "" {
            filterProteins = proteins
        } else {
            for protein in proteins {
                if protein.uppercased().contains(searchText.uppercased()) {
                    filterProteins.append(protein)
                }
            }
        }
        self.myTable.reloadData()
    }
}
