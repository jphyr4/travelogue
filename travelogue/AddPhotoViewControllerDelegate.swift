//
//  AppDelegate.swift
//  travelogue
//
//  Created by Jacob Paul Hassler on 12/1/18.
//  Copyright © 2018 jphyr4. All rights reserved.
//

import UIKit

protocol AddPhotoViewControllerDelegate: class {
    func cancelButtonPressed(by controller: AddPhotoViewController)
    
    func useThisPhotoButtonPressed(by controller: AddPhotoViewController, with image: UIImage)
}
