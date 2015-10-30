//
//  SFTableViewLayout.swift
//  testTekSwift
//
//  Created by Nicolas Bellon on 29/10/2015.
//  Copyright © 2015 daid. All rights reserved.
//

import Foundation
import UIKit

let kAllConstraints : String = "kAllConstraints";
let kTopConstraint : String = "kTopConstraint";

class SFTableViewLayout : NSObject
{
    class func activateSFTableViewSuperViewConstraints(tableView: SFTableView)
    {
        guard let superView = tableView.superview
        else
        {
            return;
        }
        
        superView.translatesAutoresizingMaskIntoConstraints = false;
        
        var horizontalConstraints : [NSLayoutConstraint];
        var vertivalContstraints  :  [NSLayoutConstraint];
        
        var dest  :  [NSLayoutConstraint];
        
        let views : [String:UIView] = ["tableView": tableView];
        
        
       horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-0-[tableView]-0-|", options: [], metrics: nil, views: views);
        
        vertivalContstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[tableView]-0-|", options: [], metrics: nil, views: views);
        
        dest = horizontalConstraints + vertivalContstraints;
        
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
        
        var horizontalConstraints : [NSLayoutConstraint];
        var vertivalContstraints  :  [NSLayoutConstraint];
        var equalWith : NSLayoutConstraint;
        var equalHeight : NSLayoutConstraint;
        
        var dest  :  [NSLayoutConstraint];
        
        let views : [String:UIView] = ["scrollView": scrollView];
        
        
        horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-0-[scrollView]-0-|", options: [], metrics: nil, views: views);
        
        vertivalContstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[scrollView]-0-|", options: [], metrics: nil, views: views);
        
        equalWith = NSLayoutConstraint.init(item: scrollView.superview!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0);
        
        equalHeight = NSLayoutConstraint.init(item: scrollView.superview!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0.0);
        
        
        dest = horizontalConstraints + vertivalContstraints;
        
        dest.append(equalWith);
        dest.append(equalHeight);
        
        NSLayoutConstraint.activateConstraints(dest);
    }

    class func activateInitialConstraintsForCell(cell: SFTableViewCell)
    {
        guard cell.superview != nil else
        {
            return;
        }
        
        cell.translatesAutoresizingMaskIntoConstraints = false;
        
        var horizontalConstraints : [NSLayoutConstraint];
        var verticalConstraints : [NSLayoutConstraint];
        var dest                : [NSLayoutConstraint];
        let views               : [String:UIView] = ["Cell":cell];
        let metrics             : [String:String] = ["cellHeight":SFTableViewCell.cellHeight().description, "cellWidth":SFTableViewCell.cellWidth().description];
        
        horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-0-[Cell(==cellWidth)]-0-|", options: [], metrics: metrics, views: views);
        verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[Cell(==cellHeight)]", options: [], metrics: metrics, views: views);
        
        dest = horizontalConstraints + verticalConstraints;
        
        NSLayoutConstraint.activateConstraints(dest);
        self.activateClassicModeForCell(cell);
    }
    
    class func activateClassicModeForCell(cell: SFTableViewCell)
    {
        var verticalConstraints : [NSLayoutConstraint];
        var lastCellConstraints : [NSLayoutConstraint] = [];
        let views           : [String: UIView];
        let metrics         : [String:String] = ["spaceBetweenCells":"10"];
        var dest            : [NSLayoutConstraint] = [];
        
        guard cell.superview != nil else
        {
            return;
        }
        
        cell.superview!.removeConstraints(cell.cellConstraint);
        cell.cellConstraint.removeAll();
        
        if cell.previousCell != nil
        {
            views = ["Cell":cell, "PreviousCell":cell.previousCell!];
            verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[PreviousCell]-spaceBetweenCells-[Cell]", options: [], metrics: metrics, views: views)
        }
        else
        {
            views = ["Cell":cell];
            verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[Cell]", options: [], metrics: nil, views: views)

        }
        dest = verticalConstraints;
        
        if cell.nextCell == nil
        {
            lastCellConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[Cell]-0-|", options: [], metrics: nil, views: views);
            dest.appendContentsOf(lastCellConstraints);
        }
        
        if (cell.topConstraint != nil)
        {
            cell.topConstraint = nil;
        }
        
        cell.topConstraint = verticalConstraints.last;
        
        NSLayoutConstraint.activateConstraints(dest);
        cell.cellConstraint = dest;
    }
    
    class func activateMoovingModeForCell(cell: SFTableViewCell)
    {
        guard cell.superview != nil else
        {
            return;
        }
        
        let views : [String:UIView] = ["Cell":cell];

        cell.superview!.removeConstraints(cell.cellConstraint);

        cell.cellConstraint.removeAll();
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[Cell]", options:[],metrics:nil,views:views);
        
        NSLayoutConstraint.activateConstraints(verticalConstraints);
        cell.topConstraint = verticalConstraints.last;
        cell.cellConstraint = verticalConstraints;
    }

}