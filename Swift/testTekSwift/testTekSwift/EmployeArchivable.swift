//
//  EmployeArchivable.swift
//  testTekSwift
//
//  Created by Nicolas Bellon on 28/10/2015.
//  Copyright © 2015 daid. All rights reserved.
//

import UIKit

class EmployeArchivable: NSObject, NSCoding
{
    var name: String?;
    var picture: String?;
    var job: String?;
    var email: String?;
    
    override init()
    {
        super.init();
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.name = aDecoder.decodeObjectForKey("name") as! String?;
        self.picture = aDecoder.decodeObjectForKey("picture") as! String?;
        self.job = aDecoder.decodeObjectForKey("job") as! String?;
        self.email = aDecoder.decodeObjectForKey("email") as! String?;
        
        super.init();
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(self.name ?? "", forKey: "name");
        aCoder.encodeObject(self.picture ?? "", forKey: "picture");
        aCoder.encodeObject(self.job ?? "", forKey: "job");
        aCoder.encodeObject(self.email ?? "", forKey: "email");
    }
    
    class func initWithEmployeStruct(employe: Employe) -> EmployeArchivable
    {
        let dest = EmployeArchivable.init();
        
        dest.name = employe.name;
        dest.picture = employe.picture;
        dest.job = employe.job;
        dest.email = employe.email;
        
        return dest;
    }
    
    func employeStruct() -> Employe
    {
        
        let dest : Employe = Employe(name: self.name ?? "", email: self.email ?? "", job:self.job ?? "", picture: self.picture ?? "")
        return dest;
    }
}
