//
//  SpalshScreenViewController.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-14.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit

class SpalshScreenViewController: UIViewController {

    let logo = LogoView(frame: CGRect(x: 0.0, y: 0.0, width: 200.0, height: 110.0));
    let onboarding = OnboardingController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red256: 26, green: 166, blue: 237, alpha: 1);
        
        self.logo.center = self.view.center;
        self.view.addSubview(self.logo);
        addHeartBeatAnimation(view: self.logo)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if (self.onboarding.isOnboardingComplete()){
                self.showMainView();
            }else{
                self.onboarding.startOnboarding {
                    self.showMainView();
                }
            }
        }
    }
    
    func showMainView() -> Void{
        let mainVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController();
        self.navigationController?.pushViewController(mainVC!, animated: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let nav = appDelegate.setupNavigationController(mainVC!)
        UIApplication.shared.windows.first?.rootViewController = nav;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.navigationBar.isHidden = true;
    }
    
    func addHeartBeatAnimation (view : UIView) {
        let beatLong: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        beatLong.fromValue = NSValue(cgSize: CGSize(width: 1, height: 1))
        beatLong.toValue = NSValue(cgSize: CGSize(width: 0.8, height: 0.8))
        beatLong.autoreverses = true
        beatLong.duration = 0.7
        beatLong.beginTime = 0.0
        
        let beatShort: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        beatShort.fromValue = NSValue(cgSize: CGSize(width: 1, height: 1))
        beatShort.toValue = NSValue(cgSize: CGSize(width: 0.8, height: 0.8))
        beatShort.autoreverses = true
        beatShort.duration = 0.6
        beatShort.beginTime = beatLong.duration
        beatLong.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn )
        
        let heartBeatAnim: CAAnimationGroup = CAAnimationGroup()
        heartBeatAnim.animations = [beatLong, beatShort]
        heartBeatAnim.duration = beatShort.beginTime + beatShort.duration
        heartBeatAnim.fillMode = CAMediaTimingFillMode.forwards
        heartBeatAnim.isRemovedOnCompletion = false
        heartBeatAnim.repeatCount = .greatestFiniteMagnitude
        view.layer.add(heartBeatAnim, forKey: nil)
    }

}
