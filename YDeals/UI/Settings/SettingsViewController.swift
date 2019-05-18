//
//  SettingsViewController.swift
//  YDeals
//
//  Created by Ehssan on 2019-05-13.
//  Copyright © 2019 SolidXpert. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let GENERAL_GROUP_INDEX = 0
    private let VERSION_GROUP_INDEX = 1
    
    private let groupNames = ["General","Version"];
    private let generalSettings = ["About", "Privacy Policy", "Change Airport"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white;

        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCellId")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.showNavBar(true, withTitle: "Settings");
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.groupNames.count;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case GENERAL_GROUP_INDEX:
                return self.generalSettings.count
            default:
                return 1;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCellId", for: indexPath)
        let text : String;
        
        switch indexPath.section {
            case GENERAL_GROUP_INDEX:
                text =  self.generalSettings[indexPath.row];
            case VERSION_GROUP_INDEX:
                text =  AppDelegate.appVersion();
            default:
                text = "-"
        }
        
        cell.textLabel?.text = text;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.groupNames[section];
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
            case GENERAL_GROUP_INDEX:
                do {
                    if ( indexPath.row == generalSettings.firstIndex(of: "About") ){
                        _ = self.navigateTo(xibName: "WebDetailViewController", clazzType: WebDetailViewController.self) { (vc) in
                            vc.loadPage(url:APP_ABOUT_URL , withtitle: "About")
                        }
                    }else if (indexPath.row == generalSettings.firstIndex(of: "Privacy Policy")){
                        _ = self.navigateTo(xibName: "WebDetailViewController", clazzType: WebDetailViewController.self) { (vc) in
                            vc.loadPage(url:APP_PRIVACY_POLICY_URL , withtitle: "About")
                        }
                    }else if (indexPath.row == generalSettings.firstIndex(of: "Change Airport")){
                        AppDelegate.onboardingController.navigateTo(elementType: PickAirportViewController.self);
                    }
                }
            default:
                return;
        }
    }
    
}
