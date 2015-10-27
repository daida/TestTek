//
//  SFTableViewLayout.m
//  testTek
//
//  Created by Nicolas Bellon on 09/09/2015.
//  Copyright © 2015 stupeflix. All rights reserved.
//

#import "SFTableViewLayout.h"
#import "SFTableViewCell.h"

const NSString  *kAllConstraints    =  @"kAllConstraints";
const NSString  *kTopConstraint     =  @"kTopConstraint";
const NSString  *kBottomConstraint  =  @"kBottomConstraint";

@interface SFTableViewCell()

@property (nonatomic, weak) SFTableViewCell *previousCell;
@property (nonatomic, weak) SFTableViewCell *nextCell;

@end

@implementation SFTableViewLayout


/*  Dictionnaire de contraites de placement d'une cell dans la scrollview.
    En fonction de ses pointeurs previousCell et nextCell ses contraintes seront differentes
 */
+ (NSDictionary *)constraintWithCell:(SFTableViewCell *)pCell
{
    if (pCell == nil) return nil;
    
    NSMutableArray *dest =[NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary *destDico = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSArray *verticalConstraints = nil;
    NSArray *cellHeight = nil;
    NSArray *horizontalConstraints = nil;
    NSArray *lastCellConstraints = nil;
    
    horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"[Cell(==heightWidth)]" options:0 metrics:@{@"heightWidth":[NSString stringWithFormat:@"%f", [SFTableViewCell width]]}
                                                                      views:@{@"Cell":pCell}];
    
    cellHeight = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[Cell(==heightSize)]" options:0 metrics:@{@"heightSize":[NSString stringWithFormat:@"%f", [SFTableViewCell height]]} views:@{@"Cell":pCell}];
    
    if (pCell.previousCell != nil)
    {
        verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[PreviousCell]-spaceBetweenCells-[Cell]" options:0 metrics:@{@"spaceBetweenCells":@"10"} views:@{@"Cell":pCell, @"PreviousCell":pCell.previousCell}];
    }
    else
    {
        verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[Cell]" options:0 metrics:0 views:@{@"Cell":pCell}];
    }
    
    if (pCell.nextCell == nil)
    {
        lastCellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[Cell]-0-|" options:0 metrics:0 views:@{@"Cell":pCell}];
    }
    
    [dest addObjectsFromArray:horizontalConstraints];
    [dest addObjectsFromArray:cellHeight];
    [dest addObjectsFromArray:verticalConstraints];
    
    if (lastCellConstraints)
    {
        [dest addObjectsFromArray:lastCellConstraints];
    }
    [destDico setObject:dest.copy forKey:kAllConstraints];
    [destDico setObject:verticalConstraints.lastObject forKey:kTopConstraint];
    
    if (lastCellConstraints)
    {
        [destDico setObject:lastCellConstraints.lastObject forKey:kBottomConstraint];
    }
    
    return destDico;
}


/*  Dictionnaire de contraintes pour le placement de la vue en cours de mouvement
    Lors de son déplacement pendant la gesture, la cellule reçoit un nouveau set de contraintes
    qui la lie à la scroll view depuis le haut de la vue.
    C'est la constante de cette contrainte qui sera modifiée pour suivre le doigt
 */
+ (NSDictionary *)moovingConstraintWithCell:(SFTableViewCell *)pCell
{
    NSArray *horizontalConstraints = nil;
    NSArray *cellHeight = nil;
    NSArray *verticalConstraints = nil;
    NSMutableArray *allConstraints = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableDictionary *dico = [NSMutableDictionary dictionaryWithCapacity:0];
    
    horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"[Cell(==heightWidth)]" options:0 metrics:@{@"heightWidth":[NSString stringWithFormat:@"%f", [SFTableViewCell width]]} views:@{@"Cell":pCell}];
    
    cellHeight = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[Cell(==heightSize)]" options:0 metrics:@{@"heightSize":[NSString stringWithFormat:@"%f", [SFTableViewCell height]]} views:@{@"Cell":pCell}];
    
    verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[Cell]" options:0 metrics:0 views:@{@"Cell":pCell}];
    
    [allConstraints addObjectsFromArray:horizontalConstraints];
    [allConstraints addObjectsFromArray:cellHeight];
    [allConstraints addObjectsFromArray:verticalConstraints];
    
    dico[kAllConstraints] = allConstraints.copy;
    dico[kTopConstraint] = verticalConstraints.lastObject;
    
    return dico;
}


/* Array de contraintes pour le placement de la scroll view */
+ (NSArray *)scrollConstraintsWithScrollView:(UIScrollView *)pScrollView
{
    NSMutableArray *dest = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[scrollView]-0-|" options:0 metrics:0 views:@{@"scrollView":pScrollView}];
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[scrollView]-0-|" options:0 metrics:0 views:@{@"scrollView":pScrollView}];
    
    [dest addObjectsFromArray:horizontalConstraints];
    [dest addObjectsFromArray:verticalConstraints];
    
    return dest;
}


@end
