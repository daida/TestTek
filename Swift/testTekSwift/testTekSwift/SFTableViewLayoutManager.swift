//
//  SFTableViewLayoutManager.swift
//  testTekSwift
//
//  Created by Nicolas Bellon on 30/10/2015.
//  Copyright © 2015 daid. All rights reserved.
//

import Foundation
import UIKit


class SFTableViewLayoutManager : SFTableViewLayoutProtocol
{
    static var layoutManager : SFTableViewLayoutProtocol.Type = SFTableViewLayoutStupeFlip.self; //SFTableViewLayout aussi disponible utilise les appels standards à Autolayout

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