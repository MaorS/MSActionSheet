//
//  MSActionSheet.swift
//  Version 1.3
//  Created by Maor Shams on 07/04/2017.
//  Copyright © 2017 Maor Shams. All rights reserved.
//
import UIKit
import MobileCoreServices

class MSActionSheet: UIAlertController {
    
    // preferredStyle is a read-only property, so you have to override it
    override var preferredStyle: UIAlertControllerStyle {
        return .actionSheet
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    convenience init(viewController : UIViewController, sourceView : UIView, title: String? = nil, message: String? = nil) {
        self.init()
        initialize(viewController: viewController,sourceView: sourceView, title: title, message: message)
    }
    
    // Configuration for actionsheet
    private func initialize(viewController : UIViewController? = nil,
                            sourceView : UIView? = nil,
                            title: String? = nil,
                            message: String? = nil) {
        
        if let title = title, let message = message {
            self.title = title
            self.message = message
        }
        
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        currentvViewController = (viewController == nil) ? rootVC : viewController
        self.sourceView = sourceView
    }
    
    private var currentvViewController : UIViewController?
    private var onFinishPicking : ((_ : UIImage?) -> Void)?
    private var sourceView : UIView?
    
    
    /// Create Full ActionSheet include library, front camera, rear camera, cancel button and default images.
    /// - parameters:
    ///   - completion: Execute after the user took the image, returns optional UIImage, returns nil if the user did not select
    func showFullActionSheet(completion : @escaping (_ : UIImage?) -> Void) {
             add(.library, defaultImage : true)
            .add(.frontCamera, defaultImage : true)
            .add(.rearCamera, defaultImage : true)
            .add(.cancel)
            .show(completion: completion)
    }
    
    /// Add new alert action to the action sheet.
    /// - parameters:
    ///   - type: - The type of the alert action
    ///   - title: (_optional_) - The title of the alert action, by default the values from MSActionsSheet.ActionType
    ///   - style: (_optional_) - The style of the alert action, by default the value is .default. If the type of the action sheet is .cancel, and the style is nil, the style will set as .cancel
    ///   - image: (_optional_) - The image of the alert action, by default nil (no image)
    ///   - defaultImage: (_optional_) - The default image based on the type from MSActionsSheet.ActionType
    
    func add(_ type : ActionType,
             title : String? = nil,
             style : UIAlertActionStyle? = nil,
             image : UIImage? = nil,
             defaultImage : Bool = false) -> MSActionSheet{
        
        let newTitle : String = (title == nil) ? type.title : title!
        let newImage : UIImage? = defaultImage == true ? type.image : image
        let newStyle : UIAlertActionStyle = (type == .cancel && style == nil) ? .cancel : style == nil ? .default : style!
        
        let action = MSActionSheetAction(actionTitle: newTitle,
                                         style: newStyle,
                                         image: newImage,
                                         actionType: type,
                                         handler: actionSheetAction)
        
        return self.add(action: action)
    }
    
    /// Add new custom action to the action sheet.
    /// - parameters:
    ///   - title: (_optional_) - A title for the action
    ///   - isDestructive: (_optional_) - set destructive style, false by default
    ///   - image: (_optional_) - Custom image for the action, No image by default
    ///   - handler: when the user click on the button
    func addCustom(title : String,
                         isDestructive : Bool = false,
                         image : UIImage? = nil,
                         handler : @escaping ()->Void) -> MSActionSheet{
        
        let customButtonAction = MSActionSheetAction(actionTitle: title, style: self.isDestructive(isDestructive), image: image) { _ in
            handler()
        }
        return self.add(action: customButtonAction)
    }
    
    
    /// Set color for ActionSheet
    /// - parameters:
    ///   - color: The tint color of the actionsheet
    func setTint(color : UIColor) -> MSActionSheet{
        self.view.tintColor = color
        return self
    }
    
    
    /// Presents the ActionSheet on the view controller.
    /// (Make sure this is the last method called!)
    /// - parameters:
    ///   - completion: (_optional UIImage_) The selected image, nil if the user did not select
    func show(completion: @escaping (UIImage?) -> Void){
        self.onFinishPicking = completion
        
        if UIDevice.current.userInterfaceIdiom == .pad, let source = sourceView{
            self.popoverPresentationController?.sourceView = source
            self.popoverPresentationController?.sourceRect = source.bounds
        }
        
        currentvViewController?.present(self, animated: true, completion: nil)
    }
    
    
    private func actionSheetAction(_ action : UIAlertAction){
        
        guard let action = action as? MSActionSheetAction else {
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.mediaTypes = [kUTTypeImage as String]
        
        switch action.type! {
        case ActionType.library:
            picker.sourceType = .photoLibrary
        case ActionType.rearCamera:
            picker.sourceType = .camera
            picker.cameraDevice = .rear
            picker.showsCameraControls = true
        case ActionType.frontCamera:
            picker.sourceType = .camera
            picker.cameraDevice = .front
            picker.showsCameraControls = true
        default: return
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad, let source = sourceView{
            self.popoverPresentationController?.sourceView = source
            self.popoverPresentationController?.sourceRect = source.bounds
        }
        
        currentvViewController?.present(picker, animated: true, completion: nil)
        
    }
    
    private func add(action: MSActionSheetAction) -> MSActionSheet{
        self.addAction(action)
        return self
    }
    
    private func isDestructive(_ destructive : Bool) -> UIAlertActionStyle {
        return destructive ? .destructive : .default
    }
    
}
extension MSActionSheet: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // get info about selected image when finish picking
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // dismiss picker
        picker.dismiss(animated: true) { [weak self] in
            // get image
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
                self?.onFinishPicking?(image)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [weak self] in
            self?.onFinishPicking?(nil)
        }
    }
}


extension MSActionSheet{
    
    enum ActionType {
        case library
        case frontCamera
        case rearCamera
        case cancel
        
        var title : String{
            switch self {
            case .library     : return "Photo Library"
            case .frontCamera : return "Front Camera"
            case .rearCamera  : return "Rear Camera"
            case .cancel      : return "Cancel"
            }
        }
        
        var image : UIImage?{
            switch self {
            case .library     : return #imageLiteral(resourceName: "msactionsheet_library")
            case .frontCamera : return #imageLiteral(resourceName: "msactionsheet_frontcam")
            case .rearCamera  : return #imageLiteral(resourceName: "msactionsheet_rearcam")
            case .cancel      : return nil
            }
        }
        
    }
    
}

class MSActionSheetAction : UIAlertAction{
    
    var type : MSActionSheet.ActionType?
    
    convenience init(actionTitle: String,
                     style: UIAlertActionStyle,
                     image : UIImage? = nil,
                     actionType : MSActionSheet.ActionType? = nil,
                     handler: @escaping ((UIAlertAction) -> Void) ){
        
        self.init(title: actionTitle, style: style, handler: handler)
        
        self.setValue(image, forKey: "image")
        self.type = actionType
    }
}
