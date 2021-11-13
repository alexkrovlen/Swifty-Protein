//
//  PeriodicTableRequest.swift
//  SwiftyProtein
//
//  Created by Flash Jessi on 11/12/21.
//  Copyright © 2021 Svetlana Frolova. All rights reserved.
//

import Foundation

class PeriodicTableRequest {
    static let shared = PeriodicTableRequest()
    
    public func getInformation(completion: @escaping (Result<[PeriodTable], Error>)-> Void) {
        guard let path = Bundle.main.path(forResource: "dataTable", ofType: "json") else {
            print("Error: adress to json fail not correct")
            completion(.failure(ApiError.noData))
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let decoder = JSONDecoder()
            let response = try decoder.decode(PeriodTableResponse.self, from: data)
            completion(.success(response.elements))
        } catch {}
    }
}
