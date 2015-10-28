//
//  ViewController.swift
//  testTekSwift
//
//  Created by Nicolas Bellon on 27/10/2015.
//  Copyright © 2015 daid. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SFTableViewDataSource
{
    private var TableView : SFTableView;
    private var employeList : [Employe]?;
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        self.TableView = SFTableView.init(frame: UIScreen.mainScreen().bounds);
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    }

    required init?(coder aDecoder: NSCoder)
    {
        self.TableView = SFTableView.init(frame: UIScreen.mainScreen().bounds);
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.addSubview(self.TableView);
        DataController.sharedInstance.fetchEmployeListFromJson { (employe: [Employe]?, error: NSError?) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if employe != nil
                {
                    self.employeList = employe;
                    self.TableView.dataSource = self;
                }
                else
                {
                    let unpackError = error!;
                    
                    var message = "Impossible de télecharger les données";
                    
                    let faillureReason : String? = unpackError.userInfo[NSLocalizedFailureReasonErrorKey] as! String?;
                    
                    if faillureReason != nil
                    {
                        message = faillureReason!;
                    }
                    
                    let alert : UIAlertController = UIAlertController.init(title: "Test Tek Swift", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    let alertAction : UIAlertAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default, handler: nil);
                    alert.addAction(alertAction);
                    self.presentViewController(alert, animated: true, completion: nil);
                }

            });
            
        }
    }

    
    func tableView(tableView: SFTableView, numberOfRowsInSection section: Int) -> Int
    {
        if let employeList = employeList
        {
            return employeList.count;
        }
        
        return 0;
    }
    
    func tableView(tableView: SFTableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> SFTableViewCell
    {
        
        if let employeList = employeList
        {
            let emp : Employe = employeList[indexPath.row];
            let cell : SFTableViewCell? = SFTableViewCell.initWithEmploye(emp);

            if let cell = cell
            {
                return cell;
            }
        }
        
        return SFTableViewCell.init(frame: CGRectZero);
    }
}

