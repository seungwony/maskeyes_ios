//
//  AddressTableViewCell.swift
//  maskeyes
//
//  Created by SEUNGWON YANG on 2020/03/13.
//  Copyright © 2020 co.giftree. All rights reserved.
//

import UIKit

class StoreTableViewCell: UITableViewCell {
    @IBOutlet weak var typeIcon: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var remainStatLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var stockAtLabel: UILabel!
    
    @IBOutlet weak var addressButton: UIButton!
    
    @IBOutlet weak var moveToLocationButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
