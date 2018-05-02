//
//  ViewController.swift
//  BRPopupCard
//
//  Created by Archy on 2018/3/22.
//  Copyright © 2018年 Archy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       _ = BRPopupCard.show("test test test", content: "test test test", inView: UIApplication.shared.keyWindow!)
    }


}

