//
//  PrivacyPolicyViewController.swift
//  YDeals
//
//  Created by Ehssan on 2019-06-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit
import SafariServices

class PrivacyPolicyViewController: OnboardingSequenceElement {
    @IBOutlet weak var checkboxText: UILabel!
    @IBOutlet weak var checkboxHolderView: UIView!
    
    private var circleBox : Checkbox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let consentAlreadyGiven = Persistence.load(key: PERSISTENCE_KEY_PRIVACY_CONSENT)
//        if ( consentAlreadyGiven != nil && (consentAlreadyGiven as! Bool)==true ) {
//            self.navigateToNext(withData: nil);
//            return;
//        }

        setupLabelTextBesideCheckbox();
        setupCheckBox();
    }
    
    private func setupLabelTextBesideCheckbox(){
        let attributedText = NSMutableAttributedString(string: "By using this app you are agreeing to our  ");
        let underlinedAttribute = [ NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributedPrivacyPolicy = NSMutableAttributedString(string: "Privacy Policy. ", attributes: underlinedAttribute);
        
        attributedText.append(attributedPrivacyPolicy);
        attributedText.append(NSAttributedString(string: "Please click here to see the details of the policy on our website."))
        
        self.checkboxText.attributedText = attributedText;
        self.checkboxText.sizeThatFits(CGSize.zero);
        
        addUrlNavigationToLabelText();
    }
    
    private func addUrlNavigationToLabelText(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onLabelTapped(sender:)));
        self.checkboxText.isUserInteractionEnabled = true;
        self.checkboxText.addGestureRecognizer(tap)
    }
    
    private func setupCheckBox(){
        self.circleBox = Checkbox(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        self.circleBox.borderStyle = .circle
        self.circleBox.checkmarkStyle = .tick
        self.circleBox.borderWidth = 1
        self.circleBox.uncheckedBorderColor = .white
        self.circleBox.checkedBorderColor = .white
        self.circleBox.checkmarkSize = 0.8
        self.circleBox.checkmarkColor = .white
        self.circleBox.addTarget(self, action: #selector(circleBoxValueChanged(sender:)), for: .valueChanged)
        
        self.checkboxHolderView.addSubview(circleBox)
        self.circleBox.isHidden = false;
        self.circleBox.isChecked = true;
    }
    
    // target action example
    @objc func circleBoxValueChanged(sender: Checkbox) {
        // Nothing
    }

    @objc func onLabelTapped(sender: UILabel){
        
        self.circleBox.isChecked.toggle();
        
        let privacyPolicyurl = URL(string: APP_PRIVACY_POLICY_URL);
        let svc = SFSafariViewController(url: privacyPolicyurl!)
        svc.modalPresentationStyle = .overFullScreen
        self.present(svc, animated: true, completion: nil)
    }
    
    @IBAction func onAgreeButtonClicked(_ sender: Any) {
        if ( self.circleBox.isChecked ){
            self.navigateToNext(withData: nil);
            Persistence.save(value: true, key: PERSISTENCE_KEY_PRIVACY_CONSENT);
        }else{
            Utilities.showAlert(title: "Please check the box.", message: "Sorry, but you must agree to the privacy policy and terms of use of this app before being able to use it.", parent: self);
        }
    }
}
