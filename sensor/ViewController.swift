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
    
    @IBOutlet weak var resultsTextView: UITextView!
    
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
        let startTime = NSDate()

        let number = (numerToGenerate?.text)!
        let numberInt = Int(number)
        
        generateReadings(number: numberInt ?? 0);
        
        // do something
        
        let finishTime = NSDate()
        let measuredTime = finishTime.timeIntervalSince(startTime as Date)
        print("GENERATE \(numberInt!) READINGS - TIME: \(measuredTime)")
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
    
    @IBAction func findTimestamps(_ sender: Any) {
        let startTime = NSDate()
        guard let ad = UIApplication.shared.delegate  as? AppDelegate else {
            return
        }
        let moc = ad.persistentContainer.viewContext

        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Reading")
        fr.resultType = .dictionaryResultType
        let ed = NSExpressionDescription()
        ed.name = "MinimumTimestamp"
        ed.expression = NSExpression(format: "@min.timestamp")
        ed.expressionResultType = .dateAttributeType
        fr.propertiesToFetch = [ed]
        do {
            let minDate = try moc.fetch(fr)
        } catch let error as NSError{
            print(error)
        }
        
        let ed2 = NSExpressionDescription()
        ed2.name = "MaximumTimestamp"
        ed2.expression = NSExpression(format: "@max.timestamp")
        ed2.expressionResultType = .dateAttributeType
        fr.propertiesToFetch = [ed2]
        do {
            fr.propertiesToFetch = [ed]
            let minDateTemp = try moc.fetch(fr)
            print("RESULT:  \(minDateTemp) \n")
            let minDate = (minDateTemp[0] as AnyObject)["MinimumTimestamp"]!!
            fr.propertiesToFetch = [ed2]
            let maxDateTemp = try moc.fetch(fr)
            print("RESULT:  \(maxDateTemp) \n")
            let maxDate = (maxDateTemp[0] as AnyObject)["MaximumTimestamp"]!!
            resultsTextView.text = "Minimum timestamp: \(minDate), maximum timestamp: \(maxDate)"
        } catch let error as NSError{
            print(error)
        }
        
        let finishTime = NSDate()
        let measuredTime = finishTime.timeIntervalSince(startTime as Date)
        print("FIND MAX AND MIN TIME - TIME: \(measuredTime)")
    }
    

    @IBAction func caltulateAvg(_ sender: Any) {
        let startTime = NSDate()
        guard let ad = UIApplication.shared.delegate  as? AppDelegate else {
            return
        }
        let moc = ad.persistentContainer.viewContext
        

        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Reading")
        fr.resultType = .dictionaryResultType
        let ed = NSExpressionDescription()
        ed.name = "avgValues"
        let arguments = NSExpression(forKeyPath: "value")
        ed.expression = NSExpression(forFunction: "average:", arguments: [arguments]);
        ed.expressionResultType = .floatAttributeType
        fr.propertiesToFetch = [ed]
        do {
            let avg = try moc.fetch(fr)
            print("RESULT:  \(avg) \n")
            let result = (avg[0] as AnyObject)["avgValues"]!!
            resultsTextView.text = "Average value of all sensors: \(result)"
        } catch let error as NSError{
            print(error)
        }
        let finishTime = NSDate()
        let measuredTime = finishTime.timeIntervalSince(startTime as Date)
        print("CALCULATE AVERAGE OF ALL SENSORS - TIME: \(measuredTime)")
    }
    
    @IBAction func calculateAvgByGroup(_ sender: Any) {
        let startTime = NSDate()
        guard let ad = UIApplication.shared.delegate  as? AppDelegate else {
            return
        }
        let moc = ad.persistentContainer.viewContext
        
        
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Reading")
        fr.resultType = .dictionaryResultType
        let ed = NSExpressionDescription()
        ed.name = "avgValues"
        let arguments = NSExpression(forKeyPath: "value")
        ed.expression = NSExpression(forFunction: "average:", arguments: [arguments]);
        ed.expressionResultType = .floatAttributeType
        
        let ed2 = NSExpressionDescription()
        ed2.name = "count"
        let arguments2 = NSExpression(forKeyPath: "value")
        ed2.expression = NSExpression(forFunction: "count:", arguments: [arguments2]);
        ed2.expressionResultType = .integer16AttributeType
        

        
        do {
            fr.propertiesToGroupBy = ["sensor"]
            fr.propertiesToFetch = [ed]
            
            let avg = try moc.fetch(fr)
            resultsTextView.text = ""
            print("RESULT:  \(avg) \n")
            
            fr.propertiesToFetch = [ed2]
            let count = try moc.fetch(fr)
            print("RESULT:  \(count) \n")
           
            for i in 0...(avg.count-1) {
                let result1 = (avg[i] as AnyObject)["avgValues"]!!
                let result2 = (count[i] as AnyObject)["count"]!!
                resultsTextView.text = resultsTextView.text + "Sensor \(i): number=\(result2), average=\(result1) \n"
            }
            
        } catch let error as NSError{
            print(error)
        }
        
        let finishTime = NSDate()
        let measuredTime = finishTime.timeIntervalSince(startTime as Date)
        print("CALCULATE AVERAGE BY GROUP - TIME: \(measuredTime)")
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

