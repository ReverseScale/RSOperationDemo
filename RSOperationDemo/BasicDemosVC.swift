//
//  BasicDemosVC.swift
//  RSOperationDemo
//
//  Created by WhatsXie on 2017/7/28.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import UIKit

enum DemoType : Int{
    case basic
    case priority
    case dependency
    case collection
}

class BasicDemosVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var imageViews:[UIImageView]!
    
    let operationQueue = OperationQueue.init()
    
//    var imageViews : [UIImageView]?
    var demoType : DemoType?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let type = demoType else { return }
        switch type {
        case .basic:
            self.title = "基本应用"
            break
        case .priority :
            self.title = "优先级"
            break
        case .dependency :
            self.title = "依赖关系"
            break
        default :
            break
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        imageViews = [imageView1,imageView2,imageView3,imageView4]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playItemClick(_ sender: Any) {
        guard let type = demoType else { return }
        switch type {
        case .basic:
            startBasicDemo()
            break
        case .priority :
            startPriorityDemo()
            break
        case .dependency :
            startDepencyDemo()
            break
        default :
            break
        }
    }
    
}

extension BasicDemosVC {
    
    fileprivate func startBasicDemo() {
        operationQueue.maxConcurrentOperationCount = 3
        
        activityIndicator.startAnimating()
        
        for imageView in imageViews! {
            operationQueue.addOperation {
                if let url = URL(string: "https://placebeard.it/355/140") {
                    do {
                        let image = UIImage(data:try Data(contentsOf: url))
                        
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
        
        DispatchQueue.global().async {
            [weak self] in
            
            // 主线程停止刷新器。
            self?.operationQueue.waitUntilAllOperationsAreFinished()
            DispatchQueue.main.async {
                
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    
    fileprivate func startPriorityDemo() {
        operationQueue.maxConcurrentOperationCount = 2
        activityIndicator.startAnimating()
        
        var operations = [Operation]()
        for (index, imageView) in (imageViews?.enumerated())! {
            if let url = URL(string: "https://placebeard.it/355/140") {
                // 构造方法创建operation
                let operation = convenienceOperation(setImageView: imageView, withURL: url)
                
                //根据索引设置优先级
                switch index {
                case 0:
                    operation.queuePriority = .veryHigh
                case 1:
                    operation.queuePriority = .high
                case 2:
                    operation.queuePriority = .normal
                case 3:
                    operation.queuePriority = .low
                default:
                    operation.queuePriority = .veryLow
                }
                operations.append(operation)
            }
        }
        
        // 把任务数组加入到线程中
        DispatchQueue.global().async {
            [weak self] in
            self?.operationQueue.addOperations(operations, waitUntilFinished: true)
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    fileprivate func startDepencyDemo() {
       operationQueue.maxConcurrentOperationCount = 4
        self.activityIndicator.startAnimating()
        guard let url = URL(string: "https://placebeard.it/355/140") else { return }
        
        let op1 = convenienceOperation(setImageView: imageViews[0], withURL: url)
        let op2 = convenienceOperation(setImageView: imageViews[1], withURL: url)
        op2.addDependency(op1)
        let op3 = convenienceOperation(setImageView: imageViews[2], withURL: url)
        op3.addDependency(op2)
        let op4 = convenienceOperation(setImageView: imageViews[3], withURL: url)
        op4.addDependency(op3)
        
        DispatchQueue.global().async {
            [weak self] in
            self?.operationQueue.addOperations([op1,op2,op3,op4], waitUntilFinished: true)
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}



class convenienceOperation: Operation {
    let url: URL
    let imageView: UIImageView
    
    init(setImageView: UIImageView, withURL: URL) {
        imageView = setImageView
        url = withURL
        super.init()
    }
    
    override func main() {
        do {
            // 当任务被取消的时候，立刻返回
            if isCancelled {
                return
            }
            let imageData = try Data(contentsOf: url)
            let image = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                [weak self] in
                self?.imageView.image = image
            }
        } catch  {
            print(error)
        }
    }
}
