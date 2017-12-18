//
//  ContentsTableViewCell.swift
//  MySQLData
//
//  Created by akiko hayashi on 2017/12/18.
//  Copyright © 2017年 akiko hayashi. All rights reserved.
//

import UIKit

class ContentsTableViewCell: UITableViewCell {

    let cellTitle = UILabel()
    let cellContent = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        //============================================
        //タイトル
        //============================================
        cellTitle.frame = CGRect(x: 10, y: 10, width: UIScreen.main.bounds.size.width - 20, height: 20)
        cellTitle.font = UIFont(name: "Arial", size:15)
        cellTitle.numberOfLines = 1
        cellTitle.textAlignment = .left
        self.addSubview(cellTitle)

        //============================================
        //内容
        //============================================
        cellContent.frame = CGRect(x: 10, y: 40, width: UIScreen.main.bounds.size.width - 20, height: 0)
        cellContent.font = UIFont(name:"Arial", size:13)
        cellContent.numberOfLines = 0
        cellContent.textAlignment = .left
        cellContent.sizeToFit()
        self.addSubview(cellContent)
    }
}
