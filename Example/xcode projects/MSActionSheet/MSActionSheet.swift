//
//  MSActionSheet.swift
//  Version 1.2
//  Created by Maor Shams on 07/04/2017.
//  Copyright © 2017 Maor Shams. All rights reserved.
//
import UIKit
import MobileCoreServices

class MSActionSheet: UIAlertController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    fileprivate static var sheet : UIAlertController?
    static let instance = MSActionSheet()
    
    var clientVC : UIViewController?
    
    // Button names
    fileprivate var library = "Photo Library"
    fileprivate var frontCamera = "Front Camera"
    fileprivate var rearCamera = "Rear Camera"
    fileprivate var cancel = "Cancel"
    
    /// Create Full ActionSheet
    /// - parameters:
    ///   - vc: The view controller to show the ActionSheet at
    ///   - handler: The function that  will execute after the user took the image, also you get the optional UIImage
    func showFullActionSheet(on vc : UIViewController,handler : @escaping (_ : UIImage?) -> Void) {
        let sheet = create().addLibrary().addFrontCamera().addRearCamera().addCancelButton()
        sheet.show(on: vc){ (image : UIImage?) in
              handler(image)
        }
    }
    
    
    /// Create new ActionSheet
    /// - parameters:
    ///   - title: (_optional_) - A title for the ActionSheet, by default does not contain title
    ///   - message: (_optional_) - A message for the ActionSheet, by default does not contain title
    func create(title: String = "", message: String = "") -> MSActionSheet {
        if title.isEmpty && message.isEmpty{
            MSActionSheet.sheet = UIAlertController()
        }else{
            MSActionSheet.sheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        }
        return self
    }
    
    /// Presents Library button in ActionSheet
    /// - parameters:
    ///   - title: (_optional_) - A title for the button, by default the title is "Photo Library"
    ///   - destructive : (_optional_) - Apply destructive style for this action
    ///   - image: (_optional_) - Custom image for button, by default the image is "msactionsheet_library" from assets
    func addLibrary(title : String = "Photo Library",destructive style : Bool = false ,  image : UIImage? = nil) -> MSActionSheet{
        library = title
        let libraryAction = UIAlertAction(title: library, style : isDestructive(style), handler: handler)
        
        if let img : UIImage = image{ // client select different image
            libraryAction.image = img
        }else{
            if let img = UIImage(named: "msactionsheet_library") { //the image exists..
                libraryAction.image = img
            }
        }
        MSActionSheet.sheet?.addAction(libraryAction)
        return self
    }
    
    /// Presents Front Camera button in ActionSheet
    /// - parameters:
    ///   - title: (_optional_) - A title for the button, by default the title is "Front Camera"
    ///   - destructive : (_optional_) - Apply destructive style for this action
    ///   - image: (_optional_) - Custom image for button, by default the image is "msactionsheet_frontCam" from assets
    func addFrontCamera(title : String = "Front Camera",destructive style : Bool = false, image : UIImage? = nil) -> MSActionSheet{
        guard UIImagePickerController.isCameraDeviceAvailable(.front) else {
            return self
        }
        
        frontCamera = title
        let frontCamAction = UIAlertAction(title: frontCamera, style: isDestructive(style), handler: handler)
        
        if let img : UIImage = image{ // client select different image
            frontCamAction.image = img
        }else{
            if let img = UIImage(named: "msactionsheet_frontCam") { //the image exists..
                frontCamAction.image = img
            }
        }
        MSActionSheet.sheet?.addAction(frontCamAction)
        return self
        
    }
    
    /// Presents Rear Camera button in ActionSheet
    /// - parameters:
    ///   - title: (_optional_) - A title for the button, by default the title is "Rear Camera"
    ///   - destructive : (_optional_) - Apply destructive style for this action
    ///   - image: (_optional_) - Custom image for button, by default the image is "msactionsheet_rearCam" from assets
    func addRearCamera(title : String = "Rear Camera", destructive style : Bool = false , image : UIImage? = nil) -> MSActionSheet{
        guard UIImagePickerController.isCameraDeviceAvailable(.rear) else {
            return self
        }
        
        self.rearCamera = title
        let rearCamAction = UIAlertAction(title: rearCamera, style: isDestructive(style), handler: handler)
        
        if let img : UIImage = image{ // client select different image
            rearCamAction.image = img
        }else{
            if let img = UIImage(named: "msactionsheet_rearCam") { //the image exists..
                rearCamAction.image = img
            }
        }
        MSActionSheet.sheet?.addAction(rearCamAction)
        return self
    }
    
    
    /// Presents Cancel button in ActionSheet
    /// - parameters:
    ///   - title: (_optional_) - A title for the button, by default the title is "Cancel"
    func addCancelButton(title : String = "Cancel") -> MSActionSheet{
        cancel = title
        MSActionSheet.sheet?.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
        return self
    }
    
    
    /// Presents the builded ActionSheet on passed view controller.
    /// (Make sure this is the last method called!)
    /// - parameters:
    ///   - vc: The view controller to show the ActionSheet at
    func show(on vc : UIViewController, onFinishPicking  handler: @escaping (_ : UIImage?) -> Swift.Void){
        self.handler = handler
        clientVC = vc
        vc.present(MSActionSheet.sheet!, animated: true, completion: nil)
    }
    
    
    fileprivate func handler(_ action : UIAlertAction){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.mediaTypes = [kUTTypeImage as String]
        
        switch action.title ?? "" {
        case library:
            picker.sourceType = .photoLibrary
        case rearCamera:
            picker.sourceType = .camera
            picker.cameraDevice = .rear
            picker.showsCameraControls = true
        case frontCamera:
            picker.sourceType = .camera
            picker.cameraDevice = .front
            picker.showsCameraControls = true
        default: return
        }
        
        clientVC?.present(picker, animated: true, completion: nil)
    }
    
    fileprivate var img : UIImage?
    
    /// Get the selected image by the user
    /// (Make sure this method called inside the onFinishPicking()  method or inside showFullActionSheet() handler)
    func getImage() -> UIImage?{
        return img ?? nil
    }
    
    // get info about selected image when finish picking
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // dismiss picker
        picker.dismiss(animated: true, completion: nil)
        
        
        // get image
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            img = image
            handler!(image)
        }
        
        reset()
    }
    
    fileprivate var handler : ((_ : UIImage?) -> Void)?
    
  /*  /// Event will execute after the user took the image
    /// - parameters:
    ///   - handler: The function that  will execute after the user took the image
    func onFinishPicking(handler : @escaping (_ : UIImage?) -> Swift.Void){
        self.handler = handler
    }*/
    
    /// Set color for ActionSheet
    /// - parameters:
    ///   - color: The color for actionsheet
    func tintColor(color : UIColor) -> MSActionSheet{
        MSActionSheet.sheet?.view.tintColor = color
        return self
    }
    
    
    fileprivate func isDestructive(_ destructive : Bool) -> UIAlertActionStyle {
        return destructive ? .destructive : .default
    }
    
    fileprivate func reset(){
        handler = nil
        img = nil
        clientVC = nil
        MSActionSheet.sheet = nil
    }
}

extension UIAlertAction{
    @NSManaged var image : UIImage?
    convenience init(title: String?,style: UIAlertActionStyle,image : UIImage?, handler: ((UIAlertAction) -> Void)? = nil ){
        self.init(title: title, style: style, handler: handler)
        self.image = image
    }
}
