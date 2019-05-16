//
//  LoginViewController.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-27.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit

class LoginViewController: OnboardingSequenceElement {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onSigninPressed(_ sender: Any) {
        self.navigateToNext(withData: nil);
    }
    
}
