//
//  ViewController.swift
//  WidgetAnd3DTouch
//
//  Created by pangshishan on 2018/1/24.
//  Copyright © 2018年 pangshishan. All rights reserved.
//

import UIKit

fileprivate let CellIdentifier = "CellIdentifier"

class ViewController: UIViewController {
    
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
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}








