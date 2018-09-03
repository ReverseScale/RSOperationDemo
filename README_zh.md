# RSOperationDemo

![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg) ![](https://img.shields.io/badge/download-1.8MB-brightgreen.svg
) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 

[EN](https://github.com/ReverseScale/RSOperationDemo) | [中文](https://github.com/ReverseScale/RSOperationDemo/blob/master/README_zh.md)

在之前的YYWebImageDemo实现中，展示了OC的多线程加载方法，这里来总结Swift的Operation多线程方法，借鉴制作Demo。

## 🎨 测试 UI 什么样子？

|1.列表页 |2.展示页 |3.展示页 |
| ------------- | ------------- | ------------- |
| ![](http://og1yl0w9z.bkt.clouddn.com/18-3-20/97364743.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/18-3-20/73732357.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/18-3-20/62310492.jpg) |
| 通过 storyboard 搭建基本框架 | 加载使用方法 | 封装使用方法 |


## 🤖 要求

* iOS 9.0+
* Xcode 9.0+
* Swift


## 🚀 准备开始
* 1.文件少，代码简洁
* 2.不依赖任何其他第三方库
* 3.自带图片下载与缓存
* 4.具备较高自定义性
* 5.演示直观封装性好


## 🛠 配置
### 多线程的常规使用
```
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

```
### 多线程优先级使用
```
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

```
### 多线程依赖关系使用
```
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
```

## ⚖ 协议

```
MIT License

Copyright (c) 2017 ReverseScale

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## 😬  联系

* 微信 : WhatsXie
* 邮件 : ReverseScale@iCloud.com
* 博客 : https://reversescale.github.io
