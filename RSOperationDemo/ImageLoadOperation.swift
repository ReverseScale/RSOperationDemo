//
//  ImageLoadOperation.swift
//  RSOperationDemo
//
//  Created by WhatsXie on 2017/7/28.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import UIKit

class ImageLoadOperation: Operation {
    let item: Item
    var dataTask: URLSessionDataTask?
    let complete: (UIImage?) -> Void
    
    init(forItem: Item, execute: @escaping (UIImage?) -> Void) {
        item = forItem
        complete = execute
        super.init()
    }
    /*
     start: 所有并行的 Operations 都必须重写这个方法，然后在你想要执行的线程中手动调用这个方法。注意：任何时候都不能调用父类的start方法。
     main: 在start方法中调用，但是注意要定义独立的自动释放池与别的线程区分开。
     isExecuting: 是否执行中，需要实现KVO通知机制。
     isFinished: 是否已完成，需要实现KVO通知机制。
     isAsynchronous: 该方法默认返回 假 ，表示非并发执行。并发执行需要自定义并且返回 真。后面会根据这个返回值来决定是否并发。
     */
    fileprivate var _executing : Bool = false
    
    override var isExecuting: Bool {
        get { return _executing }
        set {
            if newValue != _executing {
                willChangeValue(forKey: "isExecuting")
                _executing = newValue
                didChangeValue(forKey: "isExecuting")
            }
        }
    }
    
    override var isAsynchronous: Bool {
        get {
            return true
        }
    }
    
    override func start() {
        if !isCancelled {
            isExecuting = true
            isFinished = false
            startOperation()
        } else {
            isFinished = true
        }
        
        if let url = item.imageUrl() {
            
            let dataTask = URLSession.shared.dataTask(with: url, completionHandler: {[weak self](data, response, error) in
                if let data = data {
                    let image = UIImage(data: data)
                    self?.endOperationWith(image: image)
                } else {
                    self?.endOperationWith(image: nil)
                }
            })
            
            dataTask.resume()
        } else {
            self.endOperationWith(image: nil)
        }
    }
    
    fileprivate var _finished : Bool = false
    override var isFinished: Bool {
        get { return _finished }
        set {
            if newValue != _finished {
                willChangeValue(forKey: "isFinished")
                _finished = newValue
                didChangeValue(forKey: "isFinished")
            }
        }
    }


    override func cancel() {
        if !isCancelled {
            cancelOperation()
        }
        super.cancel()
        completeOperation()
    }
    
}
// MARK: - 自定义对外的方法
extension ImageLoadOperation {
    func startOperation() {
        completeOperation()
    }
    
    func cancelOperation() {
        dataTask?.cancel()
    }
    
    func completeOperation() {
        if isExecuting && !isFinished {
            isExecuting = false
            isFinished = true
        }
    }
    
    func endOperationWith(image: UIImage?) {
        if !isCancelled {
            complete(image)
            completeOperation()
        }
    }
}
