//
//  ExtensionReadFile.swift
//  SwiftyProtein
//
//  Created by Flash Jessi on 10/27/21.
//  Copyright © 2021 Svetlana Frolova. All rights reserved.
//

import Foundation

extension String {
    
    func readFile() -> String {
        if let path = Bundle.main.path(forResource:self , ofType: nil) {
            do {
                let text = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
                return text
            } catch { print("Failed to read text from bundle file \(self)") }
        } else {
            print("Failed to load file from bundle \(self)")
        }
        return ""
    }
}
