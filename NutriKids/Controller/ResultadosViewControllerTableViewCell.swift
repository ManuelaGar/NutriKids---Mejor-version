//
//  ResultadosViewControllerTableViewCell.swift
//  NutriKids
//
//  Created by Manuela Garcia on 5/10/18.
//  Copyright © 2018 Manuela Garcia. All rights reserved.
//

import UIKit

class ResultadosViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var indicador: UILabel!
    @IBOutlet weak var sd: UILabel!
    @IBOutlet weak var clasificacion: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
