//
//  PreviewViewController.swift
//  WidgetAnd3DTouch
//
//  Created by pangshishan on 2018/1/24.
//  Copyright © 2018年 pangshishan. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    var string: String?
    var jumpIntoBlock: ((_ previewVC: PreviewViewController)->())?
    var deleteBlock: ((_ str: String?)->())?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.lightGray;
        let label = UILabel()
        view.addSubview(label)
        label.text = string
        label.sizeToFit()
        label.center = view.center
        
    }
    
    override var previewActionItems: [UIPreviewActionItem] {
        
        let previewAction_0 = UIPreviewAction.init(title: "跳进去", style: .default) { (action, previewVC) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                if let block = self.jumpIntoBlock {
                    block(self)
                }
            })
        }
        let previewAction_1 = UIPreviewAction.init(title: "删除", style: .destructive) { (action, previewVC) in
            if let deleteBlock = self.deleteBlock {
                deleteBlock(self.string)
            }
        }
        let previewAction_2 = UIPreviewAction.init(title: "取消", style: .default) { (action, previewVC) in
            print("取消了")
        }
        let arrItem = [previewAction_0, previewAction_1, previewAction_2]
        return arrItem;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let naviVC = self.navigationController {
            naviVC.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    deinit {
        print("PreviewVC - deinit")
    }
    
}
