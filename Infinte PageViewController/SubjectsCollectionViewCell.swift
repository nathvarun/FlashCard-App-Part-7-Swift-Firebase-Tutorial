//
//  SubjectsCollectionViewCell.swift
//  Infinte PageViewController
//
//  Created by Varun Nath on 08/05/17.
//  Copyright © 2017 UnsureProgrammer. All rights reserved.
//

import UIKit

class SubjectsCollectionViewCell: UICollectionViewCell {
      
    
    @IBOutlet weak var subjectImage: UIImageView!
    @IBOutlet weak var subjectName: UILabel!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeImageRound()
    }
    
    func makeImageRound(){
        
        self.subjectImage.layer.masksToBounds = true
        self.subjectImage.layer.cornerRadius = (self.subjectImage.frame.height)/2

    }
}

