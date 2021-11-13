//
//  ProteinListViewController.swift
//  SwiftyProtein
//
//  Created by Flash Jessi on 10/21/21.
//  Copyright © 2021 Svetlana Frolova. All rights reserved.
//

import UIKit
import SceneKit

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
    var atomsStruct: [Atom] = []
    var coordinates = [[(x: Float, y: Float, z: Float)]]()
    var allAtoms: [SCNNode] = []
    
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
        filterProteins = proteins
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 207 / 255, green: 198 / 255, blue: 248 / 255, alpha: 1)
    }

    @IBAction func randomProtein(_ sender: Any) {
        protein = filterProteins.randomElement()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        ProteinRequest.shared.getProtein(protein: protein) { [weak self] atoms in
            DispatchQueue.main.async {
                switch atoms {
                case .success(let atoms):
                    self?.atomsStruct = atoms.atoms
                    self?.coordinates = atoms.coordinates
                    self?.makeAtoms()
                    self?.performSegue(withIdentifier: "protein", sender: self)
                    self?.activityIndicator.isHidden = true
                    self?.activityIndicator.stopAnimating()
                case .failure:
                    self?.atomsStruct = []
                    print("error")
                    self?.activityIndicator.isHidden = true
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }
}

extension ProteinListViewController: UITableViewDataSource, UITableViewDelegate {
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
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        ProteinRequest.shared.getProtein(protein: protein) { [weak self] atoms in
            DispatchQueue.main.async {
                switch atoms {
                case .success(let atoms):
                    self?.atomsStruct = atoms.atoms
                    self?.coordinates = atoms.coordinates
                    self?.makeAtoms()
                    self?.performSegue(withIdentifier: "protein", sender: self)
                    self?.activityIndicator.isHidden = true
                    self?.activityIndicator.stopAnimating()
                case .failure:
                    self?.atomsStruct = []
                    print("error")
                    self?.activityIndicator.isHidden = true
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }
    

    
    private func makeAtoms() {
        for atom in atomsStruct {
            let Atom = SCNSphere(radius: 0.3)
            Atom.firstMaterial!.diffuse.contents = atom.color
            Atom.firstMaterial!.specular.contents = UIColor.white
            
            let atomScene = SCNNode(geometry: Atom)
            atomScene.position = SCNVector3Make(atom.x, atom.y, atom.z)
            atomScene.name = atom.name
            
            allAtoms.append(atomScene)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ProteinViewController else { return }
        vc.title = protein
        let scene = SCNScene()
        var alreadyUsedAtoms = [(x: Float, y: Float, z: Float)]()
        
        scene.rootNode.addChildNode(SCNNode())
        for node in allAtoms {
            scene.rootNode.addChildNode(node)
        }
        for atom in coordinates {
            let from = atom[0]
            alreadyUsedAtoms.append(from)
            for cord in 1..<atom.count {
                if !checkIfAlreadyUsed(atomsArray: alreadyUsedAtoms, toSearch: atom[cord]) {
                    let celinder = makeCylinder(positionStart: SCNVector3(from.x, from.y, from.z), positionEnd: SCNVector3([atom[cord].x, atom[cord].y, atom[cord].z]), radius: 0.1, color: UIColor.systemGray, transparency: 0.1)
                    scene.rootNode.addChildNode(celinder)
                }
            }
        }
        vc.scene = scene
        vc.allAtoms = atomsStruct
        allAtoms = []
        coordinates = []
    }
    
    func checkIfAlreadyUsed(atomsArray: [(x: Float, y: Float, z: Float)], toSearch: (x: Float, y: Float, z: Float)) -> Bool {
        let (x1, x2, x3) = toSearch
        for (v1, v2, v3) in atomsArray { if v1 == x1 && v2 == x2 && v3 == x3 { return true } }
        return false
    }
    
    func makeCylinder(positionStart: SCNVector3, positionEnd: SCNVector3, radius: CGFloat , color: UIColor, transparency: CGFloat) -> SCNNode
    {
        let height = CGFloat(GLKVector3Distance(SCNVector3ToGLKVector3(positionStart), SCNVector3ToGLKVector3(positionEnd)))
        let startNode = SCNNode()
        let endNode = SCNNode()
        
        startNode.position = positionStart
        endNode.position = positionEnd
        
        let zAxisNode = SCNNode()
        zAxisNode.eulerAngles.x = Float(CGFloat(Double.pi / 2))
        
        let cylinderGeometry = SCNCylinder(radius: radius, height: height)
        cylinderGeometry.firstMaterial?.diffuse.contents = color
        let cylinder = SCNNode(geometry: cylinderGeometry)
        
        cylinder.position.y = Float(-height/2)
        zAxisNode.addChildNode(cylinder)
        
        let returnNode = SCNNode()
        
        if (positionStart.x > 0.0 && positionStart.y < 0.0 && positionStart.z < 0.0 && positionEnd.x > 0.0 && positionEnd.y < 0.0 && positionEnd.z > 0.0){
            endNode.addChildNode(zAxisNode)
            endNode.constraints = [ SCNLookAtConstraint(target: startNode) ]
            returnNode.addChildNode(endNode)
        }
        else if (positionStart.x < 0.0 && positionStart.y < 0.0 && positionStart.z < 0.0 && positionEnd.x < 0.0 && positionEnd.y < 0.0 && positionEnd.z > 0.0){
            endNode.addChildNode(zAxisNode)
            endNode.constraints = [ SCNLookAtConstraint(target: startNode) ]
            returnNode.addChildNode(endNode)
        }
        else if (positionStart.x < 0.0 && positionStart.y > 0.0 && positionStart.z < 0.0 && positionEnd.x < 0.0 && positionEnd.y > 0.0 && positionEnd.z > 0.0){
            endNode.addChildNode(zAxisNode)
            endNode.constraints = [ SCNLookAtConstraint(target: startNode) ]
            returnNode.addChildNode(endNode)
        }
        else if (positionStart.x > 0.0 && positionStart.y > 0.0 && positionStart.z < 0.0 && positionEnd.x > 0.0 && positionEnd.y > 0.0 && positionEnd.z > 0.0){
            endNode.addChildNode(zAxisNode)
            endNode.constraints = [ SCNLookAtConstraint(target: startNode) ]
            returnNode.addChildNode(endNode)
        }
        else{
            startNode.addChildNode(zAxisNode)
            startNode.constraints = [ SCNLookAtConstraint(target: endNode) ]
            returnNode.addChildNode(startNode)
        }
    
        return returnNode
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
