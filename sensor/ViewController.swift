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

 
    @IBOutlet weak var numerToGenerate: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateSensors();
       
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func generate(_ sender: Any) {
        let number = (numerToGenerate?.text)!
        let numberInt = Int(number)
        
        generateReadings(number: numberInt ?? 0);
    }
    
    
    @IBAction func deleteReadings(_ sender: Any) {
        var readings : [NSManagedObject] = [];
        guard let ad = UIApplication.shared.delegate  as? AppDelegate else {
            return
        }
        let moc = ad.persistentContainer.viewContext
        let fr = NSFetchRequest<NSManagedObject>(entityName: "Reading")
        readings = try! moc.fetch(fr)
        

        for reading in readings {
            moc.delete(reading)
            try? moc.save()
        }
    }
    
    
    

    func generateSensors() {
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
    
    func generateReadings(number: Int) {
        guard let ad = UIApplication.shared.delegate  as? AppDelegate else {
            return
        }
        let moc = ad.persistentContainer.viewContext
        
        var sensors : [NSManagedObject] = [];
        let fr = NSFetchRequest<NSManagedObject>(entityName: "Sensor")
        sensors = try! moc.fetch(fr)
        
        let readingEntity = NSEntityDescription.entity(forEntityName: "Reading", in: moc)
        
            
        for i in 1...number {
            print("reading \(i)")
            let reading = NSManagedObject(entity: readingEntity!, insertInto: moc)
            reading.setValue(randFloat(), forKey: "value")
            reading.setValue(randDate(), forKey: "timestamp")
            reading.setValue(sensors[randSensorNumber(max: 20)], forKey: "sensor")
            try? moc.save()
        }
    }
    
    func randFloat() -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * 100
    }
    
    func randDate() -> Date {
        let maxSeconds = 31556926;
        let randSec = Int(arc4random_uniform(UInt32(maxSeconds + 1)))
        
        let earlyDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        let date = earlyDate?.addingTimeInterval(TimeInterval(randSec))
        
        return date!
    }
    
    func randSensorNumber(max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max)))
    }
}

