//
//  TableViewController.swift
//  RSOperationDemo
//
//  Created by WhatsXie on 2017/7/28.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    let cellIdentifier = "withIdentifier"
    
    var selectCellIndexPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("跳转前打印：\(String(describing: segue.identifier))")
        
        if let identifier = segue.identifier {
            if identifier == "basicDemosVCId" {
                let basicVC = segue.destination as! BasicDemosVC

                switch selectCellIndexPath!.row {
                case 0:
                    basicVC.demoType = DemoType.basic
                    break
                case 1:
                    basicVC.demoType = DemoType.priority
                    break
                case 2:
                    basicVC.demoType = DemoType.dependency
                    break
                default:
                    break
                }
            } else {
                segue.destination.title = "Collection Demo"
            }
        }
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectCellIndexPath = indexPath
        
        switch indexPath.row {
        case 0,1,2:
            performSegue(withIdentifier: "basicDemosVCId", sender: self)
            break
        default:
            break
        }
    }
}
