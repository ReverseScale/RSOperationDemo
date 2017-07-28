# RSOperationDemo
Swift实现的Operation多线程方法Demo


![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg) ![](https://img.shields.io/badge/download-1.8MB-brightgreen.svg
) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 

在之前的YYWebImageDemo实现中，展示了OC的多线程加载方法，这里来总结Swift的Operation多线程方法，借鉴制作Demo。

| 名称 |1.列表页 |2.展示页 |3.展示页 |
| ------------- | ------------- | ------------- | ------------- |
| 截图 | ![](http://og1yl0w9z.bkt.clouddn.com/17-7-28/96958186.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/17-7-28/8976621.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/17-7-28/24523335.jpg) |
| 描述 | 通过 storyboard 搭建基本框架 | 加载使用方法 | 封装使用方法 |


## Advantage 框架的优势
* 1.文件少，代码简洁
* 2.不依赖任何其他第三方库
* 3.自带图片下载与缓存
* 4.具备较高自定义性
* 5.演示直观封装性好

## Requirements 要求
* iOS 7+
* Xcode 8+


## Usage 使用方法
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
使用简单、效率高效、进程安全~~~如果你有更好的建议,希望不吝赐教!


## License 许可证
RSOperationDemo 使用 MIT 许可证，详情见 LICENSE 文件。


## Contact 联系方式:
* WeChat : WhatsXie
* Email : ReverseScale@iCloud.com
* Blog : https://reversescale.github.io
