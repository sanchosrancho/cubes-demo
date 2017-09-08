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
        return UIColor.fromRGB(r: r, g: g, b: b)
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
    
    class func fromRGB(r: Int, g: Int, b: Int, a: CGFloat? = nil) -> UIColor {
        let alpha = a ?? 1
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: alpha)
    }
    
    
    class func fromHex(_ hexString: String) -> UIColor {
        let r, g, b, a: CGFloat
        var str = hexString
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            str = String(hexString[start..<hexString.endIndex])
        }
        
        guard str.characters.count == 8 else { return UIColor.clear }
        let scanner = Scanner(string: str)
        var hexNumber: UInt64 = 0
        
        guard scanner.scanHexInt64(&hexNumber) else { return UIColor.clear }
        r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
        g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
        b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
        a = CGFloat(hexNumber & 0x000000ff) / 255
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    
    func hexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(format: "#%02X%02X%02X%02X", Int(r * 0xff), Int(g * 0xff), Int(b * 0xff), Int(a * 0xff)).lowercased()
    }
}
