//
//  SFTableViewCell.m
//  testTek
//
//  Created by applecaca on 09/09/15.
//  Copyright © 2015 stupeflix. All rights reserved.
//

#import "SFTableViewCell.h"
#import "DataController.h"
#import "SFTableViewLayout.h"

const NSUInteger    kCandidateModeOffMargin = 10;
const NSUInteger    kCandidateModeOnMargin = 115;
const CGFloat       kCellHeight            = 95;

@interface SFTableViewCell()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic, strong) NSArray *constraints;
@property (nonatomic, strong) NSLayoutConstraint *topConstraint;
@property (nonatomic, strong) NSLayoutConstraint *botomConstraint;

@property (nonatomic, weak) SFTableViewCell *previousCell;
@property (nonatomic, weak) SFTableViewCell *nextCell;

- (void)activateCandidateMode;
- (void)desactivateCandidateMode;

@end


@implementation SFTableViewCell


/*  Methode de classe qui alloue une instance de SFTableViewCell à partir du xib puis set le modele Employe */
+ (SFTableViewCell *)cellWithEmploye:(Employe *)pEmploye
{
    SFTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"SFTableViewCell" owner:nil options:nil].firstObject;
    [cell configureWithEmploye:pEmploye];
    [cell setTranslatesAutoresizingMaskIntoConstraints:NO];
    return cell;
}


/*  Methode de classe qui renvoie la hauteur d'une cellule utile pour la scrollview avec autolayout */
+ (CGFloat)height
{
    return kCellHeight;
}


/*  Methode de classe qui renvoie la largeur d'une cellule utile pour la scrollview avec autolayout */
+ (CGFloat)width
{
    return [UIScreen mainScreen].bounds.size.width;
}


/* Configure la cellule avec le modèle Employe */
- (void)configureWithEmploye:(Employe *)pEmploye
{
    self.employe = pEmploye;
    if (pEmploye == nil)
    {
        self.name.text = nil;
        self.job.text = nil;
        self.email.text = nil;
        self.spinner.hidden = YES;
        self.imageView.image = nil;
        return;
    }
    self.name.text = pEmploye.name;
    self.job.text = pEmploye.job;
    self.email.text = pEmploye.email;
    
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    [[DataController sharedInstance] fetchImageWithURL:pEmploye.picture AndCompletionBlock:^(UIImage *image, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^
         {
             self.imageView.image = image;
             [self.spinner stopAnimating];
             [self.spinner setHidden:YES];
         });
         
         
     }];
}


/*  Cette méthode permet de set un Dictionnaire qui contient toute les contraintes 
    nécessaire au placement de la cellule (kAllConstraints) mais egallement des pointeurs vers
    les contraintes top et botom car leur constantes seront modifier pour le mode candiate (decallage)
 */
- (void)setConstraintsDictionnary:(NSDictionary *)pDicoContraints
{
    if (pDicoContraints == nil || ! [pDicoContraints isKindOfClass:[NSDictionary class]]) return;
    
    self.constraints = pDicoContraints[kAllConstraints];
    self.topConstraint = pDicoContraints[kTopConstraint];
    self.botomConstraint = pDicoContraints[kBottomConstraint];
}


/*  Active le mode candidate (decallage)
    la constante de la contrainte top prend la valeur 115 soit la taille de la cellule + 2 fois la marge (10x2)
 */
- (void)activateCandidateMode
{
    self.topConstraint.constant = kCandidateModeOnMargin;
}


/*  Desactive le mode candidate (decallage)
    la constante de la contrainte top ou botom reprend sa valeur initiale 10 ou 0 
    si c'est une cellule de bord
 */
- (void)desactivateCandidateMode
{
    self.backgroundColor = [UIColor whiteColor];
    
    if (self.previousCell == nil)
    {
        self.topConstraint.constant = 0;
    }
    else
    {
        self.topConstraint.constant = kCandidateModeOffMargin;
    }
    
    if (self.nextCell == nil)
    {
        self.botomConstraint = 0;
    }
}



@end
