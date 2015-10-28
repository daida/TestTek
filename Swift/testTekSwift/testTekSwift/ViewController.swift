//
//  ViewController.swift
//  testTekSwift
//
//  Created by Nicolas Bellon on 27/10/2015.
//  Copyright © 2015 daid. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        DataController.sharedInstance.fetchEmployeListFromJson { (list: [Employe]?, error:NSError?) -> Void in
            if let list = list
            {
               print(list);
            }
            else if let error = error
            {
                print(error);
            }
        };
    }

}

