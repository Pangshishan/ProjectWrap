//
//  TodayViewController.swift
//  Widget-Today
//
//  Created by pangshishan on 2018/1/26.
//  Copyright © 2018年 pangshishan. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var label: UILabel?
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        self.preferredContentSize = CGSize.init(width: UIScreen.main.bounds.size.width, height: 100)
        
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 10, width: 300, height: 30))
        label.text = "Hello World!"
        // label.sizeToFit()
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.black
        // label.center = view.center;
        view.addSubview(label);
        self.label = label
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
    }
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
