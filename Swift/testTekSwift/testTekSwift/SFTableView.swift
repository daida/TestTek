//
//  SFTableView.swift
//  testTekSwift
//
//  Created by Nicolas Bellon on 28/10/2015.
//  Copyright © 2015 daid. All rights reserved.
//

import Foundation
import UIKit

let kCellSpace : CGFloat = 10.0;
let kAnimDuration: Double = 0.25;
let kBottomInset : CGFloat = 130;
let kTimeInterval: Double = 0.001;

let kAnimScrollOffset : CGFloat = 4.0;
let kTopScrollRatioLimit : CGFloat = 0.15;
let kBottomScrollRatioLimit : CGFloat = 0.85;


class SFTableView: UIView
{
    var scrollView : UIScrollView;
    private var _dataSource : SFTableViewDataSource?;
    private var cells : [SFTableViewCell] = [];
    private var moovingCell : SFTableViewCell?
    private var candidateCell : SFTableViewCell?
    private var touchPoint    : CGPoint = CGPointZero;
    private var timer         : NSTimer?;
    private var touchScreen   : CGPoint = CGPointZero;
    
    var dataSource : SFTableViewDataSource? {
        get
        {
            return self._dataSource;
        }
        set
        {
            self._dataSource = newValue;
            if (self._dataSource != nil)
            {
                self.setupWithDataSource(self.dataSource!);
            }
        }
    }
    
    init()
    {
        scrollView = UIScrollView.init();
        super.init(frame: CGRectNull);
        self.addSubview(scrollView);
        
        SFTableViewLayoutManager.activateScrollViewContraints(self.scrollView);
    }

    required init?(coder aDecoder: NSCoder)
    {
        scrollView = UIScrollView.init();
        super.init(coder: aDecoder);
    }
    
    
    private func getLastCell() -> SFTableViewCell?
    {
        var cell : SFTableViewCell? = self.cells.first;
        while (cell?.nextCell != nil)
        {
            cell = cell?.nextCell;
        }
        return cell;
    }
    
    
    func animScroll()
    {
        if self.touchScreen.y < (self.bounds.size.height * kTopScrollRatioLimit)
        {
            if self.scrollView.contentOffset.y - 1 > 0
            {
                var p : CGPoint = self.touchPoint;
                p.y = p.y - kAnimScrollOffset;
                self.touchPoint = p;
                self.moovingCell!.topConstraint?.constant = self.touchPoint.y - (CGFloat(SFTableViewCell.cellHeight()) / 2.0);
                self.findNewCandidateCell();
                self.scrollView.setContentOffset(CGPointMake(0, self.scrollView.contentOffset.y - kAnimScrollOffset), animated: false)
            }
        }
        
        if self.touchScreen.y > (self.bounds.size.height * kBottomScrollRatioLimit)
        {
            if self.scrollView.contentOffset.y + 1 < (self.scrollView.contentSize.height - self.scrollView.bounds.size.height) + kBottomInset
            {
                var p : CGPoint = self.touchPoint;
                p.y = p.y + kAnimScrollOffset;
                self.touchPoint = p;
                self.moovingCell!.topConstraint?.constant = self.touchPoint.y - (CGFloat(SFTableViewCell.cellHeight()) / 2.0);
                self.findNewCandidateCell();
                self.scrollView.setContentOffset(CGPointMake(0, self.scrollView.contentOffset.y + kAnimScrollOffset), animated: false)
            }
        }

        
    }

    private func startTimer()
    {
        guard self.timer == nil
        else
        {
            return;
        }
        self.timer = NSTimer.init(timeInterval: kTimeInterval, target: self, selector: Selector("animScroll"), userInfo: nil, repeats: true);
        
        if (self.timer == nil)
        {
            return;
        }
        
        NSRunLoop.mainRunLoop().addTimer(self.timer!, forMode: NSDefaultRunLoopMode);
    }

    private func stopTimer()
    {
        guard self.timer != nil else
        {
            return;
        }
        
        self.timer!.invalidate();
        self.timer = nil;
    }


