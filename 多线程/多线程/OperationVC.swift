//
//  OperationVC.swift
//  多线程
//
//  Created by liyoucheng on 2018/11/15.
//  Copyright © 2018年 齐家科技. All rights reserved.
//

import UIKit

class DownloadImageOperation: Operation {
    override func main() {
        let imageUrl = "http://hangge.com/blog/images/logo.png"
        let data = try! Data(contentsOf: URL(string: imageUrl)!)
        print(data.count)
    }
}

class OperationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        ///直接用定义好的子类
        let operation = BlockOperation(block: { [weak self] in
            self?.downloadImage()
            return
        })
        
        //创建一个NSOperationQueue实例并添加operation
        let queue = OperationQueue()
        queue.addOperation(operation)
        
        
        ///集成Operation
        //创建线程对象
        let downloadImageOperation = DownloadImageOperation()
        //每个Operation完成都会有一个回调表示任务结束
        downloadImageOperation.completionBlock = { () -> Void in
            print("completionBlock")
        }
        
        //创建一个OperationQueue实例并添加operation
        let queue1 = OperationQueue()
        
        queue1.addOperation(downloadImageOperation)
        
        //设置并发数
        queue.maxConcurrentOperationCount = 5
        
        //取消队列所有操作
        queue1.cancelAllOperations()
    }
    
    @objc func downloadImage() {
        let imageUrl = "http://hangge.com/blog/images/logo.png"
        let data = try! Data(contentsOf: URL(string: imageUrl)!)
        print(data.count)
    }
}
