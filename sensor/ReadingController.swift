//
//  ReadingController.swift
//  sensor
//
//  Created by Użytkownik Gość on 26.01.2018.
//  Copyright © 2018 Użytkownik Gość. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ReadingCell: UITableViewCell {
    
}

class ReadingController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var readingTableView: UITableView!
    
    var sensors : [NSManagedObject] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSensors();
        sensorsTableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadSensors() {
        guard let ad = UIApplication.shared.delegate  as? AppDelegate else {
            return
        }
        let moc = ad.persistentContainer.viewContext
        let fr = NSFetchRequest<NSManagedObject>(entityName: "Sensor")
        sensors = try! moc.fetch(fr)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "SensorCell")
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "SensorCell", for: indexPath)
        
        let sensor = sensors[indexPath.row]
        
        cell.textLabel?.text = sensor.value(forKey: "name") as! String?
        cell.detailTextLabel?.text = sensor.value(forKey: "desc") as! String?
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sensors.count
    }
}
