//
//  AppDelegate.swift
//  travelogue
//
//  Created by Jacob Paul Hassler on 12/1/18.
//  Copyright © 2018 jphyr4. All rights reserved.
//


import UIKit
import CoreData

class AddTripViewController: UIViewController, AddPhotoViewControllerDelegate {
    
    weak var delegate: AddTripViewControllerDelegate?
    
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var requiredLabel: UILabel!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var title: UITextField!
    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var pickedImage: UIImage?
    var compressedImageData: Data!
    var sentData: TripRecord!
    var updating: Bool = false
    
    var indexPath: NSIndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requiredLabel.isHidden = true
        Name.text = sentData?.name
        title.text = sentData?.title
        text.text = sentData?.text
        
        if let photo = sentData?.photo {
            pickedImage = UIImage(data: photo)
            compressedImageData = photo
            addPhotoButton.setBackgroundImage(pickedImage, for: .normal)
        }
        if updating == true {
            deleteButton.isHidden = false
            addPhotoButton.setTitle("Change Photo", for: .normal)
            viewLabel.text = "Edit Title"
        }
        else {
            deleteButton.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        updating = false
        delegate?.cancelButtonPressed(by: self)
        
    }
    func cancelButtonPressed(by controller: AddPhotoViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func useThisPhotoButtonPressed(by controller: AddPhotoViewController, with image: UIImage) {
        pickedImage = image
        let compressedImage = resize(image)
    addPhotoButton.setBackgroundImage(compressedImage, for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        Name.resignFirstResponder()
        title.resignFirstResponder()
        text.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! AddPhotoViewController
            destination.delegate = self
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if Name.text == "" {
            requiredLabel.isHidden = false
        }
        else if title.text == "" {
            requiredLabel.isHidden = false
        }
        else if text.text == "" {
            requiredLabel.isHidden = false
        }
        else if compressedImageData == nil {
            requiredLabel.isHidden = false
        }
        else {
            delegate?.itemSaved(by: self, with: Name.text!, title: title.text!, text: Text.text!, photo: compressedImageData, update: updating, at: indexPath )
        }
        updating = false
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        
        delegate?.deleteRecord(by: self, with: indexPath)
    }
    
   
    
}
