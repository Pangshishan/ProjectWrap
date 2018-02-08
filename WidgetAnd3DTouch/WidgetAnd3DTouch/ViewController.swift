//
//  ViewController.swift
//  WidgetAnd3DTouch
//
//  Created by pangshishan on 2018/1/24.
//  Copyright © 2018年 pangshishan. All rights reserved.
//

import UIKit

fileprivate let CellIdentifier = "CellIdentifier"
fileprivate let CellHeight: CGFloat = 80

class ViewController: UIViewController, UIViewControllerPreviewingDelegate {
    
    
    fileprivate var tableView: UITableView!
    
    fileprivate lazy var dataArray: [String] = {
        var arr: [String] = Array()
        for i in 0..<20 {
            arr.append("\(i)");
        }
        return arr
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
         setupUI()
        let view = UIView.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 3));
        view.backgroundColor = UIColor.red
        self.view.addSubview(view)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let vc = PreviewViewController()
        guard let indexPath = tableView.indexPath(for: (previewingContext.sourceView as? UITableViewCell)!) else { return vc }
        let str = dataArray[indexPath.row]
        vc.string = str
        vc.jumpIntoBlock = {
            (previewVC) in
            self.present(previewVC, animated: true, completion: nil)
        }
        vc.deleteBlock = {
            [unowned self] (str) in
            self.dataArray = self.dataArray.filter({ (filterStr) -> Bool in
                return !(filterStr == str)
            })
            self.tableView.reloadData()
        }
        let rect = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CellHeight)
        previewingContext.sourceRect = rect
        
        return vc
    }
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        if let naVC = self.navigationController {
            naVC.pushViewController(viewControllerToCommit, animated: true)
        } else {
            self.present(viewControllerToCommit, animated: true, completion: nil)
        }
    }

    
}

// MARK:- 设置UI
extension ViewController {
    
    fileprivate func setupUI() {
        addTableView()
    }
    fileprivate func addTableView() {
        tableView = UITableView.init(frame: view.bounds, style: .plain);
        view.addSubview(tableView)
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
    }
}

// MARK:- UITableView代理方法
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
        cell.textLabel?.text = self.dataArray[indexPath.row]
        
        // 注册 3D Touch
        if self.traitCollection.forceTouchCapability == .available {
            self.registerForPreviewing(with: self, sourceView: cell)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CellHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}








