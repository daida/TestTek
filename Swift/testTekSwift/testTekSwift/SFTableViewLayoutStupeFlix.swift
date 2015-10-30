//
//  SFTableViewLayoutStupeFlix.swift
//  testTekSwift
//
//  Created by Nicolas Bellon on 30/10/2015.
//  Copyright © 2015 daid. All rights reserved.
//

import Foundation
import UIKit

class SFTableViewLayoutStupeFlip: SFTableViewLayoutProtocol
{
    class func activateSFTableViewSuperViewConstraints(tableView: SFTableView)
    {
        guard let superView = tableView.superview
            else
        {
            return;
        }
        superView.translatesAutoresizingMaskIntoConstraints = false;
         var dest :  [NSLayoutConstraint] = [];
        
        dest = tableView.sx_leadingSnap();
        dest = dest + tableView.sx_trailingSnap();
        dest = dest + tableView.sx_topSnap(20);
        dest = dest + tableView.sx_bottomSnap();
        
        NSLayoutConstraint.activateConstraints(dest);
        
    }
    
    class func activateScrollViewContraints(scrollView: UIScrollView)
    {
        guard scrollView.superview != nil
            else
        {
            return;
        }
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false;
        scrollView.superview!.translatesAutoresizingMaskIntoConstraints = false;
        
        var dest : [NSLayoutConstraint];
        
        dest = scrollView.sx_leadingSnap();
        dest = dest + scrollView.sx_trailingSnap();
        
        dest = dest + scrollView.sx_topSnap();
        dest = dest + scrollView.sx_bottomSnap();
        
        dest = dest + scrollView.sx_equalWidth(scrollView.superview!);
        dest = dest + scrollView.sx_equalHeigth(scrollView.superview!);
        
        NSLayoutConstraint.activateConstraints(dest);
    }
    
    class func activateInitialConstraintsForCell(cell: SFTableViewCell)
    {
        guard cell.superview != nil else
        {
            return;
        }
        
        cell.translatesAutoresizingMaskIntoConstraints = false;
    
        var dest : [NSLayoutConstraint];
        
        dest = cell.sx_fixedWidth(CGFloat(SFTableViewCell.cellWidth()));
        dest = dest + cell.sx_fixedHeight(CGFloat(SFTableViewCell.cellHeight()));
        dest = dest + cell.sx_leadingSnap();
        dest = dest + cell.sx_trailingSnap();
        
        NSLayoutConstraint.activateConstraints(dest);
        self.activateClassicModeForCell(cell);
    }
    
    class func activateClassicModeForCell(cell: SFTableViewCell)
    {
        guard cell.superview != nil else
        {
            return;
        }
        
        self.desactiveContraintsForCell(cell);
        
        var dest : [NSLayoutConstraint] = [];
        var vertical : [NSLayoutConstraint] = [];
    
        if cell.previousCell != nil
        {
            vertical = cell.sx_verticalAfter(cell.previousCell!, margin: 10);
            dest = dest + vertical;
        }
        else
        {
            vertical = cell.sx_topSnap();
            dest = dest + vertical;
        }
        
        if (cell.nextCell == nil)
        {
            dest = dest + cell.sx_bottomSnap();
        }
        
        cell.topConstraint = vertical.last;
        cell.cellConstraint = dest;
        NSLayoutConstraint.activateConstraints(dest);
    }
    
    class func activateMoovingModeForCell(cell: SFTableViewCell)
    {
        guard cell.superview != nil else
        {
            return;
        }
        
        var dest : [NSLayoutConstraint] = [];
        
        self.desactiveContraintsForCell(cell);
        
        dest = cell.sx_topSnap();
        cell.topConstraint = dest.last;
        cell.cellConstraint = dest;
        NSLayoutConstraint.activateConstraints(dest);
    }
    
    class func desactiveContraintsForCell(cell: SFTableViewCell)
    {
        guard cell.superview != nil else
        {
            return;
        }
        
        if (cell.cellConstraint.count > 0)
        {
            cell.superview!.removeConstraints(cell.cellConstraint);
            cell.cellConstraint.removeAll();
            cell.topConstraint = nil;
        }

    }
}