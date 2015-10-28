//
//  DataController.swift
//  testTekSwift
//
//  Created by Nicolas Bellon on 27/10/2015.
//  Copyright © 2015 daid. All rights reserved.
//

import UIKit

let kJsonURL: String  = "http://glhf.francescu.me/team.json";

class DataController: NSObject
{
    let session: NSURLSession
    let conf   : NSURLSessionConfiguration;
    
    override init()
    {
        self.conf = NSURLSessionConfiguration.defaultSessionConfiguration();
        self.session = NSURLSession.init(configuration: self.conf);
        super.init();
    }
    
    class var sharedInstance: DataController
    {
        var instance: DataController? = nil
        var onceToken: dispatch_once_t = 0

        dispatch_once(&onceToken)
        {
            instance = DataController()
        }
        
        return instance!
    }
    
    func fetchEmployeListFromJson(completionClosure: [Employe]? -> Void)
    {
        let url      :   NSURL = NSURL.init(string: kJsonURL)!;
        let request  :   NSURLRequest = NSURLRequest.init(URL: url);
        var employeList : [Employe]?;
        
        self.session.dataTaskWithRequest(request, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) in
            if let data = data
            {
                do
                {
                    let jsonDico = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! [String:AnyObject]
                    employeList = ModelParser.parseEmployeWithDictionnary(jsonDico);
                    completionClosure(employeList!);
                }
                catch
                {
                    print("json error: \(error)")
                }
                
            }
            
        }).resume();
    }
}
