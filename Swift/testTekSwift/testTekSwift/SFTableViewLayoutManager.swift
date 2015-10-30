//
//  SFTableViewLayoutManager.swift
//  testTekSwift
//
//  Created by Nicolas Bellon on 30/10/2015.
//  Copyright © 2015 daid. All rights reserved.
//

import Foundation
import UIKit

enum SFTableViewLayoutType
{
    case stupeFlip;
    case standard;
}

class SFTableViewLayoutManager : SFTableViewLayoutProtocol
{
    static var layoutType  : SFTableViewLayoutType = SFTableViewLayoutType.stupeFlip;
    
    private static var layout : SFTableViewLayoutProtocol.Type{
        get{
            switch self.layoutType{
            case .stupeFlip:
                return SFTableViewLayoutStupeFlip.self;
            default:
                return SFTableViewLayout.self;
            }
        }
    }

    class func activateSFTableViewSuperViewConstraints(tableView: SFTableView)
    {
        layout.activateSFTableViewSuperViewConstraints(tableView)
    }
    
    class func activateScrollViewContraints(scrollView: UIScrollView)
    {
        layout.activateScrollViewContraints(scrollView);
    }
    
    class func activateInitialConstraintsForCell(cell: SFTableViewCell)
    {
        layout.activateInitialConstraintsForCell(cell);
    }
    
    class func activateClassicModeForCell(cell: SFTableViewCell)
    {
        layout.activateClassicModeForCell(cell);
    }
    
    class func activateMoovingModeForCell(cell: SFTableViewCell)
    {
        layout.activateMoovingModeForCell(cell);
    }
    
    class func desactiveContraintsForCell(cell: SFTableViewCell)
    {
        layout.desactiveContraintsForCell(cell);
    }
}