//
//  BaseViewController.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-13.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    private var activityIndicator : CustomActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad();
        self.view.backgroundColor = UIColor(red256: 26, green: 166, blue: 237, alpha: 1);
        
        setupActivityIndicator();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true;
        
    }
    
    
    func navigateTo<V>(xibName:String, clazzType:V.Type, initBlock:(_ viewController:V)->Void) -> V where V:UIViewController {
        let VC = V(nibName: xibName, bundle:nil);
        self.navigationController?.pushViewController(VC, animated: true);
        initBlock(VC);

        return VC;
    }
    
    func showUIBusy(){
        self.activityIndicator.show();
    }
    
    func hideUIBusy(){
        self.activityIndicator.hide();
    }

    
    private func setupActivityIndicator(){
        self.activityIndicator = CustomActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 140, height: 100))
        self.activityIndicator.center = UIApplication.shared.windows.first?.center ?? self.view.center;
        self.view.addSubview(self.activityIndicator);
        hideUIBusy();
    }
}
