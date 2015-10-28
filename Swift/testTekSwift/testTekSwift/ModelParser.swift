//
//  ModelParser.swift
//  testTekSwift
//
//  Created by Nicolas Bellon on 27/10/2015.
//  Copyright © 2015 daid. All rights reserved.
//

import UIKit

class ModelParser: NSObject
{
    
    private class func employeWithDictionnary(dico:[String:String]) -> Employe
    {
        // grace à l'opperateur coalescing si une valeur optinal est nil je fournis une valeur par defaut qui est une chaine vide
        let dest : Employe = Employe(name: dico["name"] ?? "", email: dico["email"] ?? "", job:dico["job"] ?? "", picture: dico["picture"] ?? "")
        return dest;
    }
    
    class func parseEmployeWithDictionnary(dico: [String:AnyObject]) -> [Employe]?
    {
        // Je check le type de dico["data"] si il n'est pas du type [[String:String]] je ne rentre pas dans la méthode
        guard dico["data"] is [[String:String]]
        else
        {
            return nil;
        }
        
        // J'utilise le let unpacking pour unpack dico["data"] qui est optionel dans une constante de type non optionel
        // Je force le downcast de dico["data"] qui était de type anyObject vers une classe plus specifique un array de dictionnaire de string
        let data : [[String:String]]  = dico["data"] as! [[String:String]];

        var destArray: [Employe] = [];
        
        for item: [String:String] in data
        {
            destArray.append(self.employeWithDictionnary(item));
        }
        
        return destArray;
    }
}
