//
//  HudView.swift
//  MyLocations
//
//  Created by Olexsii Levchenko on 8/5/22.
//

import UIKit


class HudView: UIView {
    var text = ""
    
    class func hub(inView view: UIView, animated: Bool) -> HudView {
        let hubView = HudView(frame: view.bounds)
        hubView.isOpaque = false
        
        view.addSubview(hubView)
        view.isUserInteractionEnabled = false
                
        return hubView
    }
    
    
    override func draw(_ rect: CGRect) {
        let boxWidth: CGFloat = 96
        let boxHeight: CGFloat = 96
        
        let boxRect = CGRect(
            x: round(bounds.size.width - boxWidth) / 2,
            y: round(bounds.size.height - boxHeight) / 2,
            width: boxWidth, height: boxHeight)
        
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        UIColor(white: 0.3, alpha: 0.8).setFill()
        roundedRect.fill()
        
        if let image = UIImage(named: "Checkmark") {
            let imagePoint = CGPoint(
                x: center.x - round(image.size.width / 2),
                y: center.y - round(image.size.height / 2) - boxHeight / 8)
            
            image.draw(at: imagePoint)
        }
        
        // Draw the text
        let attribs = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        let textSize = text.size(withAttributes: attribs)
        
        let textPoint = CGPoint(
            x: center.x - round(textSize.width / 2),
            y: center.y - round(textSize.height / 2) + boxWidth / 4)
        
        text.draw(at: textPoint, withAttributes: attribs)
    }
}
