//
//  ViewController.swift
//  SomeTaxiService
//
//  Created by Nik on 30.10.16.
//  Copyright © 2016 Gafurov. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var queueListTableview: UITableView!
    
    // данные от запросов хранятся в них. Они необходимы для формирования таблиц
    //var numberOfRequests: Int?
    var requestList :[Request] = []
    
    
    enum Action: String {
        case GET_LIST="Action=GET_LIST"
        case GET_INFO="Action=GET_INFO"
        
    }
    
    
    //MARK: request forming
    
    func postRequest (requestPart: String, field:String) {
        

        // здесь прописаны входные данные авторизации:
        // авторизацию, при необходимости можно добавить, а это данные отправить
        // сюда через segue или тп способом ( например в виде tuple cо след атрибутами)
        let ApiKey = "ApiKey=e8e6a311d54985a067ece5a008da280a"
        let Login = "Login=d_blinov"
        let Password = "Password=Passw0rd"
        let ObjectCode = "ObjectCode=300"
        // общая неизменяемая часть
        
        // формирования запроса
        let postString = NSString(format: "%@&%@&%@&%@&%@&%@", ApiKey,Login,Password,ObjectCode,requestPart,field)
        
        let atrinityURL = NSURL( string: "http://mobile.atrinity.ru/api/service")
        let request = NSMutableURLRequest(URL: atrinityURL!)
        request.HTTPMethod = "POST"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            if error != nil && data == nil {
                print("Something is going wrong!! - \(error)")
                return
            }
            
            // сюда можно добавить try-catch условие, для обработки неправильно
            // форматированных ответов
            
            // здесь лучше вызывать отдельную функцию парсинга
        
                self.parseJSON(data)
            
            
            
            
            
        }.resume()
        
        
    }
    
    
    //MARK: requestList parser
    
    func parseJSON (data: NSData?) {
        // функция для получения данных первого tableview
        
        let readableJSON = JSON(data: data!)
        // self.numberOfRequests = readableJSON.count
        
        
        for ind in 0 ..< readableJSON.count
        {
            
            let requestTemp = Request()
            
            requestTemp.name = readableJSON[ind]["Name"].string
            requestTemp.requestNumber = readableJSON[ind]["RequestNumber"].string
            requestTemp.requestID = readableJSON[ind]["RequestID"].string
            requestTemp.createdAt = readableJSON[ind]["CreatedAt"].string
            
            requestList.append(requestTemp)
            
            
        //  let field = "Fields[RequestID]" + requestList[ind].requestID!
            
            //self.postRequest(Action.GET_INFO.rawValue, field: field, parser: self.parseDetailsJSON)
            
            
          

            
            
        }
        
        dispatch_async(dispatch_get_main_queue()) {
                    self.queueListTableview.reloadData()
            
               }
        
    }
    
    
    
    //MARK: detailsList parser - нужно переставить его в след view
    func parseDetailsJSON (data: NSData? , currentReq: Request?) {
        
        let detailsJSON = JSON(data: data!)
        
        
        
        for ind in 0 ..< detailsJSON.count
        {
            
            let requestTemp = Details()
            
            requestTemp.statusText = detailsJSON[ind]["StatusText"].string
            requestTemp.fullName = detailsJSON[ind]["FullName"].string
            requestTemp.description = detailsJSON[ind]["Description"].string
            requestTemp.solutionDescription = detailsJSON[ind]["SolutionDescription"].string
            requestTemp.createdAt = detailsJSON[ind]["CreatedAt"].string
            
            
            currentReq!.details = requestTemp
            
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.queueListTableview.reloadData()
            
        }
        

        
        
    }
   
    
    
    //MARK: constructing tableview
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestList.count ?? 0
    }
    
    
    // эта функция вызывается каждый раз, в количестве возвращаемого значения 
    // функции tableView (...) -> Int
    // она и формируетвнутренность ячейки
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // initializing new cell
        
        let ourCustomCell = queueListTableview.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) as! CustomCell
       
        
        // customCell - идентификатор ячейки: мы можем настроить ячейку как нам
        // хочется и обозначить его идентификатор таким образом
        // это сэкономит время на оформлении ячейки
        
        
        // adding some text and Name/ RequestNumber / creatiedAt
        
        ourCustomCell.requestNumber.text =  requestList[indexPath.row].requestNumber!
        
        ourCustomCell.name.text = requestList[indexPath.row].name!
        
        ourCustomCell.createdAt.text = requestList[indexPath.row].createdAt!
    
        
        
        return ourCustomCell
    }
    
    

    
    
    
   //MARK: viewDidload
    
    override func viewDidLoad() {

    
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // НУЖНО ВОТКНУТЬ ЭТО КУДА НИБУДЬ
        let field = "Fields[FilterID]=3CD0E650-4B81-E511-A39A-1CC1DEAD694D"
        
        postRequest(Action.GET_LIST.rawValue,field: field)
    
        // Отображение
        queueListTableview.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
       // MARK: - SEgue for detailTableview

        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
           
        //var indexPath: NSIndexPath = (sender?.indexPathForSelectedRow)!
            
        var destinationViewController = segue.destinationViewController as! TableViewController
            
        
            
    }


}
