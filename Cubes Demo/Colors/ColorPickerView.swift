//
//  ColorPickerView.swift
//  CubesDemo
//
//  Created by Олег Адамов on 08.09.17.
//  Copyright © 2017 AdamovOleg. All rights reserved.
//

import UIKit


protocol ColorPickerViewDelegate: class {
    func colorPickerView(_ colorPickerView: ColorPickerView, didSelect color: Color)
}


class ColorPickerView: UIView {
    
    weak var delegate: ColorPickerViewDelegate?
    
    
    deinit { print("deinit color picker") }
    
    init(inFrame: CGRect, colors: [Color]) {
        let width  = itemSize * 8
        let height = itemSize * 7
        
        let frame = CGRect(x: round((inFrame.width - width)/2), y: round((inFrame.height - height)/2), width: width, height: height)
        self.container = UIView(frame: frame)
        
        super.init(frame: CGRect(x: 0, y: 0, width: inFrame.width, height: inFrame.height))
        self.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.addSubview(self.container)
        
        for i in 0..<7 {
            for j in 0..<8 {
                let frame = CGRect(x: itemSize * CGFloat(j), y: itemSize * CGFloat(i), width: itemSize, height: itemSize)
                let index = i * 8 + j
                appendColorItem(frame: frame, color: colors[index])
            }
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(gesture)
    }

    
    //MARK: - Private
    
    private let itemSize: CGFloat = 40
    private var colorItemViews = [ColorItemView]()
    private let container: UIView
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func appendColorItem(frame: CGRect, color: Color) {
        let view = ColorItemView(frame: frame, color: color)
        self.container.addSubview(view)
        colorItemViews.append(view)
    }
    
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        
        if container.frame.contains(location) {
            let localPoint = convert(location, to: container)
            for itemView in self.colorItemViews {
                if itemView.frame.contains(localPoint) {
                    self.delegate?.colorPickerView(self, didSelect: itemView.color)
                    return
                }
            }
        }
        
        self.removeFromSuperview()
    }
}


fileprivate class ColorItemView: UIView {
    
    let color: Color
    
    init(frame: CGRect, color: Color) {
        self.color = color
        super.init(frame: frame)
        self.backgroundColor = color.uiColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
