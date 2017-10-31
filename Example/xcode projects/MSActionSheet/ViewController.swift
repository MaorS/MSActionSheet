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
        
        // Example 1 - Show full actionsheet, include library, front camera, rear camera
        
        MSActionSheet(viewController: self, sourceView: sender).showFullActionSheet {
            sender.setImage($0, for: .normal)
        }
        
        //  Example 2 - Create custom actionsheet with default params
        
        /*
         
         MSActionSheet(viewController: self, sourceView: sender)
         .add(.cancel)
         .add(.library)
         .add(.rearCamera)
         .add(.frontCamera).show {
         sender.setImage($0, for: .normal)
         }
         
         */
        
        //  Example 3 - Create custom actionsheet with custom params
        
        /*
         
         MSActionSheet(viewController: self, sourceView: sender)
         .add(.frontCamera, title: "Selfie camera", image: #imageLiteral(resourceName: "msactionsheet_selfie"))
         .add(.rearCamera, defaultImage: true)
         .setTint(color: .purple)
         .add(.cancel, style: .destructive)
         .show {
         sender.setImage($0, for: .normal)
         }
         
         */
        
        
        //  Example 4 - Create custom actionsheet with custom actions
        
        /*
         
         MSActionSheet(viewController: self, sourceView: sender)
         .add(.library, defaultImage: true)
         .addCustom(title: "Print", isDestructive: false, image: #imageLiteral(resourceName: "print_photo")) {
         print("Printing the photo")
         }.addCustom(title: "Share", isDestructive: true, image: #imageLiteral(resourceName: "share_photo")) {
         print("Sharing the photo")
         }.add(.cancel)
         .show {
         sender.setImage($0, for: .normal)
         }
         
         */
        
    }
    
}




