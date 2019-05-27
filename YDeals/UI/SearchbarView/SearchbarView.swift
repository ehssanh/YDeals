//
//  SearchbarView.swift
//  YDeals
//
//  Created by Ehssan on 2019-05-21.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit

protocol SearchbarViewDelegate : NSObject  {
    func searchTermDidChange(term:String?) -> Void
    func onActionButtonClicked() -> Void
}

@IBDesignable class SearchbarView: UIView, UITextFieldDelegate {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var searchField: UITextField!
    
    weak var delegate : SearchbarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.commonInit();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.commonInit();
    }
    
    private func commonInit(){
        let nib = UINib(nibName: "SearchbarView", bundle: Bundle.main);
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        // use bounds not frame or it'll be offset
        view.backgroundColor = APP_BACKGROUND_COLOR;
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
        self.prepareForInterfaceBuilder();
        
        self.searchField.delegate = self;
        self.button.addTarget(self, action: #selector(onButtonClicked), for: UIControl.Event.touchUpInside);
        
        self.searchField.addTarget(self, action: #selector(textFieldEditingDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldEditingDidChange() -> Void {
        let searchterm = searchField.text
        self.delegate?.searchTermDidChange(term: searchterm);
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return false;
    }
    
    func hideKeyboard() -> Void{
        self.searchField.endEditing(true);
    }
    
    @objc func onButtonClicked() -> Void {
        self.hideKeyboard();
        self.delegate?.onActionButtonClicked();
    }

}
