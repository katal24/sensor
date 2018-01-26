//
//  ViewController.swift
//  sensor
//
//  Created by Użytkownik Gość on 26.01.2018.
//  Copyright © 2018 Użytkownik Gość. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        generateData();
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func generateData() {
        guard let ad = UIApplication.shared.delegate  as? AppDelegate else {
            return
        }
        
        let moc = ad.persistentContainer.viewContext
        
        let fr = NSFetchRequest<NSManagedObject>(entityName: "Sensor")
        
        var sensors : [NSManagedObject] = [];
        sensors = try! moc.fetch(fr)
        if(sensors.count == 0){
        
            let sensorEntity = NSEntityDescription.entity(forEntityName: "Sensor", in: moc)
        
        
        
        
            for i in 1...20 {
                print(i)
                let sensor = NSManagedObject(entity: sensorEntity!, insertInto: moc)
                sensor.setValue("S \(i)", forKey: "name")
                sensor.setValue("Sensor number \(i)", forKey: "desc")
                try? moc.save()
            }
        }
    }
}

