//
//  NoveltyController.swift
//  novelty
//
//  Created by 酒井文也 on 2015/07/20.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

import UIKit

class NoveltyController: UIViewController {

    var novelData: AnyObject!
    
    //表示する内容（UITextFieldはEditableを外してね）
    @IBOutlet var novelTitle: UILabel!
    @IBOutlet var novelSynopsis: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //データを表示する
        self.novelTitle.text = novelData.objectForKey("name") as? String
        self.novelSynopsis.text = novelData.objectForKey("synopsis") as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
