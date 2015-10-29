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

class SFTableView: UIView
{
    var scrollView : UIScrollView;
    private var _dataSource : SFTableViewDataSource?;
    private var cells : [SFTableViewCell] = [];
    
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
        
        SFTableViewLayout.activateScrollViewContraints(self.scrollView);
    }

    required init?(coder aDecoder: NSCoder)
    {
        scrollView = UIScrollView.init();
        super.init(coder: aDecoder);
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
            self.scrollView .addSubview(cell);
            SFTableViewLayout.activateSizeConstraintsForCell(cell);
            cell.cellConstraint = SFTableViewLayout.constraintForCell(cell);
        }
    }
    
    private func setupWithDataSource(dataSource : SFTableViewDataSource)
    {
        let limit : Int = dataSource.tableView(self, numberOfRowsInSection: 0);
        
        for index in 0...limit - 1
        {
            let cell : SFTableViewCell = dataSource.tableView(self, cellForRowAtIndexPath: NSIndexPath(forRow: index, inSection: 0));
            self.cells.append(cell);
        }
        self.drawCell();
    }
}
