//
//  AppDelegate.swift
//  travelogue
//
//  Created by Jacob Paul Hassler on 12/1/18.
//  Copyright © 2018 jphyr4. All rights reserved.
//

import UIKit
import CoreData

class tripsCollectionViewController: UIViewController {
    
    var trips = [TripRecord]()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self as! UICollectionViewDelegate
        collectionView.dataSource = self as! UICollectionViewDataSource
        fetchAllData()
        
        if trips.count > 0 {
            statusLabel.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if sender is NSIndexPath {
            let indexPath = sender as! NSIndexPath
            let destination = segue.destination as! AddTripViewController
            let senderData = trips[indexPath.row]
            destination.delegate = self as! AddTripViewControllerDelegate
            destination.sentData = senderData
            destination.updating = true
            destination.indexPath = indexPath
        }
        else{
            let destination = segue.destination as! AddTripViewController
            destination.delegate = self as! AddTripViewControllerDelegate
        }

    }
    
    func fetchAllData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TripRecord")
        
        do {
            let result = try managedObjectContext.fetch(request)
            trips = result as! [TripRecord]
        } catch {
            print(error)
        }
    }
}

extension CollectionViewController: AddTripViewControllerDelegate {
    
    func cancelButtonPressed(by controller: AddTripViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func itemSaved(by controller: AddTripViewController, with name: String, title: String, text: String, photo: Data, update: Bool, at: NSIndexPath?) {
        
        if update == true {
            if let ip = at {
                let item = trips[ip.row]
                item.name = name
                item.title = title
                item.text = text
                item.photo = photo
                print("existing item updated: ", item)
            }
        }
        else {
            let item = NSEntityDescription.insertNewObject(forEntityName: "TripRecord", into: managedObjectContext) as! TripRecord
            
            item.name = name
            item.title = title
            item.text = text
            item.photo = photo
            print("new item created: ", item)
        }
        
        do {
            try managedObjectContext.save()
        }
        catch {
            print(error)
        }
      
    }
    
    func deleteRecord(by controller: AddTripViewController, with indexPath: NSIndexPath) {
        let item = self.trips[indexPath.row]
        
        self.managedObjectContext.delete(item)
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
        fetchAllData()
        if trips.count < 1 {
            statusLabel.isHidden = false
        }
        else {
            statusLabel.isHidden = true
        }
        UICollectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        
        cell.Name.text = trips[indexPath.row].name
        
        cell.Photo.image = UIImage(data:  trips[indexPath.row].photo!)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "addTripSegue", sender: indexPath)
        
    }
    
    
}


 
    



