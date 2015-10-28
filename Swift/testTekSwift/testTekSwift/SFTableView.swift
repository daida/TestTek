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

    
    override init(frame: CGRect)
    {
        scrollView = UIScrollView.init();
        scrollView.frame = frame;
        super.init(frame: frame);
        self.addSubview(scrollView);
    }

    required init?(coder aDecoder: NSCoder)
    {
        scrollView = UIScrollView.init();
        super.init(coder: aDecoder);
    }
    
    private func drawCell()
    {
        var y : CGFloat = 0.0;
        for cell : SFTableViewCell  in self.cells
        {
            cell.frame = CGRectMake(0, y, UIScreen.mainScreen().bounds.size.width, cell.frame.size.height);
            y += (cell.frame.size.height + kCellSpace);
            self.scrollView .addSubview(cell);
        }
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width, y);
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
