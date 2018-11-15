//
//  ViewController.swift
//  多线程
//
//  Created by liyoucheng on 2018/11/14.
//  Copyright © 2018年 齐家科技. All rights reserved.
//

import UIKit

class ThreadTest {
    
}

class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func thread(_ sender: Any) {
        let vc = ThreadVC()
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func operation(_ sender: Any) {
        let vc = OperationVC()
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func gcd(_ sender: Any) {
        let vc = GcdVC()
        self.present(vc, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


