//
//  DataController.m
//  testTek
//
//  Created by applecaca on 09/09/15.
//  Copyright © 2015 stupeflix. All rights reserved.
//

#import "DataController.h"
#import "ModelParser.h"
#import "ModelArchiver.h"
#import "NSString+MD5.h"

const NSString *kJsonUrl = @"http://glhf.francescu.me/team.json";

@interface DataController()

@property (nonatomic, strong) NSURLSessionConfiguration *conf;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) ModelArchiver *modelArchiver;
@property (nonatomic, strong) NSCache       *imageCache;

@end


@implementation DataController

- (NSURLSessionConfiguration *)conf
{
    if ( ! _conf)
    {
        _conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    
    return _conf;
}

- (NSURLSession *)session
{
    if ( ! _session)
    {
        _session = [NSURLSession sessionWithConfiguration:self.conf];
    }
    
    return _session;
}


- (ModelArchiver *)modelArchiver
{
    if ( ! _modelArchiver)
    {
        _modelArchiver = [[ModelArchiver alloc] init];
    }
    
    return _modelArchiver;
}

- (NSCache *)imageCache
{
    if ( ! _imageCache)
    {
        _imageCache =  [[NSCache alloc] init];
    }
    return _imageCache;
}


/*  Télécharge le Json parse les données creer les modèles, archive les modèles sur le file system et renvoie
    un array de modèle Employe.
    Si il y a une archive sur le file system elle est renvoyée sans interroger le réseau
 */
- (void)fetchJsonWithCompletionBlock:(DataControllerModelListCompletionBlock)pCompletionBlock
{
    
    NSArray *localEmployeList = [self.modelArchiver unarchiveEmployeList];

    if (localEmployeList)
    {
        pCompletionBlock(localEmployeList, nil);
        return;
    }
    
    NSURL *url = [NSURL URLWithString:(NSString *)kJsonUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if ( ! pCompletionBlock) return;
        
        if (error)
        {
            pCompletionBlock(nil, error);
            return;
        }
        
        if (data && ! error)
        {
            NSError *jsonParsingError = nil;
            NSDictionary *dico = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            
            if (jsonParsingError)
            {
                pCompletionBlock(nil, jsonParsingError);
                return;
            }
            
            NSArray *employeList = [ModelParser employeModelListWithDictionnary:dico];
            [self.modelArchiver archiveEmployeList:employeList];

            pCompletionBlock(employeList, nil);
            
        }
    }] resume];
}

/*  Cette méthode renvoie une image a partir d'une URL dans un bloc de completion
    La methode cherchera d'abort l'image dans l'instance NSCache imageCache, puis sur le file system
    et enfin si elle ne la trouve pas sur le réseau.
 */
- (void)fetchImageWithURL:(NSString *)pURL AndCompletionBlock:(DataControllerImageCompletionBlock)pCompletionBlock
{
    if (! pURL || [pURL isKindOfClass:[NSString class]] == NO || pURL.length == 0)
    {
        if (pCompletionBlock)
        {
            pCompletionBlock(nil, nil);
        }
        return;
    }
    
    __block UIImage *destImage = nil;
    
    // test cache image
    if ([self.imageCache objectForKey:pURL])
    {
        if (pCompletionBlock)
        {
            pCompletionBlock([self.imageCache objectForKey:pURL], nil);
        }
        return;
    }
    
    NSString *localPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[pURL MD5String]] ;
    
    // test file system
    if ([[NSFileManager defaultManager] fileExistsAtPath:localPath])
    {
        destImage = [UIImage imageWithContentsOfFile:localPath];
        [self.imageCache setObject:destImage forKey:pURL];
        
        if (pCompletionBlock)
        {
            pCompletionBlock(destImage, nil);
            return;
        }
    }
    
    NSURL *url = [NSURL URLWithString:pURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

    // requete reseau
    [[self.session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if (error)
        {
            if (pCompletionBlock)
            {
                pCompletionBlock(nil, error);
            }
            return;
        }
        
        destImage = [UIImage imageWithData:data];
        if (destImage && [destImage isKindOfClass:[UIImage class]])
        {
            [data writeToFile:localPath atomically:YES];
            [self.imageCache setObject:destImage forKey:pURL];
            if (pCompletionBlock)
            {
                pCompletionBlock(destImage, nil);
                return;
            }
            pCompletionBlock(nil, nil);
        }
        
    }] resume];
    
}

+ (instancetype)sharedInstance
{
    static DataController *my = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        my = [[DataController alloc] init];
    });
    return my;
}


@end
