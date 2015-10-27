//
//  SFTableView.m
//  testTek
//
//  Created by applecaca on 09/09/15.
//  Copyright © 2015 stupeflix. All rights reserved.
//

#import "SFTableView.h"
#import "SFTableViewCell.h"
#import "SFTableViewDelegate.h"
#import "SFTableViewLayout.h"

const   CGFloat     kAnimDuration    =   0.25f;
const   CGFloat     kBottomInset     =   105.0f;
const   CGFloat     kTimeInterval    =   0.001f;
const   NSUInteger  kAnimScrollOfset =   4;

const   CGFloat     kTopScrollRatioLimit = 0.15f;
const   CGFloat     kBottomScrollRatioLimit = 0.85;

@interface SFTableView()

@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, assign) NSUInteger nbrCell;

@property (nonatomic, weak) SFTableViewCell *moovingCell;
@property (nonatomic, weak) SFTableViewCell *candidateCell;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CADisplayLink *diplayLink;
@property (nonatomic, assign) CGPoint touchScreen;
@property (nonatomic, assign) CGPoint touchPoint;

@end

@interface SFTableViewCell()

@property (nonatomic, strong) NSArray *constraints;

@property (nonatomic, strong) NSLayoutConstraint *topConstraint;
@property (nonatomic, strong) NSLayoutConstraint *botomConstraint;

@property (nonatomic, weak) SFTableViewCell *previousCell;
@property (nonatomic, weak) SFTableViewCell *nextCell;


- (void)setConstraintsDictionnary:(NSDictionary *)pDicoContraints;
- (void)activateCandidateMode;
- (void)desactivateCandidateMode;

@end

const NSInteger cellSpace = 10;

@implementation SFTableView


- (NSArray *)cells
{
    if (_cells == nil)
    {
        _cells = [NSMutableArray arrayWithCapacity:0];
    }
    return _cells;
}


- (UIScrollView *)scroll
{
    if (_scroll == nil)
    {
        _scroll = [[UIScrollView alloc] init];
    }
    return _scroll;
}


