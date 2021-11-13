//
//  ProteinViewController.swift
//  SwiftyProtein
//
//  Created by Flash Jessi on 10/19/21.
//  Copyright © 2021 Svetlana Frolova. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class ProteinViewController: UIViewController {

    @IBOutlet var sceneView: SCNView!
    @IBOutlet weak var textAtom: UITextView!
    @IBOutlet weak var atomButton: UIButton!
    var allAtoms: [Atom] = []
    var scene = SCNScene()
    var periodTable: [PeriodTable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundSetting()
        initScene()
        getInformationAboutAtoms()
    }
    
    private func getInformationAboutAtoms() {
        PeriodicTableRequest.shared.getInformation { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let atoms):
                    self?.periodTable = atoms
                case .failure:
                    print("error get information about atoms in period table")
                }
            }
        }
    }
    
    private func backgroundSetting() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 42 / 255, green: 98 / 255, blue: 255 / 255, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        textAtom.backgroundColor = UIColor(white: 1, alpha: 0.3)
        textAtom.isHidden = true
        textAtom.isEditable = false
        atomButton.layer.cornerRadius = 10
        atomButton.isHidden = true
        atomButton.backgroundColor = .clear
    }
    
    private func initScene() {
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: -5, z: 38)
        
        // set the scene to the view
        sceneView.scene = scene
        
        // allows the user to manipulate the camera
        sceneView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // configure the view
        sceneView.backgroundColor = UIColor(red: 207 / 255, green: 198 / 255, blue: 248 / 255, alpha: 1)
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
//        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: sceneView)
        let hitResults = sceneView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            let currentPosition = hitResults[0].node.position
            let currentAtom = allAtoms.filter{ $0.x == currentPosition.x && $0.y == currentPosition.y && $0.z == currentPosition.z}
            let nameAtom = currentAtom.first?.name.capitalized
            if let nameAtom = nameAtom {
                let tableInfo = periodTable.filter{ $0.symbol == nameAtom}.first
                if let tableInfo = tableInfo {
                    textAtom.isHidden = false
                    let density = tableInfo.density == nil ? "-" : "\(tableInfo.density!)"
                    let melt = tableInfo.melt == nil ? "-" : "\(tableInfo.melt!)°C"
                    let boil = tableInfo.boil == nil ? "-" : "\(tableInfo.boil!)°C"
                    textAtom.text = """
                    Name: \(tableInfo.name)
                    Atomic mass: \(tableInfo.atomicMass)
                    Density: \(density)
                    Melt: \(melt)
                    Boil: \(boil)
                    Description: \(tableInfo.desc)
                    """
                    atomButton.isHidden = false
                    atomButton.setTitle("\(tableInfo.symbol)", for: .normal)
                }
            } else {
                textAtom.isHidden = true
                atomButton.isHidden = true
            }
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        } else {
            textAtom.isHidden = true
            atomButton.isHidden = true
        }
            
        
    }
    
    let arrayOfSomething = [#imageLiteral(resourceName: "1024"), #imageLiteral(resourceName: "touch_id")]
    
    @IBAction func sharedImage(_ sender: UIBarButtonItem) {
        let bounds = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        navigationController?.navigationBar.isHidden = false
       
        let shareController = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        
        shareController.completionWithItemsHandler = {_, bool, _, _ in
            if bool {
                print("Image save")
            }
        }
        
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        
        present(shareController, animated: true, completion: nil)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
