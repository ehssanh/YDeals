//
//  OnboardingViewController.swift
//  YDeals
//
//  Created by msndev on 2019-05-09.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit


class OnboardingController {
    
    private var onboardingSequence : [OnboardingSequenceElement.Type] = [PrivacyPolicyViewController.self, AllowPushViewController.self, PickAirportViewController.self]
    
    private var currentSequeceElementObject : OnboardingSequenceElement?
    private var sequenceElementObjects = [OnboardingSequenceElement]()
    
    private var onboardingCompletionBlock : (() -> Void)?
    
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
        
        //Reset everything back when navigated
        self.sequenceElementObjects.removeAll();
    }
    
    func isOnboardingComplete() -> Bool{
        return (Persistence.load(key: PERSISTENCE_KEY_ONBOARDING_DONE) as? Bool == true)
    }
    
    func setOnboardingSequence( newSequence : [OnboardingSequenceElement.Type]){
        self.onboardingSequence.removeAll();
        self.onboardingSequence.append(contentsOf: newSequence);
    }
    
    func updateMode() -> Void {
        Persistence.save(value: false, key: PERSISTENCE_KEY_ONBOARDING_DONE);
    }
    

    func iterateOnboardingSequence() -> Void{
        
        if (self.currentSequeceElementObject == nil){
            let T = onboardingSequence.first!;
            let initialOnBoardingVC = T.init(nibName: String(describing: T), bundle: Bundle.main, controller: self);
            self.sequenceElementObjects.append(initialOnBoardingVC);
            self.currentSequeceElementObject = initialOnBoardingVC;
            let nav = (UIApplication.shared.delegate as! AppDelegate).setupNavigationController(initialOnBoardingVC);
            UIApplication.shared.windows.first?.rootViewController = nav;
        }else{
            
            let currentItemIndex = self.onboardingSequence.firstIndex { (item) -> Bool in
                return type(of: self.currentSequeceElementObject!) == item.self
            }
            
            if (currentItemIndex == self.onboardingSequence.count - 1){
                print ("last index");
                if (self.onboardingCompletionBlock != nil){
                    self.onboardingCompletionBlock!();
                }else{
                    let mainVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController();
                    self.currentSequeceElementObject?.navigationController?.pushViewController(mainVC!, animated: true)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let nav = appDelegate.setupNavigationController(mainVC!)
                    UIApplication.shared.windows.first?.rootViewController = nav;
                }
                
                self.onboardingComplete_Persist();
                return;
            }
            
            let N = self.onboardingSequence[currentItemIndex! + 1]
            let existingOnboardingElement = self.sequenceElementObjects.first { (theElement) -> Bool in
                return type(of: theElement) == N
            }
            
            if (existingOnboardingElement != nil){
                //already exists, overwrite nav controller
                self.currentSequeceElementObject = existingOnboardingElement!;
                let nav = (UIApplication.shared.delegate as! AppDelegate).setupNavigationController(existingOnboardingElement!);
                UIApplication.shared.windows.first?.rootViewController = nav;
            }else{
                let nav = self.currentSequeceElementObject?.navigationController
                let vc = N.init(nibName: String(describing: N), bundle: Bundle.main, controller: self);

                if (nav == nil){
                    let nav = (UIApplication.shared.delegate as! AppDelegate).setupNavigationController(vc);
                    UIApplication.shared.windows.first?.rootViewController = nav;
                }
                self.currentSequeceElementObject = vc;
                self.sequenceElementObjects.append(vc);
                nav?.pushViewController(self.currentSequeceElementObject!, animated: true);
            }
        }
    }
    
    func navigateTo(elementType:OnboardingSequenceElement.Type) -> Void{
        //If onboarding is skipped, sequenceElementObjects is empty and we should use
        //onBoardingSequence instead.
        if (!self.onboardingSequence.contains(where: { (OnboardingElementype) -> Bool in
            return elementType == OnboardingElementype;
        }))
        {
            return;
        }
        
        //Onboarding was skipped in this launch
        if (self.sequenceElementObjects.isEmpty) {
            
            let onboardingElementType = self.onboardingSequence.first { (theElement) -> Bool in
                return theElement == elementType
            }
            
            if (onboardingElementType == self.onboardingSequence.first){
                self.currentSequeceElementObject = nil;
                iterateOnboardingSequence();
                
                return;
            }else {
                
                let elementTypeIndex = self.onboardingSequence.firstIndex(where: { (theElement) -> Bool in
                    return theElement == elementType;
                });
                
                
                let elementBeforeTypeIdx = self.onboardingSequence.index(before: elementTypeIndex!);
                let elementBeforeType = self.onboardingSequence[elementBeforeTypeIdx];
                let elementBefore = elementBeforeType.init(nibName: String(describing: elementBeforeType), bundle: Bundle.main, controller: self);
                self.currentSequeceElementObject = elementBefore;
                iterateOnboardingSequence();

                return;
            }
        }
        
        
        
        // If sequence has run, sequenceElements is not empty :
        let onboardingElement = self.sequenceElementObjects.first { (theElement) -> Bool in
            return type(of: theElement) == elementType
        }
        
        
        guard let foundElement = onboardingElement else {
            iterateOnboardingSequence()
            return;
        }
        
        if foundElement == sequenceElementObjects.first {
            self.currentSequeceElementObject = nil
        }else{
            let theIndex = self.sequenceElementObjects.firstIndex(of: foundElement)
            self.currentSequeceElementObject = self.sequenceElementObjects[theIndex! - 1]
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

