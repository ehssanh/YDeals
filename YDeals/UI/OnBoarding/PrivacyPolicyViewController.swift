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
    
    private var agreed : Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let consentAlreadyGiven = Persistence.load(key: PERSISTENCE_KEY_PRIVACY_CONSENT)
        if ( consentAlreadyGiven != nil && (consentAlreadyGiven as! Bool)==true ) {
            self.navigateToNext(withData: nil);
            return;
        }

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
        let circleBox = Checkbox(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        circleBox.borderStyle = .circle
        circleBox.checkmarkStyle = .tick
        circleBox.borderWidth = 1
        circleBox.uncheckedBorderColor = .white
        circleBox.checkedBorderColor = .white
        circleBox.checkmarkSize = 0.8
        circleBox.checkmarkColor = .white
        circleBox.addTarget(self, action: #selector(circleBoxValueChanged(sender:)), for: .valueChanged)
        
        self.checkboxHolderView.addSubview(circleBox)
        circleBox.isHidden = false;
    }
    
    // target action example
    @objc func circleBoxValueChanged(sender: Checkbox) {
        self.agreed.toggle();
    }

    @objc func onLabelTapped(sender: UILabel){
        let privacyPolicyurl = URL(string: APP_PRIVACY_POLICY_URL);
        let svc = SFSafariViewController(url: privacyPolicyurl!)
        svc.modalPresentationStyle = .overFullScreen
        self.present(svc, animated: true, completion: nil)
    }
    
    @IBAction func onAgreeButtonClicked(_ sender: Any) {
        if ( agreed ){
            self.navigateToNext(withData: nil);
            Persistence.save(value: true, key: PERSISTENCE_KEY_PRIVACY_CONSENT);
        }else{
            Utilities.showAlert(title: "Please check the box.", message: "Sorry, but you must agree to the privacy policy and terms of use of this app before being able to use it.", parent: self);
        }
    }
}
