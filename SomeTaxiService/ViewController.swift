//
//  ViewController.swift
//  29oct'16_pageviews_andbars
//
//  Created by Nik on 30.10.16.
//  Copyright © 2016 Gafurov. All rights reserved.
//

import UIKit
//import SwiftyJSON


class ViewController: UIViewController, UITableViewDataSource {

    
    
    
    let serverQueueList = [ "first thing", "secondThing", "other shut","already tired","ok, that's eniugh"]
    
    let serverRequestIDs = ["14512","3412","5122","31251","7473"]
    

    @IBOutlet weak var queueListTableview: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serverQueueList.count
    }
    
    
    // эта функция вызывается каждый раз, в количестве возвращаемого значения 
    // функции tableView (...) -> Int
    // она и формируетвнутренность ячейки
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // initializing new cell
        let requestListCell:UITableViewCell = queueListTableview.dequeueReusableCellWithIdentifier("Prototype1", forIndexPath: indexPath) 
        // prototype1 - идентификатор ячейки: мы можем настроить ячейку как нам
        // хочется и обозначить его идентификатор таким образом
        // это сэкономит время на оформлении ячейки
        
        // adding some text and Name/ RequestNumber / creatiedAt
        requestListCell.textLabel?.text = serverRequestIDs[indexPath.row] + " : " + serverQueueList[indexPath.row]
        //requestListCell.
        
        return requestListCell
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // здесь прописаны входные данные авторизации:
        // авторизацию, при необходимости можно добавить, а это данные отправить
        // сюда через segue или тп способом ( например в виде tuple cо след атрибутами)
        
        let requestURL = NSURL( string: "http://mobile.atrinity.ru/api/service")
        let request = NSMutableURLRequest(URL: requestURL!)
        request.HTTPMethod = "POST"
        
        let ApiKey = "ApiKey=e8e6a311d54985a067ece5a008da280a"
        let Login = "Login=d_blinov"
        let Password = "Password=Passw0rd"
        let ObjectCode = "ObjectCode=300"
        let Action = "Action=GET_LIST"
        //Строка {field1: value1, field2: value2, …} Сериализованный массив в формате JSON, содержащий названия и значения для полей заявки Fields[FilterID]=3CD0E650-4B81-E511-A39A-1CC1DEAD694D
        let Fields = "Fields=3CD0E650-4B81-E511-A39A-1CC1DEAD694D"
        
        
        let postString = ApiKey+"&"+Login+"&"+Password+"&"+ObjectCode+"&"+Action+"&"+Fields
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            if error != nil && data == nil {
                print("Something is going wrong!! - \(error)")
                return 
            }
          
            // checking response
            // content length in correct request is 99
            print("RESPONSE!!!")
            print(response)
            
           // let readableJSON = JSON(data: data!,options: NSJSONReadingOptions.MutableContainers, error: nil)
           
            
           // readableJSON
            
        }
        
        
        task.resume()
        
        queueListTableview.dataSource = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
