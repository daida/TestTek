//
//  SFTableViewLayoutProtocol.swift
//  testTekSwift
//
//  Created by Nicolas Bellon on 30/10/2015.
//  Copyright © 2015 daid. All rights reserved.
//

import Foundation
import UIKit

protocol  SFTableViewLayoutProtocol
{
    static func activateSFTableViewSuperViewConstraints(tableView: SFTableView);
    
    static func activateScrollViewContraints(scrollView: UIScrollView);
    
    static func activateInitialConstraintsForCell(cell: SFTableViewCell);
    
    static func activateClassicModeForCell(cell: SFTableViewCell);
    
    static func activateMoovingModeForCell(cell: SFTableViewCell);
    
    static func desactiveContraintsForCell(cell: SFTableViewCell);
}

