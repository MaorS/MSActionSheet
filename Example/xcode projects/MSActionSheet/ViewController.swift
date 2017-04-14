//
//  ViewController.swift
//  MSActionSheet
//
//  Created by Maor Shams on 07/04/2017.
//  Copyright © 2017 Maor Shams. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func selectImageAction(_ sender: UIButton) {
        
        MSActionSheet.instance.showFullActionSheet(on: self){ (image) in
            sender.setImage(image, for: .normal)
        }
        
        
       /*
        let sheet = MSActionSheet.instance
        sheet.create()
            .addCancelButton()
            .addLibrary()
            .addFrontCamera()
            .addRearCamera().show(on: self) { (image) in
                sender.setImage(image, for: .normal)
        }
         */
        
    }
    
}




