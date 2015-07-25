//
//  novelListCell.swift
//  novelty
//
//  Created by 酒井文也 on 2015/07/22.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

import UIKit

class novelListCell: UITableViewCell {

    //ノベルのテーブルビューの要素
    @IBOutlet var novelImage: UIImageView!
    @IBOutlet var novelListTitle: UILabel!
    @IBOutlet var novelListCategory: UILabel!
    @IBOutlet var novelListDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
