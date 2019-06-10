//
//  TopAlignedLabel.swift
//  YDeals
//
//  Created by Ehssan on 2019-06-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//
import UIKit

class UITopAlignedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        guard let string = text else {
            super.drawText(in: rect)
            return
        }
        
        let size = (string as NSString).boundingRect(
            with: CGSize(width: rect.width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin],
            attributes: [.font: font!],
            context: nil).size
        
        var rect = rect
        rect.size.height = size.height.rounded()
        super.drawText(in: rect)
    }
}
