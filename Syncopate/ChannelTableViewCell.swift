//
//  SeriesTableViewCell.swift
//  Syncopate
//
//  Created by Gary Chang on 9/3/15.
//  Copyright (c) 2015 Gary Chang. All rights reserved.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {
    
    // MARK: Prooperties
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
