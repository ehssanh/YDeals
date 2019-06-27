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
    let serverAPI = ServerAPI();

    override func viewDidLoad() {
        super.viewDidLoad();
        self.view.backgroundColor = APP_BACKGROUND_COLOR;
        
        setupActivityIndicator();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showNavBar(false);
    }
    
    func showNavBar(_ show:Bool,withTitle title:String? = nil) -> Void{
        self.navigationController?.navigationBar.isHidden = !show;
       
        if (show){
            self.navigationController?.navigationBar.barTintColor = APP_BACKGROUND_COLOR;
            self.navigationController?.navigationBar.tintColor = .white;

            if (title != nil){
                self.navigationController?.navigationBar.isHidden = false;
                let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 32))
                titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
                titleLabel.textColor = .white
                titleLabel.text = title
                titleLabel.textAlignment = .center
                self.navigationItem.titleView = titleLabel;
            }
        }
    }
    
    func navigateTo<V>(xibName:String, clazzType:V.Type, initBlock:((_ viewController:V)->Void)?) -> V where V:UIViewController{
        let VC = V(nibName: xibName, bundle:nil);
        self.navigationController?.pushViewController(VC, animated: true);
        
        if (initBlock != nil){
            initBlock!(VC);
        }

        return VC;
    }
    
    func showUIBusy(){
        DispatchQueue.main.async {
            self.activityIndicator.show();
        }
    }
    
    func hideUIBusy(){
        DispatchQueue.main.async {
            self.activityIndicator.hide();
        }
    }
    
    func refreshViewController() -> Void{
        
    }
    
    private func setupActivityIndicator(){
        self.activityIndicator = CustomActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 140, height: 100))
        self.activityIndicator.center = UIApplication.shared.windows.first?.center ?? self.view.center;
        self.view.addSubview(self.activityIndicator);
        hideUIBusy();
    }
}

class BaseInfiniteViewController : BaseViewController{
    func loadMore(){}
}
