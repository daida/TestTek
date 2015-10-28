//
//  SFTableViewProtocol.swift
//  testTekSwift
//
//  Created by Nicolas Bellon on 28/10/2015.
//  Copyright © 2015 daid. All rights reserved.
//

import Foundation
import UIKit

protocol SFTableViewDataSource
{
    func tableView(tableView: SFTableView, numberOfRowsInSection section: Int) -> Int;
    func tableView(tableView: SFTableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> SFTableViewCell;
}