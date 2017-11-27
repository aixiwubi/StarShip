//
//  StatusBar.swift
//  StarShip
//
//  Created by Wendong Yang on 11/22/17.
//  Copyright © 2017 Wendong Yang. All rights reserved.
//

import UIKit

class StatusBar: UIView{
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    var percentage: Float?{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    private func setUp(){
        percentage = 1.0
    }
    override func draw(_ rect: CGRect) {
        if let percentage = percentage{
            let leftRect = CGRect(
                x:rect.origin.x,
                y:rect.origin.y,
                width:rect.size.width*CGFloat(percentage),
                height:rect.size.height
            )
            let rightRect = CGRect(
                x:rect.origin.x + (rect.size.width * CGFloat(percentage)),
                y:rect.origin.y,
                width:rect.size.width * (1-CGFloat(percentage)),
                height:rect.size.height
            )
            
            UIColor.green.set()
            UIRectFill(leftRect)
            UIColor.red.set()
            UIRectFill(rightRect)
        }
    }

}
