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
    
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var sensor: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    
}

class ReadingController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var readingTableView: UITableView!
    
    var readings : [NSManagedObject] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadReadings();
    //   sensorsTableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadReadings();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadReadings() {
        
        guard let ad = UIApplication.shared.delegate  as? AppDelegate else {
            return
        }
        let moc = ad.persistentContainer.viewContext
        let fr = NSFetchRequest<NSManagedObject>(entityName: "Reading")
        readings = try! moc.fetch(fr)
        readingTableView.reloadData()
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "SensorCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReadingCell", for: indexPath) as! ReadingCell
        
        let reading = readings[indexPath.row]
        
        let value = reading.value(forKey: "value")!
        cell.value.text = "\(value)"
        let date = reading.value(forKey: "timestamp")!
        cell.timestamp.text =  "\(date)"
        let sensor = reading.value(forKey: "sensor")!
        cell.sensor.text = "\((sensor as! Sensor).name!)"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return readings.count
    }
}
