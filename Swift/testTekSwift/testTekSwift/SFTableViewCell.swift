//
//  SFTableViewCell.swift
//  testTekSwift
//
//  Created by Nicolas Bellon on 28/10/2015.
//  Copyright © 2015 daid. All rights reserved.
//

import Foundation
import UIKit


let kCandidateModeOffMargin: CGFloat = 10;
let kCandidateModeOnMargin: CGFloat = 140;

class SFTableViewCell: UIView
{
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var job: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    var previousCell : SFTableViewCell?;
    var nextCell : SFTableViewCell?;
    var cellConstraint: [NSLayoutConstraint] = [];
    var topConstraint: NSLayoutConstraint?

    private func setupEmploye(employe: Employe)
    {
        self.name.text = employe.name;
        self.job.text = employe.job;
        self.email.text = employe.email;
        
        self.spinner.hidden = false;
        self.spinner.startAnimating();
        
        DataController.sharedInstance.fetchImageWithUrl(employe.picture) { (image: UIImage?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.picture.image = image;
                self.spinner.stopAnimating();
                self.spinner.hidden = true;
            })
        }
    }
    
    class func initWithEmploye(employe: Employe) -> SFTableViewCell?
    {
        let dest : SFTableViewCell? = NSBundle.mainBundle().loadNibNamed("SFTableViewCell", owner: nil, options: nil).first as! SFTableViewCell?;

        if dest == nil
        {
            return nil;
        }
        
        dest!.setupEmploye(employe);
        return dest;
    }
    
    class func cellHeight() -> Float
    {
        return 120.0;
    }
    
    class func cellWidth() -> Float
    {
        return Float(UIScreen.mainScreen().bounds.width);
    }

    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
    }

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
    }
    
    func desactivateCandidateMode()
    {
        guard self.topConstraint != nil
        else
        {
            return;
        }
        
        if self.previousCell == nil
        {
            self.topConstraint!.constant = 0;
        }
        else
        {
            self.topConstraint!.constant = kCandidateModeOffMargin;
        }
    }
    
    func activateCandidateMode()
    {
        guard let topConstraint = self.topConstraint
        else
        {
            return;
        }
        
        topConstraint.constant = kCandidateModeOnMargin;
    }
}