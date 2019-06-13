//
//  OnboardingViewController.swift
//  YDeals
//
//  Created by msndev on 2019-05-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit


class OnboardingController {
    
    let onboardingSequence : [OnboardingSequenceElement.Type] = [PrivacyPolicyViewController.self, AllowPushViewController.self, PickAirportViewController.self]
    
    var currentSequeceElement : OnboardingSequenceElement?
    var sequenceElements = [OnboardingSequenceElement]()
    
    var onboardingCompletionBlock : (() -> Void)?
    
    public func startOnboarding(whenFinished completion:@escaping (() -> Void)) -> Void{
        if !isOnboardingComplete() {
            self.onboardingCompletionBlock = completion
            self.iterateOnboardingSequence()
        }else{
            completion();
        }
    }
    
    private func onboardingComplete_Persist(){
        Persistence.save(value: true, key: PERSISTENCE_KEY_ONBOARDING_DONE);
    }
    
    func isOnboardingComplete() -> Bool{
        return (Persistence.load(key: PERSISTENCE_KEY_ONBOARDING_DONE) != nil)
    }
    
    func iterateOnboardingSequence() -> Void{
        
        if (self.currentSequeceElement == nil){
            
            let T = onboardingSequence.first!;
            let initialOnBoardingVC = T.init(nibName: String(describing: T), bundle: Bundle.main, controller: self);
            self.sequenceElements.append(initialOnBoardingVC);
            self.currentSequeceElement = initialOnBoardingVC;
            let nav = (UIApplication.shared.delegate as! AppDelegate).setupNavigationController(initialOnBoardingVC);
            UIApplication.shared.windows.first?.rootViewController = nav;
        }else{
            
            let currentItemIndex = self.onboardingSequence.firstIndex { (item) -> Bool in
                return type(of: self.currentSequeceElement!) == item.self
            }
            
            if (currentItemIndex == self.onboardingSequence.count - 1){
                print ("last index");
                if (self.onboardingCompletionBlock != nil){
                    self.onboardingCompletionBlock!();
                }else{
                    let mainVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController();
                    self.currentSequeceElement?.navigationController?.pushViewController(mainVC!, animated: true)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let nav = appDelegate.setupNavigationController(mainVC!)
                    UIApplication.shared.windows.first?.rootViewController = nav;
                }
                
                self.onboardingComplete_Persist();
                return;
            }
            
            let N = self.onboardingSequence[currentItemIndex! + 1]
            let existingOnboardingElement = self.sequenceElements.first { (theElement) -> Bool in
                return type(of: theElement) == N
            }
            
            if (existingOnboardingElement != nil){
                //already exists, overwrite nav controller
                self.currentSequeceElement = existingOnboardingElement!;
                let nav = (UIApplication.shared.delegate as! AppDelegate).setupNavigationController(existingOnboardingElement!);
                UIApplication.shared.windows.first?.rootViewController = nav;
            }else{
                let nav = self.currentSequeceElement?.navigationController
                let vc = N.init(nibName: String(describing: N), bundle: Bundle.main, controller: self);
                self.currentSequeceElement = vc;
                self.sequenceElements.append(vc);
                nav?.pushViewController(self.currentSequeceElement!, animated: true);
            }
        }
    }
    
    func navigateTo(elementType:OnboardingSequenceElement.Type) -> Void{
        //If onboarding is skipped,sequenceElements is empty and we should use
        //onBoardingSequence instead.
        if (self.onboardingSequence.contains(where: { (OnboardingElementype) -> Bool in
            return elementType == OnboardingElementype;
        })){

            let newElement = elementType.init(nibName: String(describing: elementType), bundle: Bundle.main, controller: self);
            self.sequenceElements.append(newElement);
            self.currentSequeceElement = newElement;
        }else{
            // Type is not even included in OnBOARDING
            return;
        }
        
        // If sequence has run, sequenceElements is not empty :
        let onboardingElement = self.sequenceElements.first { (theElement) -> Bool in
            return type(of: theElement) == elementType
        }
        
        guard let foundElement = onboardingElement else {
            iterateOnboardingSequence()
            return;
        }
        
        if foundElement == sequenceElements.first {
            self.currentSequeceElement = nil
        }else{
            let theIndex = self.sequenceElements.firstIndex(of: foundElement)
            self.currentSequeceElement = self.sequenceElements[theIndex! - 1]
        }
        
        iterateOnboardingSequence()
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