    private func addFakeCell()
    {
         let cell : SFTableViewCell? = self.getLastCell();
         let fakeCell : SFTableViewCell? = SFTableViewCell.initFakeCell();

        guard cell != nil && fakeCell != nil
        else
        {
            return;
        }
        
        cell?.nextCell = fakeCell;
        fakeCell?.previousCell = cell;
        
        self.scrollView.addSubview(fakeCell!);
        
        SFTableViewLayoutManager.desactiveContraintsForCell(cell!);
        
        SFTableViewLayoutManager.activateInitialConstraintsForCell(fakeCell!);
        SFTableViewLayoutManager.activateClassicModeForCell(cell!);
        
        self.cells.append(fakeCell!);
        
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, -kBottomInset, 0);
        
    }

    private func drawCell()
    {
        for var i = 0; i != self.cells.count; i++
        {
            let cell : SFTableViewCell = self.cells[i];
            if i > 0
            {
                cell.previousCell = self.cells[i - 1];
            }
            if (i < self.cells.count - 1)
            {
                cell.nextCell = self.cells[i + 1];
            }
            self.scrollView.addSubview(cell);
            SFTableViewLayoutManager.activateInitialConstraintsForCell(cell);
        }
        self.addFakeCell();
    }
    
    private func cellWithTouch(touch:CGPoint)->SFTableViewCell?
    {
        for cell : SFTableViewCell in self.cells
        {
            if CGRectContainsPoint(cell.frame, touch) && cell.isFakeCell == false
            {
                return cell;
            }
        }
        return nil;
    }
    
    private func cellWithTouchCoverByMoovingCell(touch:CGPoint)->SFTableViewCell?
    {
        for cell : SFTableViewCell in self.cells
        {
            if CGRectContainsPoint(cell.frame, touch) && cell != self.moovingCell
            {
                return cell;
            }
        }
        return nil;
    }

    
    
    private func activateMoovingCellForCell(cell: SFTableViewCell)
    {
        self.moovingCell = cell;
        
        self.desactivateCandidateModeForAllCell();
        
        SFTableViewLayoutManager.desactiveContraintsForCell(cell);
        
        cell.superview!.bringSubviewToFront(cell);
        
        let previousCell : SFTableViewCell? = cell.previousCell;
        let nextCell : SFTableViewCell? = cell.nextCell;
        
        nextCell?.previousCell = previousCell;
        previousCell?.nextCell = nextCell;
        
        if nextCell != nil
        {
            SFTableViewLayoutManager.activateClassicModeForCell(nextCell!);
        }

        if previousCell != nil
        {
            SFTableViewLayoutManager.activateClassicModeForCell(previousCell!);
        }
        
        SFTableViewLayoutManager.activateMoovingModeForCell(cell);
        cell.topConstraint!.constant = self.touchPoint.y - (CGFloat(SFTableViewCell.cellHeight()) / 2.0);
        
        self.candidateCell = self.moovingCell?.nextCell;
        
        self.candidateCell?.activateCandidateMode();
        
        UIView.animateWithDuration(kAnimDuration) { () -> Void in
            self.scrollView .layoutIfNeeded();
        }
    }
    
    
    private func desactivateMoovingCell()
    {
        guard self.moovingCell != nil
        else
        {
            return;
        }
        
        if (self.candidateCell == nil)
        {
            self.moovingCell!.previousCell?.nextCell = self.moovingCell;
            self.moovingCell!.nextCell?.previousCell = self.moovingCell;
            SFTableViewLayoutManager.activateClassicModeForCell(self.moovingCell!);
            if (self.moovingCell!.previousCell != nil)
            {
                SFTableViewLayoutManager.activateClassicModeForCell(self.moovingCell!.previousCell!);
            }
            
            if (self.moovingCell!.nextCell != nil)
            {
                SFTableViewLayoutManager.activateClassicModeForCell(self.moovingCell!.nextCell!);
            }
            
            self.moovingCell = nil;
            self.candidateCell = nil;
            
            UIView.animateWithDuration(kAnimDuration, animations: { () -> Void in
                self.scrollView .layoutIfNeeded();
                self.scrollView.contentInset = (UIEdgeInsetsMake(0, 0, -kBottomInset, 0));
            })
            return;
        }
        
        let previousCell : SFTableViewCell? = self.candidateCell?.previousCell;
        previousCell?.nextCell = self.moovingCell;
        
        self.moovingCell?.previousCell = self.candidateCell?.previousCell;
        self.moovingCell?.nextCell = self.candidateCell;
        
        self.candidateCell?.previousCell?.nextCell = self.moovingCell;
        self.candidateCell?.previousCell = self.moovingCell;
        
        SFTableViewLayoutManager.activateClassicModeForCell(self.moovingCell!);
        SFTableViewLayoutManager.activateClassicModeForCell(self.candidateCell!);
        
        if previousCell != nil
        {
            SFTableViewLayoutManager.activateClassicModeForCell(previousCell!);
        }
        
        self.desactivateCandidateModeForAllCell();
        self.moovingCell = nil;
        self.candidateCell = nil;
        
        UIView.animateWithDuration(kAnimDuration) { () -> Void in
            self.scrollView.layoutIfNeeded();
            self.scrollView.contentInset = (UIEdgeInsetsMake(0, 0, -kBottomInset, 0));
        };
        
    }
    
    
    
    private func desactivateCandidateModeForAllCell()
    {
        for cell:SFTableViewCell in self.cells
        {
            cell.desactivateCandidateMode();
        }
    }
    
    private func activateCandidateModeForCell(cell : SFTableViewCell)
    {
        for currentCell:SFTableViewCell in self.cells
        {
            if (currentCell != cell && currentCell != self.moovingCell)
            {
                currentCell.desactivateCandidateMode();
            }
        }
        cell.activateCandidateMode();
        UIView.animateWithDuration(kAnimDuration) { () -> Void in
            self.layoutIfNeeded();
        };
    }
    
    private func findNewCandidateCell()
    {
        let overlapCell : SFTableViewCell? = self.cellWithTouchCoverByMoovingCell(self.touchPoint);
        
        if overlapCell != nil && overlapCell != self.candidateCell
        {
            self.activateCandidateModeForCell(overlapCell!);
            self.candidateCell = overlapCell;
        }
    }
    
    func didLongTouch(longPress : UILongPressGestureRecognizer)
    {
        self.touchPoint = longPress.locationInView(longPress.view);
        self.touchScreen = longPress.locationInView(self);
        
        switch longPress.state
        {
            case UIGestureRecognizerState.Began :
                self.scrollView.contentInset = (UIEdgeInsetsMake(0, 0, 0, 0));
                self.scrollView.scrollEnabled = false;
                self.candidateCell = nil;
                let cell : SFTableViewCell?  = self.cellWithTouch(self.touchPoint);
                if cell == nil
                {
                    return;
                }
                self.activateMoovingCellForCell(cell!);
                break;
        
        case UIGestureRecognizerState.Changed :
            if self.moovingCell == nil
            {
                return;
            }
            
            self.moovingCell!.topConstraint!.constant = self.touchPoint.y - (CGFloat(SFTableViewCell.cellHeight()) / 2.0);
            self.findNewCandidateCell();
            self.startTimer();
            break;
            
        case UIGestureRecognizerState.Ended:
            self.stopTimer();
            if self.moovingCell == nil
            {
                return;
            }
            self.desactivateMoovingCell();
            self.scrollView.scrollEnabled = true;
        default :
            break;
        }
        
    }
    
    private func setupGestures()
    {
        let longPress : UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action:Selector("didLongTouch:"));
        self.scrollView.addGestureRecognizer(longPress);
    }
    
    private func loadDataWithDataSource(dataSource: SFTableViewDataSource)
    {
        let limit : Int = dataSource.tableView(self, numberOfRowsInSection: 0);
        
        for index in 0...limit - 1
        {
            let cell : SFTableViewCell = dataSource.tableView(self, cellForRowAtIndexPath: NSIndexPath(forRow: index, inSection: 0));
            self.cells.append(cell);
        }

    }
    
    private func setupWithDataSource(dataSource : SFTableViewDataSource)
    {
        self.loadDataWithDataSource(dataSource);
        self.drawCell();
        self.setupGestures();
    }
}
