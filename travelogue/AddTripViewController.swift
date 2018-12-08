//
//  AppDelegate.swift
//  travelogue
//
//  Created by Jacob Paul Hassler on 12/1/18.
//  Copyright © 2018 jphyr4. All rights reserved.
//

import UIKit

protocol AddTripViewControllerDelegate: class {
    
    func itemSaved(by controller: AddTripViewController, with name: String, title: String, text: String, photo: Data, update: Bool, at: NSIndexPath? )
    
    func cancelButtonPressed(by controller: AddTripViewController)
    
    func deleteRecord(by controller: AddTripViewController, with indexPath: NSIndexPath)
}
