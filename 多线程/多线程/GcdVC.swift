//
//  GcdVC.swift
//  多线程
//
//  Created by liyoucheng on 2018/11/15.
//  Copyright © 2018年 齐家科技. All rights reserved.
//

import UIKit

class GcdVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //创建串行队列
        let serial = DispatchQueue(label: "serialQueue1")
        
        //创建并行队列
        let concurrent = DispatchQueue(label: "concurrentQueue1", attributes: .concurrent)
        
        let globalQueue = DispatchQueue.global(qos: .default)
        
        let mainQueue = DispatchQueue.main
        
        DispatchQueue.global(qos: .default).async {
            //处理耗时操作的代码块...
            print("do work")
            
            //操作完成，调用主线程来刷新界面
            DispatchQueue.main.async {
                print("main refresh")
            }
        }
        
        
        //添加同步代码块到global队列
        //不会造成死锁，但会一直等待代码块执行完毕
        DispatchQueue.global(qos: .default).sync {
            print("sync1")
        }
        print("end1")
        
        
        //添加同步代码块到main队列
        //会引起死锁
        //因为在主线程里面添加一个任务，因为是同步，所以要等添加的任务执行完毕后才能继续走下去。但是新添加的任务排在
        //队列的末尾，要执行完成必须等前面的任务执行完成，由此又回到了第一步，程序卡死
        DispatchQueue.main.sync {
            print("sync2")
        }
        print("end2")
        
        //创建并行队列
        let conQueue = DispatchQueue(label: "concurrentQueue1", attributes: .concurrent)
        //暂停一个队列
        conQueue.suspend()
        //继续队列
        conQueue.resume()
        
        
        //延时2秒执行
        DispatchQueue.global(qos: .default).asyncAfter(deadline: DispatchTime.now() + 2.0) {
            print("after!")
        }
        
        
        //将要执行的操作封装到DispatchWorkItem中
        let task = DispatchWorkItem { print("after!") }
        //延时2秒执行
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: task)
        //取消任务
        task.cancel()
        
        
        //获取系统存在的全局队列
        let queue = DispatchQueue.global(qos: .default)
        //定义一个group
        let group = DispatchGroup()
        //并发任务，顺序执行
        queue.async(group: group) {
            sleep(2)
            print("block1")
        }
        queue.async(group: group) {
            print("block2")
        }
        queue.async(group: group) {
            print("block3")
        }
        
        //1,所有任务执行结束汇总，不阻塞当前线程
        group.notify(queue: .global(), execute: {
            print("group done")
        })
        
        //2,永久等待，直到所有任务执行结束，中途不能取消，阻塞当前线程
        group.wait()
        print("任务全部执行完成")
        
        
        //获取系统存在的全局队列
        let queue1 = DispatchQueue.global(qos: .default)
        
        //定义一个异步步代码块
        queue1.async {
            //通过concurrentPerform，循环变量数组
            DispatchQueue.concurrentPerform(iterations: 6) {(index) -> Void in
                print(index)
            }
            
            //执行完毕，主线程更新
            DispatchQueue.main.async {
                print("done")
            }
        }
        
        
        
        //获取系统存在的全局队列
        let queue2 = DispatchQueue.global(qos: .default)
        
        //当并行执行的任务更新数据时，会产生数据不一样的情况
        for i in 1...10 {
            queue2.async {
                print("\(i)")
            }
        }
        
        //使用信号量保证正确性
        //创建一个初始计数值为1的信号
        let semaphore = DispatchSemaphore(value: 1)
        for i in 1...10 {
            queue2.async {
                //永久等待，直到Dispatch Semaphore的计数值 >= 1
                semaphore.wait()
                print("\(i)")
                //发信号，使原来的信号计数值+1
                semaphore.signal()
            }
        }
    }
    
    private var once1:Void = {
        //只执行一次
        print("once1")
    }()
    
    private lazy var once2:String = {
        //只执行一次，可用于创建单例
        print("once2")
        return "once2"
    }()
}
