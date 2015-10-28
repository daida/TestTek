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
    private let session: NSURLSession
    private let conf   : NSURLSessionConfiguration;
    private let archiver : ModelArchiver;
    private let imageCache : NSCache;
    
    override init()
    {
        self.conf = NSURLSessionConfiguration.defaultSessionConfiguration();
        self.session = NSURLSession.init(configuration: self.conf);
        self.archiver = ModelArchiver.init();
        self.imageCache = NSCache.init();
        
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
    
    
    func fetchEmployeListFromJson(completionClosure: ([Employe]?, NSError?) -> Void)
    {
        let url      :   NSURL = NSURL.init(string: kJsonURL)!;
        let request  :   NSURLRequest = NSURLRequest.init(URL: url);
        var employeList : [Employe]?;
     
        employeList = self.archiver .unarchiveEmployeList();
        
        if (employeList != nil)
        {
            print("liste d'employé récupérée du cache");
            completionClosure(employeList, nil)
            return;
        }
        
        self.session.dataTaskWithRequest(request, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            if let data = data
            {
                do
                {
                    let jsonDico = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! [String:AnyObject]
                    employeList = ModelParser.parseEmployeWithDictionnary(jsonDico);
                    self.archiver.archiveEmployeList(employeList!);
                    completionClosure(employeList!, nil);
                }
                catch let caught as NSError
                {
                    completionClosure(nil, caught);
                }
                return;
            }
            
            if (error != nil)
            {
                completionClosure(nil, error);
            }
            
        }).resume();
    }
    
    func fetchImageWithUrl(url : String, completionClosure : (UIImage?, NSError?)-> Void)
    {
        // test cache NSCache
        var image:UIImage? = self.imageCache.objectForKey(url) as! UIImage?;
        
        if image != nil
        {
            completionClosure(image, nil);
            return;
        }

        let imagePath : String = (NSSearchPathForDirectoriesInDomains(.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first?.stringByAppendingFormat("/%@", url.md5))!;
        
        // test file system
        if NSFileManager.defaultManager().fileExistsAtPath(imagePath) == true
        {
            image = UIImage.init(contentsOfFile: imagePath);
            if image != nil
            {
                self.imageCache.setObject(image!, forKey: url);
                completionClosure(image, nil);
                return;
            }
            else
            {
                do
                {
                    try NSFileManager.defaultManager().removeItemAtPath(imagePath);
                }
                catch
                {
                    print("Suppression echouée erreur: %@", error);
                }
            }
        }
        
        let trueUrl: NSURL? = NSURL.init(string: url);
        
        if trueUrl == nil
        {
            let error : NSError = NSError.init(domain:"com.testTekSwift", code: 255, userInfo: [NSLocalizedFailureReasonErrorKey:"URL invalide"]);
            completionClosure(nil,error);
            return;
        }
        
        let request : NSURLRequest = NSURLRequest.init(URL: trueUrl!);
        
        self.session .dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if error != nil
            {
                completionClosure(nil, error)
                return;
            }
            
            if (data != nil)
            {
                let image : UIImage? = UIImage.init(data: data!);
                
                if image != nil
                {
                    data!.writeToFile(imagePath, atomically: true);
                    self.imageCache.setObject(image!, forKey: url);
                    completionClosure(image, nil);
                    return;
                }
                else
                {
                    let error : NSError = NSError.init(domain:"com.testTekSwift", code: 244, userInfo: [NSLocalizedFailureReasonErrorKey:"Image invalide"]);
                    completionClosure(nil,error);
                    return;
                }
            }
            else
            {
                let error : NSError = NSError.init(domain:"com.testTekSwift", code: 243, userInfo: [NSLocalizedFailureReasonErrorKey:"Aucune donnée"]);
                completionClosure(nil,error);
                return;
            }
        }.resume();
    }
}
