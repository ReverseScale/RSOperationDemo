# RSOperationDemo

![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg) ![](https://img.shields.io/badge/download-1.8MB-brightgreen.svg
) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 

[EN](https://github.com/ReverseScale/RSOperationDemo) | [中文](https://github.com/ReverseScale/RSOperationDemo/blob/master/README_zh.md)

In the previous YYWebImageDemo implementation, OC multi-threaded loading method was demonstrated. Swift's Operation multi-threaded method was summarized here to draw on Demo.

## 🎨 Why test the UI?

|1.List page | 2.Show page | 3.Show page |
| ------------- | ------------- | ------------- |
| ![](http://ghexoblogimages.oss-cn-beijing.aliyuncs.com/18-11-22/10231888.jpg) | ![](http://ghexoblogimages.oss-cn-beijing.aliyuncs.com/18-11-22/33040799.jpg) | ![](http://ghexoblogimages.oss-cn-beijing.aliyuncs.com/18-11-22/83615963.jpg) |
| Build the basic framework through storyboard | Load usage method | Package use method |

## 🤖 Requirements

* iOS 9.0+
* Xcode 9.0+
* Swift 

## 🚀 Getting started

* 1.Less files, simple code
* 2.Does not rely on any other third party library
* 3.comes with picture download and cache
* 4.Highly customizable
* 5.Demonstrates intuitive packageability


## 🛠 Configuration
### Routine use of multithreading
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
            // The main thread stops the refresher
            self?.operationQueue.waitUntilAllOperationsAreFinished()
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
        }
    }

```
### Multithreading priority use
```
fileprivate func startPriorityDemo() {
        operationQueue.maxConcurrentOperationCount = 2
        activityIndicator.startAnimating()
        var operations = [Operation]()
        for (index, imageView) in (imageViews?.enumerated())! {
            if let url = URL(string: "https://placebeard.it/355/140") {
                // Constructor creates an operation
                let operation = convenienceOperation(setImageView: imageView, withURL: url)
                // Set the priority based on the index
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
        // Add the task array to the thread
        DispatchQueue.global().async {
            [weak self] in
            self?.operationQueue.addOperations(operations, waitUntilFinished: true)
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
        }
    }

```
### Use of multithreaded dependencies
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


## ⚖ License

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

## 😬 Contributions

* WeChat : WhatsXie
* Email : ReverseScale@iCloud.com
* Blog : https://reversescale.github.io
