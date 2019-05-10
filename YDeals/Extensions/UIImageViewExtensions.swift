//
//  UIImageViewExtensions.swift
//  YDeals
//
//  Created by Ehssan on 2019-04-13.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    func lazyLoadFromUrl(url:String?) -> Void{
        self.image = UIImage(named: "entry_placeholder");
        
        guard let url = url else {
            return;
        }
        
        let imageUrl = URL(string: url)!
        
        URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
            
            if let err = error{
                print("Download error " + err.localizedDescription);
                return;
            }
            
            guard let data = data else{
                print("No Data ")
                return;
            }
            
            DispatchQueue.main.async {
                UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.image = UIImage(data: data);
                }, completion: { (success) in
                    // noop
                })
                
            }
        }).resume();
    }
}

