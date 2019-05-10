//
//  OnboardingViewController.swift
//  YDeals
//
//  Created by msndev on 2019-05-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    var pickAirportVC : PickAirportViewController!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickAirportVC = PickAirportViewController(nibName: "PickAirportViewController", bundle: Bundle.main);
        self.navigationController?.pushViewController(self.pickAirportVC, animated: false);
    }
    


}
