//
//  LogoView.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-13.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit

class LogoView: UIView {

    @IBOutlet weak var codeLetter1: UILabel!
    @IBOutlet weak var codeLetter2: UILabel!
    @IBOutlet weak var codeLetter3: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    var contentView:UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        commonInit()
    }
    
    func commonInit(){
        let nib = UINib(nibName: "LogoView", bundle: Bundle.main);
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        self.contentView = view;
        self.contentView?.prepareForInterfaceBuilder();
    }
    
    func setAirportCode(airportCode : String, subtitleText:String? = nil){
        if (airportCode.count == 3){
            codeLetter1.text = String(airportCode[0]);
            codeLetter2.text = String(airportCode[1]);
            codeLetter3.text = String(airportCode[2]);
        }
        
        if let sub = subtitleText{
            self.subtitle.text = sub;
        }
    }


}
