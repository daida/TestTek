//
//  ModelParser.m
//  testTek
//
//  Created by applecaca on 09/09/15.
//  Copyright © 2015 stupeflix. All rights reserved.
//

#import "ModelParser.h"
#import "Employe.h"

@implementation ModelParser

/* Retourne un modèle Employe a partir d'un dictionnaire obtenue depuis le Json */
+ (Employe *)employeWithDictionnary:(NSDictionary *)pDico
{
    Employe *emp = [[Employe alloc] init];
    
    emp.name = pDico[@"name"];
    emp.job = pDico[@"job"];
    emp.email = pDico[@"email"];
    emp.picture = pDico[@"picture"];
    
    return emp;
}


/*  Methode qui renvoie un array de modele Employe depuis le dictionnaire parse du Json
    Ces méthode ne sont pas dans le modéle Employe pour limiter le couplage avec la donnée Json
 */
+ (NSArray *)employeModelListWithDictionnary:(NSDictionary *)pDico
{
    NSArray *dataArray = pDico[@"data"];
    NSMutableArray *dest = [NSMutableArray arrayWithCapacity:0];
    
    [dataArray enumerateObjectsUsingBlock:^(NSDictionary *employeDico, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if (employeDico && [employeDico isKindOfClass:[NSDictionary class]])
        {
            [dest addObject:[ModelParser employeWithDictionnary:employeDico]];
        }
    }];
    
    return dest;
}

@end
