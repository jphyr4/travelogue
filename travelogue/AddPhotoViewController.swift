//
//  AppDelegate.swift
//  travelogue
//
//  Created by Jacob Paul Hassler on 12/1/18.
//  Copyright © 2018 jphyr4. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class AddPhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    weak var delegate: AddPhotoViewControllerDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var imageStatusLabel: UILabel!
    
    var pickedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        imageStatusLabel.isHidden = false

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.cancelButtonPressed(by: self)
    }
    
    @IBAction func useThisPhotoPressed(_ sender: UIButton) {
        if let image = pickedImage {
          delegate?.useThisPhotoButtonPressed(by: self, with: image)
        }
        
        
    }
    @IBAction func didTouchPhotoLibraryButton(_ sender: Any) {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authStatus {
            
        case .authorized:
            print("authorized")
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = false
            self.present(imagePickerController, animated:true, completion:nil)
            
        case .notDetermined:
            print("not determined")
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                if newStatus == PHAuthorizationStatus.authorized {
                    DispatchQueue.main.async {
                        self.imagePickerController.sourceType = .photoLibrary
                        self.imagePickerController.allowsEditing = false
                        self.present(self.imagePickerController, animated:true, completion:nil)
                    }
                }
            })
            
        case .denied:
            print("denied")
            let alert = UIAlertController(title: "Unable to access the Photo Library",
                                          message: "To enable access, go to Settings > Privacy > Photos and turn on Photo access for this app.",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
                // Take the user to Settings app to possibly change permission.
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        // Finished opening URL
                    })
                }
            })
            alert.addAction(settingsAction)
            
            present(alert, animated: true, completion: nil)
        case .restricted:
            print("restricted")
        }
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("picked image, or snapped photo")
        let newImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        pickedImage = newImage!
        imageView.contentMode = .scaleAspectFit
        imageView.image = pickedImage
        imageStatusLabel.isHidden = true
        dismiss(animated:true, completion: nil)
    }
    
    @IBAction func showImagePickerForCamera(_ sender: Any) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        if authStatus == AVAuthorizationStatus.denied {
            // Denied access to camera, alert the user.
            // The user has previously denied access. Remind the user that we need camera access to be useful.
            let alert = UIAlertController(title: "Unable to access the Camera",
                                          message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
                // Take the user to Settings app to possibly change permission.
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        // Finished opening URL
                    })
                }
            })
            alert.addAction(settingsAction)
            
            present(alert, animated: true, completion: nil)
        }
        else if (authStatus == AVAuthorizationStatus.notDetermined) {
           
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if granted {
                    DispatchQueue.main.async {
                        self.imagePickerController.sourceType = .camera
                        self.imagePickerController.allowsEditing = false
                        self.present(self.imagePickerController, animated:true, completion:nil)
                    }
                }
            })
        } else {
           
            imagePickerController.sourceType = .camera
            imagePickerController.allowsEditing = false
            self.present(imagePickerController, animated:true, completion:nil)
        }
    }
    
}