- (NSTimer *)timer
{
    if (_timer == nil)
    {
        _timer = [NSTimer timerWithTimeInterval:kTimeInterval target:self selector:@selector(animScroll) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    
    return _timer;
}

- (void)handleFindCandidateCell
{
    SFTableViewCell *overlapCell = [self cellAtTouch:self.touchPoint CoverByMoovingCell:self.moovingCell];
    
    if (overlapCell != nil && overlapCell != self.candidateCell)
    {
        [self activateCandidateModeForCell:overlapCell];
        self.candidateCell = overlapCell;
    }
}

/*  Cette méthode gère l'animation de la scroll view durant le deplacement de la cellule
    si l'utilisateur se raproche du haut ou du bas de la scroll view la scroll view coulisse de maniere
    à afficher les autres cellules.
 
    Cette méthode est appellée par un timer tant qu'une cellule est sélectionnée.
 */
- (void)animScroll
{
        if (self.touchScreen.y < (self.bounds.size.height * kTopScrollRatioLimit))
        {
            if (self.scroll.contentOffset.y -1 > 0)
            {
                CGPoint p = self.touchPoint;
                p.y = p.y - kAnimScrollOfset;
                self.touchPoint = p;
                self.moovingCell.topConstraint.constant = self.touchPoint.y - ([SFTableViewCell height] / 2.0f);
                [self handleFindCandidateCell];
                [self.scroll setContentOffset:CGPointMake(0, self.scroll.contentOffset.y - kAnimScrollOfset)  animated:NO];

            }
        }
        if (self.touchScreen.y > (self.bounds.size.height * (kBottomScrollRatioLimit)))
        {
            if (self.scroll.contentOffset.y + 1 < (self.scroll.contentSize.height - self.scroll.bounds.size.height) + kBottomInset)
            {
                CGPoint p = self.touchPoint;
                p.y = p.y + kAnimScrollOfset;
                self.touchPoint = p;
                self.moovingCell.topConstraint.constant = self.touchPoint.y - ([SFTableViewCell height] / 2.0f);
                [self handleFindCandidateCell];
                [self.scroll setContentOffset:CGPointMake(0, self.scroll.contentOffset.y + kAnimScrollOfset)  animated:NO];
            }
        }

}



/* Cette méthode renvoie la cellule correspondant au touch utilisateur */
- (SFTableViewCell *)cellWithTouch:(CGPoint)pTouch
{
    for (SFTableViewCell *cell in self.cells)
    {
        if (CGRectContainsPoint(cell.frame, pTouch) && cell.employe)
        {
            return cell;
        }
    }
    
    return nil;
}


/* Cette méthode renvoie la cellule sous la cellule séléctionnée c'est cette cellule la qui devra se décaller */
- (SFTableViewCell *)cellAtTouch:(CGPoint)pTouch CoverByMoovingCell:(SFTableViewCell *)pMoovingCell
{
    for (SFTableViewCell *cell in self.cells)
    {
        if (CGRectContainsPoint(cell.frame, pTouch) && cell != pMoovingCell)
        {
            return cell;
        }
    }
    
    return nil;
}


- (SFTableViewCell *)getLastCell
{
    SFTableViewCell *cell = self.cells.firstObject;
    while (cell.nextCell != nil)
    {
        cell = cell.nextCell;
    }
    return cell;
}


- (void)activateMoovingCellForCell:(SFTableViewCell *)pCell
{
    if (pCell == nil || [pCell isKindOfClass:[SFTableViewCell class]] == NO) return;
    
    self.moovingCell = pCell;
    
    [self desactivateCandidateModeForAllCell];
    
    [self.scroll removeConstraints:pCell.constraints];
    [self.scroll removeConstraints:pCell.nextCell.constraints];
    [self.scroll removeConstraints:pCell.previousCell.constraints];
    
    SFTableViewCell *previousCell = pCell.previousCell;
    SFTableViewCell *nextCell = pCell.nextCell;
    
    nextCell.previousCell = previousCell;
    previousCell.nextCell = nextCell;
    
    [nextCell setConstraintsDictionnary:[SFTableViewLayout constraintWithCell:nextCell]];
    [previousCell setConstraintsDictionnary:[SFTableViewLayout constraintWithCell:previousCell]];
    [self.moovingCell setConstraintsDictionnary:[SFTableViewLayout moovingConstraintWithCell:self.moovingCell]];
    
    if (nextCell)
    {
        [self.scroll addConstraints:nextCell.constraints];
    }
    
    if (previousCell)
    {
        [self.scroll addConstraints:previousCell.constraints];
    }
    
    [self.scroll addConstraints:self.moovingCell.constraints];
    
    self.moovingCell.topConstraint.constant = self.touchPoint.y - ([SFTableViewCell height] / 2.0f);
    [self.scroll bringSubviewToFront:self.moovingCell];
    
    self.candidateCell = self.moovingCell.nextCell;
    
    [self.candidateCell activateCandidateMode];
    
    [UIView animateWithDuration:kAnimDuration animations:^
     {
         [self.scroll layoutIfNeeded];
     }];
}


- (void)desactivateMoovingCell
{
    if (self.moovingCell == nil) return;
    
    if (self.candidateCell == nil)
    {
        self.moovingCell.previousCell.nextCell = self.moovingCell;
        self.moovingCell.nextCell.previousCell = self.moovingCell;
        
        [self.scroll removeConstraints:self.moovingCell.constraints];
        [self.scroll removeConstraints:self.moovingCell.previousCell.constraints];
        [self.scroll removeConstraints:self.moovingCell.nextCell.constraints];
        
        [self.moovingCell setConstraintsDictionnary:[SFTableViewLayout constraintWithCell:self.moovingCell]];
        [self.moovingCell.previousCell setConstraintsDictionnary:[SFTableViewLayout constraintWithCell:self.moovingCell.previousCell]];
        [self.moovingCell.nextCell setConstraintsDictionnary:[SFTableViewLayout constraintWithCell:self.moovingCell.nextCell]];
        
        [self.scroll addConstraints:self.moovingCell.constraints];
        
        if (self.moovingCell.previousCell)
        {
            [self.scroll addConstraints:self.moovingCell.previousCell.constraints];
        }
        
        if (self.moovingCell.nextCell)
        {
            [self.scroll addConstraints:self.moovingCell.nextCell.constraints];
        }
        
        self.moovingCell = nil;
        self.candidateCell = nil;
        [UIView animateWithDuration:kAnimDuration animations:^
         {
             [self.scroll layoutIfNeeded];
             [self.scroll setContentInset:UIEdgeInsetsMake(0, 0, -kBottomInset, 0)];
         } completion:^(BOOL finished)
         {
         }];
        
        return;
    }
    
    SFTableViewCell *previousCell = self.candidateCell.previousCell;
    previousCell.nextCell = self.moovingCell;
    
    self.moovingCell.previousCell = self.candidateCell.previousCell;
    self.moovingCell.nextCell = self.candidateCell;
    
    self.candidateCell.previousCell.nextCell = self.moovingCell;
    
    self.candidateCell.previousCell = self.moovingCell;
    
    
    [self.scroll removeConstraints:self.candidateCell.constraints];
    [self.scroll removeConstraints:self.moovingCell.constraints];
    [self.scroll removeConstraints:previousCell.constraints];
    
    [self.moovingCell setConstraintsDictionnary:[SFTableViewLayout constraintWithCell:self.moovingCell]];
    [self.candidateCell setConstraintsDictionnary:[SFTableViewLayout constraintWithCell:self.candidateCell]];
    [previousCell setConstraintsDictionnary:[SFTableViewLayout constraintWithCell:previousCell]];
    
    [self.scroll addConstraints:self.moovingCell.constraints];
    [self.scroll addConstraints:self.candidateCell.constraints];
    
    if (previousCell)
    {
        [self.scroll addConstraints:previousCell.constraints];
    }
    
    [self desactivateCandidateModeForAllCell];
    
    self.moovingCell = nil;
    self.candidateCell = nil;
    [UIView animateWithDuration:kAnimDuration animations:^
     {
         [self.scroll setContentInset:UIEdgeInsetsMake(0, 0, -kBottomInset, 0)];
         [self.scroll layoutIfNeeded];
     }completion:^(BOOL finished) {
     }];

}


/*
 Gestion du déplacement de cellules
 
 Toutes les cellules ont un pointeur vers la cellule precedente et suivante.
 Lorsque une cellule est selectionnée par la gesture long press on extrait la cellule selectionnée
 de la chaine et on racorde la cellule suivante et precedente ensemble.
 
 La cellule selectionnée ce ballade en suivant le doigt, si elle rencontre une autre cellule
 celle ci ce met en mode "candidate" elle se décalle pour laisser la place à la cellule selectionnée.
 
 On sauvegarde la cellule qui s'est décallée.
 
 Une fois la gesture terminée on remet la cellule séléctionnée dans la chaine juste avant la cellule qui c'etait décallée.
 
 */
- (void) didLongTouch:(UILongPressGestureRecognizer *)pLongPress
{
    self.touchPoint = [pLongPress locationInView:pLongPress.view];
    self.touchScreen = [pLongPress locationInView:self];
    
    if (pLongPress.state == UIGestureRecognizerStateBegan)
    {
        [self.scroll setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        self.scroll.scrollEnabled = NO;
        self.candidateCell =nil;
        SFTableViewCell *cell = [self cellWithTouch:self.touchPoint];
        if (cell == nil) return;
        [self activateMoovingCellForCell:cell];

    }
    else if (pLongPress.state == UIGestureRecognizerStateChanged)
    {
        if (self.moovingCell == nil) return;
        
        self.moovingCell.topConstraint.constant = self.touchPoint.y - ([SFTableViewCell height] / 2.0f);
        [self handleFindCandidateCell];
        [self.timer fire];
        
    }
    else if (pLongPress.state == UIGestureRecognizerStateEnded)
    {
        [self.timer invalidate];
        self.timer = nil;
        if (self.moovingCell == nil) return;
        [self desactivateMoovingCell];
        self.scroll.scrollEnabled = YES;
    }
}


/* Cette méthode active le mode candidate (decallage) pour une cellule passée
    en parametre et désactive les autres
 */
- (void)activateCandidateModeForCell:(SFTableViewCell *)pCell
{
    if (pCell == nil) return;
    
    for (SFTableViewCell *cell in self.cells)
    {
        if (cell != pCell && cell != self.moovingCell)
        {
            [cell desactivateCandidateMode];
        }
    }
    
    [pCell activateCandidateMode];
    
    [UIView animateWithDuration:kAnimDuration animations:^
     {
         [self.scroll layoutIfNeeded];
     }];
}


/* Désactive le mode candidate (decallage) pour toute les cellules */
- (void)desactivateCandidateModeForAllCell
{
    for (SFTableViewCell *cell in self.cells)
    {
        [cell desactivateCandidateMode];
    }
}


/* Initialise la gesture LongPress */
- (void)setupGestures
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongTouch:)];
    [self.scroll addGestureRecognizer:longPress];
}


