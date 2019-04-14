//
//  CustomActivityIndicatorView.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-14.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit

@IBDesignable class CustomActivityIndicatorView: UIView {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        commonInit()
    }
    
    func commonInit(){
        let nib = UINib(nibName: "CustomActivityIndicatorView", bundle: Bundle.main);
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.indicator.stopAnimating();
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        self.prepareForInterfaceBuilder();
    }
    
    func show(_ newTitle:String? = nil){
        if let title = newTitle{
            self.title.text = title;
        }
        
        indicator.startAnimating();
        self.isHidden = false;
    }
    
    func hide(){
        indicator.stopAnimating();
        self.isHidden = true;
    }

}
