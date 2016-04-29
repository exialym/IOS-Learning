//
//  EquipmentTableViewCell.swift
//  MagicBar
//
//  Created by 🦁️ on 16/3/30.
//  Copyright © 2016年 exialym. All rights reserved.
//

import UIKit

class EquipmentTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var info: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