/*  Ajoute les cellules dans la scrollView, set les contraintes et les previous/next cellule
    pour chaques cellules
 */
- (void)drawCells
{
    for (UIView *aView in self.scroll.subviews)
    {
        if ([aView isKindOfClass:[SFTableViewCell class]])
        {
            [aView removeFromSuperview];
        }
    }
    
    for (NSInteger i = 0; i != self.nbrCell; i++)
    {
        
        SFTableViewCell *cell = self.cells[i];
        [self.scroll addSubview:cell];
        
        if (i > 0)
        {
            cell.previousCell = self.cells[i - 1];
        }
        
        if (i < self.nbrCell - 1)
        {
            cell.nextCell = self.cells[i + 1];
        }
        
        [cell setConstraintsDictionnary:[SFTableViewLayout constraintWithCell:cell]];
        
        [self.scroll addConstraints:cell.constraints];
    }
    
    SFTableViewCell *lastCell = [self getLastCell];
    SFTableViewCell *fakeCell = [SFTableViewCell cellWithEmploye:nil];
    lastCell.nextCell = fakeCell;
    fakeCell.previousCell = lastCell;
    
    [self.scroll removeConstraints:lastCell.constraints];
    [self.scroll addSubview:fakeCell];
    
    [lastCell setConstraintsDictionnary:[SFTableViewLayout constraintWithCell:lastCell]];
    [fakeCell setConstraintsDictionnary:[SFTableViewLayout constraintWithCell:fakeCell]];
    
    [self.scroll addConstraints:lastCell.constraints];
    [self.scroll addConstraints:fakeCell.constraints];
    
    [self.cells addObject:fakeCell];
    
    [self.scroll setContentInset:UIEdgeInsetsMake(0, 0, -kBottomInset, 0)];
}


/* Interroge le delegate et recupere les cellules */
- (void)loadData
{
    self.nbrCell = [_delegate tableView:self numberOfRowsInSection:0];
    [self.cells removeAllObjects];
    
    for (NSInteger i = 0; i != self.nbrCell; i++)
    {
        NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
        SFTableViewCell *cell = [self.delegate tableView:self cellForRowAtIndexPath:path];
        
        cell.previousCell = nil;
        cell.nextCell = nil;
        
        [self.cells addObject:cell];
    }
    
}


- (void)setDelegate:(id<SFTableViewDelegate>)delegate
{
    _delegate = delegate;
    if (_delegate != nil && [_delegate conformsToProtocol:@protocol(SFTableViewDelegate)])
    {
        [self loadData];
        [self drawCells];
        [self setupGestures];
    }
}


- (void) awakeFromNib
{
    [self addSubview:self.scroll];
    [self.scroll setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[SFTableViewLayout scrollConstraintsWithScrollView:self.scroll]];
}


@end
