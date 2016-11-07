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

    @IBOutlet weak var queueListTableView: UITableView!
    
    // данные от запросов хранятся в них. Они необходимы для формирования таблиц
    //var numberOfRequests: Int?
    var requestList :[Request] = []
    
    enum Action: String {
        case GET_LIST="Action=GET_LIST"
        case GET_INFO="Action=GET_INFO"
        
    }
    
    
    
    //MARK: requestList parser
    
    func parseJSON (dataFromTask: NSData) {
        // функция для получения данных первого tableview

        let readableJSON = JSON(data: dataFromTask)
        
        
        for ind in 0 ..< readableJSON.count
        {
            
            let requestTempVariable = Request()
            
            requestTempVariable.name = readableJSON[ind]["Name"].string
            requestTempVariable.requestNumber = readableJSON[ind]["RequestNumber"].string
            requestTempVariable.requestID = readableJSON[ind]["RequestID"].string
            requestTempVariable.createdAt = readableJSON[ind]["CreatedAt"].string
            
            requestList.append(requestTempVariable)
            
            
            // здесь будем подгружать для каждого элемента
            // детальную информацию
            let field = "Fields[RequestID]=" + requestList[ind].requestID!
            let formedDetailsRequest = formingServerRequest(Action.GET_INFO.rawValue, field: field)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(formedDetailsRequest) {
                data, response, error in
                if error != nil && data == nil {
                    print("Something is going wrong!! - \(error)")
                    return
                }
                
                // unwrapped, because of compiler goes here only if data != nil
                self.parseDetailsJSON(data!)
                
                
                }.resume()
            
            
        }
        
        
        
            dispatch_async(dispatch_get_main_queue()) {
                self.queueListTableView.reloadData()
                
            }
            
        
        
    }

    //MARK: request forming
    
    func formingServerRequest (requestPart: String, field:String)-> NSMutableURLRequest {
        
    
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
        
        return request
        
    }

    
    //MARK: detailsList parser - нужно переставить его в след view
    func parseDetailsJSON (data: NSData){
        
        var detailsJSON = JSON(data: data)
        
        detailsJSON = detailsJSON["Request"]
        
       // print(detailsJSON["UserContactID"]["UserID"]["FullName"])
        
        let detailsTemporaryVar = Details()
        
        detailsTemporaryVar.statusText = detailsJSON["StatusText"].string
        detailsTemporaryVar.description = detailsJSON["Description"].string
        detailsTemporaryVar.solutionDescription = detailsJSON["SolutionDescription"].string
        detailsTemporaryVar.createdAt = detailsJSON["CreatedAt"].string
        detailsTemporaryVar.SLARecoveryTime = detailsJSON["SLARecoveryTime"].string
        detailsTemporaryVar.actualRecoveryTime = detailsJSON["ActualRecoveryTime"].string
        detailsTemporaryVar.fullName = detailsJSON["UserContactID"]["UserID"]["FullName"].string
        
        let checkID = detailsJSON["RequestID"].string
        var ind = 0
        
        while checkID != self.requestList[ind].requestID {
            ind += 1
        }
        
        self.requestList[ind].details = detailsTemporaryVar
        
        
        
      /*
        dispatch_async(dispatch_get_main_queue()) {
            self.queueListTableView.reloadData()
        }
       */ 
        
        
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
        
        let ourCustomCell = queueListTableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) as! CustomCell
        
        
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
    
        let field = "Fields[FilterID]=3CD0E650-4B81-E511-A39A-1CC1DEAD694D"
        
        let formedRequest = formingServerRequest(Action.GET_LIST.rawValue,field: field)
        
        
        // task можно еще больше обезопасить.
        let task = NSURLSession.sharedSession().dataTaskWithRequest(formedRequest) {
            data, response, error in
            if error != nil && data == nil {
                print("Something is going wrong!! - \(error)")
                return
            }
            
            // сюда можно добавить try-catch условие, для обработки неправильно
            // форматированных ответов
            
            // здесь лучше вызывать отдельную функцию парсинга,чем нагромождать task
            // unwrapped, because of compiler goes here only if data != nil
            self.parseJSON(data!)
            
            
            }.resume()
        
    
        // Отображение
        queueListTableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
       // MARK: - SEgue for detailTableview
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let indexPath: NSIndexPath = self.queueListTableView.indexPathForSelectedRow!
        
        let destinationViewController = segue.destinationViewController as! TableViewController
        
        destinationViewController.detailsFromSegue = self.requestList[indexPath.row].details
        
    }
    
    
}



