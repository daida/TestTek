//
//  ModelArchiver.swift
//  testTekSwift
//
//  Created by Nicolas Bellon on 28/10/2015.
//  Copyright © 2015 daid. All rights reserved.
//

import UIKit
import Foundation

let kModelFileName : String = "employeList.archive";

class ModelArchiver: NSObject
{
    var cachePath : String;
   
    override init()
    {
        cachePath = "";
        cachePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first!
        cachePath = cachePath + "/" + kModelFileName;
        super.init();
    }
    
    func archiveEmployeList(employeList: [Employe])
    {
        guard employeList.count > 0
        else
        {
            return;
        }
        
        var dest : [EmployeArchivable] = [];
        
        // ici je transforme mon array de struct Employe en classe EmployeArchivable conforme 
        // au protocole NSCoding pour pouvoir les archiver
        
        for emp : Employe in employeList
        {
            let archivable : EmployeArchivable = EmployeArchivable.initWithEmployeStruct(emp);
            dest.append(archivable);
        }
        
        let data : NSData = NSKeyedArchiver.archivedDataWithRootObject(dest);

        if data.length == 0
        {
            print("Une erreur est servenue dans l'archivage des données");
            return;
        }
        
        if data.writeToFile(self.cachePath, atomically: true)
        {
            print("La sauvegarde des donnés a été réalisée avec succès");
        }
        else
        {
            print("Une erreur est servenue dans la sauvegarde des données");
        }
    }
    
    func unarchiveEmployeList() -> [Employe]?
    {
        let archive : [EmployeArchivable]? =  NSKeyedUnarchiver.unarchiveObjectWithFile(self.cachePath) as! [EmployeArchivable]?;

        if archive == nil
        {
            print("Aucune données à désarchiver ");
            return nil;
        }
        
        var dest : [Employe] = [];
        
        for emp : EmployeArchivable in archive!
        {
            let destEmp : Employe = emp.employeStruct();
            dest.append(destEmp);
        }
        
        return dest;
    }
}
