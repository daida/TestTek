//
//  ModelArchiver.m
//  testTek
//
//  Created by applecaca on 09/09/15.
//  Copyright © 2015 stupeflix. All rights reserved.
//

#import "ModelArchiver.h"

@interface ModelArchiver()

@property (nonatomic, strong) NSString *employeListLocalPath;

@end


@implementation ModelArchiver

/*  Renvoie le path ou doit etre archiver et désarchiver l'Array de modèle Employe */
- (NSString *)employeListLocalPath
{
    if ( ! _employeListLocalPath)
    {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        _employeListLocalPath = [documentsDirectory stringByAppendingPathComponent:@"employeList"];
    }
    
    return _employeListLocalPath;
}


/*  Récupère depuis une archive une liste d'employe en utilisant le KeyArchiving */
- (NSArray *)unarchiveEmployeList
{
    NSData *data = [NSData dataWithContentsOfFile:self.employeListLocalPath];
    if (data == nil) return nil;
    
    NSArray *dest = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (dest && [dest isKindOfClass:[NSArray class]]) return dest;
    
    return nil;
}

/*  Archive un Array de modele Employe em utilisant le KeyArchiving
    L'archive est placée sur le file system dans le dossier document de l'utilisateur
 */
- (void)archiveEmployeList:(NSArray *)pEmployeList
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:pEmployeList];
    
    [data writeToFile:self.employeListLocalPath atomically:YES];
}

@end
