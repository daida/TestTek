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
    
    static var layoutManager : SFTableViewLayoutProtocol.Type{
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
        layoutManager.activateSFTableViewSuperViewConstraints(tableView)
    }
    
    class func activateScrollViewContraints(scrollView: UIScrollView)
    {
        layoutManager.activateScrollViewContraints(scrollView);
    }
    
    class func activateInitialConstraintsForCell(cell: SFTableViewCell)
    {
        layoutManager.activateInitialConstraintsForCell(cell);
    }
    
    class func activateClassicModeForCell(cell: SFTableViewCell)
    {
        layoutManager.activateClassicModeForCell(cell);
    }
    
    class func activateMoovingModeForCell(cell: SFTableViewCell)
    {
        layoutManager.activateMoovingModeForCell(cell);
    }
    
    class func desactiveContraintsForCell(cell: SFTableViewCell)
    {
        layoutManager.desactiveContraintsForCell(cell);
    }
}