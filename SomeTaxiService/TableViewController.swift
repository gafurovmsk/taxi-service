//
//  TableViewController.swift
//  29oct'16_pageviews_andbars
//
//  Created by Nik on 30.10.16.
//  Copyright © 2016 Gafurov. All rights reserved.
//

import UIKit
import SwiftyJSON

class TableViewController: UITableViewController {
    
    var detailsFromSegue: Details?
    
    @IBOutlet weak var statusLabel: UILabel!
  
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var decisionEditable: UITextField!
    
    @IBOutlet weak var createdAtLabel: UILabel!
    
    
    @IBOutlet weak var SLARecoveryTimeLabel: UILabel!
    
    @IBOutlet weak var actualTimeLabel: UILabel!
    
    /*
    @IBOutlet weak var StatusText: UITableViewCell!

    
    @IBOutlet weak var FullName: UITableViewCell!
    
    @IBOutlet weak var Descrption: UITableViewCell!
    
    @IBOutlet weak var SolutionDescription: UITableViewCell!
    
    @IBOutlet weak var CreatedAt: UITableViewCell!
    
    
    @IBOutlet weak var SLARecoveryTime: UITableViewCell!
    
    @IBOutlet weak var ActualRecoveryTime: UITableViewCell!
    */

    override func viewDidLoad() {
        super.viewDidLoad()

        // можно кажды
        
        statusLabel.text =  detailsFromSegue?.statusText
        
        fullNameLabel.text = detailsFromSegue?.fullName
        
        descriptionLabel.text = detailsFromSegue?.description
        
        decisionEditable.text = detailsFromSegue?.solutionDescription
        //SolutionDescription.textInputMode
        
        
        createdAtLabel.text = detailsFromSegue?.createdAt
        
        SLARecoveryTimeLabel.text = detailsFromSegue?.SLARecoveryTime
        
        actualTimeLabel.text = detailsFromSegue?.actualRecoveryTime
        
        
        tableView.dataSource = self
        
        
        
            
    }

    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
  
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
        // class Details имеет 7string properties.
    }

    

}
