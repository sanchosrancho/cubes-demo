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
        return UIColor.colorRGB(r, g, b)
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


extension UIColor {
    
    class func colorRGB(_ r: Int, _ g: Int, _ b: Int, alpha a: CGFloat? = nil) -> UIColor {
        let alpha = a ?? 1
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: alpha)
    }
}
