//
//  Colors.swift
//  Cubes Demo
//
//  Created by Олег Адамов on 06.09.17.
//  Copyright © 2017 AdamovOleg. All rights reserved.
//

import UIKit

struct Color: Codable {
    let id: Int
    let r: Int
    let g: Int
    let b: Int
    
    var uiColor: UIColor {
        return UIColor.clear
    }
}

struct Colors {
    let all: [Color]
    
    init() {
        let path = Bundle.main.path(forResource: "colors", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let decoder = JSONDecoder()
        self.all = try! decoder.decode([Color].self, from: data)
    }
}
