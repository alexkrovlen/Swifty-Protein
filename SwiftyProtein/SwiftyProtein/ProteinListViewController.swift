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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = .clear
        cell.textLabel?.text = "fhg"
        
        return cell
    }
    
    
}
