//
//  OnboardingViewController.swift
//  YDeals
//
//  Created by msndev on 2019-05-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit


class OnboardingController {
    
    let onboardingSequence : [OnboardingSequenceElement.Type] = [LoginViewController.self, PickAirportViewController.self]
    
    var currentSequeceElement : UIViewController?
    var onboardingCompletionBlock : (() -> Void)?
    
    public func startOnboarding(whenFinished completion:@escaping (() -> Void)) -> Void{
        if !isOnboardingComplete() {
            self.onboardingCompletionBlock = completion
            self.iterateOnboardingSequence()
        }else{
            completion();
        }
    }
    
    private func onboardingComplete(){
        Persistence.save(value: true, key: PERSISTENCE_KEY_ONBOARDING_DONE);
    }
    
    func isOnboardingComplete() -> Bool{
        return (Persistence.load(key: PERSISTENCE_KEY_ONBOARDING_DONE) != nil)
    }
    
    func iterateOnboardingSequence() -> Void{
        
        if (self.currentSequeceElement == nil){
            
            let T = onboardingSequence.first!;
            self.currentSequeceElement = T.init(nibName: String(describing: T), bundle: Bundle.main, controller: self);
            
            let nav = (UIApplication.shared.delegate as! AppDelegate).setupNavigationController(self.currentSequeceElement!);
            UIApplication.shared.windows.first?.rootViewController = nav;
        }else{
            
            let currentItemIndex = self.onboardingSequence.firstIndex { (item) -> Bool in
                return type(of: self.currentSequeceElement!) == item.self
            }
            
            if (currentItemIndex == self.onboardingSequence.count - 1){
                print ("last index");
                self.onboardingCompletionBlock!();
                return;
            }
            
            let N = self.onboardingSequence[currentItemIndex! + 1]
            let nav = self.currentSequeceElement?.navigationController
            self.currentSequeceElement = N.init(nibName: String(describing: N), bundle: Bundle.main, controller: self);
            nav?.pushViewController(self.currentSequeceElement!, animated: true);
            
        }
    }
}


class OnboardingSequenceElement : BaseViewController {
    
    private weak var onboardingController : OnboardingController?
    private var data : Any?
    
    required init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, controller: OnboardingController) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        self.onboardingController = controller;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func navigateToNext(withData data:Any?){
        self.data = data;
        self.onboardingController?.iterateOnboardingSequence();
    }
}
