//
//  ProteinRequest.swift
//  SwiftyProtein
//
//  Created by Flash Jessi on 10/27/21.
//  Copyright © 2021 Svetlana Frolova. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case noData
}

class ProteinRequest {
    static let shared = ProteinRequest()

       public func getProtein(protein: String?, completion: @escaping (Result<AtomPesponse, Error>) -> Void) {
           guard let protein = protein, let url = URL(string: "https://files.rcsb.org/ligands/view/\(protein)_ideal.pdb") else {
               print("Error: Wrong protein url.")
               completion(.failure(ApiError.noData))
               return
           }
           let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
               guard
                   error == nil,
                   (response as? HTTPURLResponse)?.statusCode == 200,
                   let data = data
                   else {
                       print("Error: Protein not found")
                       completion(.failure(ApiError.noData))
                       return
               }
            do {
                var atom: [Atom] = []
                var allCoordinates = [[(x: Float, y: Float, z: Float)]]()
                guard let decodeData = String(data: data, encoding: .utf8) else {
                    print("Error: Decoding fail")
                    completion(.failure(ApiError.noData))
                    return
                }
                let splitData = decodeData.split(separator: "\n")
                for line in splitData {
                    if line.contains("ATOM") {
                        let elem = line.components(separatedBy: " ").filter({!$0.isEmpty})
                        let newAtom = Atom(number: Int(elem[1])!, x: Float(elem[6])!, y: Float(elem[7])!, z: Float(elem[8])!, name: elem[11])
                        atom.append(newAtom)
                    } else if line.contains("CONECT") {
                        var coordinates:[(x: Float, y: Float, z: Float)] = []
                        let elem = line.components(separatedBy: " ").filter({!$0.isEmpty})
                        for i in 1...elem.count - 1{
                            let currConnect = atom[Int(elem[i])! - 1]
                            coordinates.append((x: currConnect.x, y: currConnect.y, z: currConnect.z))
                        }
                        allCoordinates.append(coordinates)
                    }
                }
                completion(.success(AtomPesponse(atoms: atom, coordinates: allCoordinates)))
            }
           }
           dataTask.resume()
       }
}
