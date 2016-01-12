//
//  PageViewController.swift
//  Improv Guide
//
//  Created by Ignat Remizov on 12/14/15.
//  Copyright © 2015 Ignat Remizov. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {
    
    @IBOutlet var instructions: UITextView!
    @IBOutlet var instructionHeight: NSLayoutConstraint!
    @objc @IBOutlet weak var dataSource: PageControllerDataSource? {
        didSet {
            if dataSource != nil {
                instructions.attributedText = NSMutableAttributedString(string: (dataSource?.dataForPage(step))!, attributes: bodyAttributes)
                if let random = dataSource?.previousRandomForPage(step) {
                    var endString:String
                    if random == "" {
                        endString = "or generate here"
                    } else {
                        endString = random
                    }
                    let attributedInstructions = NSMutableAttributedString(attributedString: instructions.attributedText)
                    let appenededRandom = NSMutableAttributedString(string: endString, attributes: bodyAttributes + [NSLinkAttributeName: ""])
                    instructions.attributedText = attributedInstructions + "\n" + appenededRandom
                }
            }
        }
    }
    
    let paragraphStyle = NSMutableParagraphStyle()
    
    var randomData: NSDictionary!
    var step:Int = 0
    private var bodyAttributes:[String:AnyObject] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paragraphStyle.alignment = .Center
        bodyAttributes = [NSFontAttributeName:UIFont.systemFontOfSize(36), NSParagraphStyleAttributeName: paragraphStyle]
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        instructions.sizeToFit()
        instructionHeight.constant = instructions.frame.height
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        instructions.sizeToFit()
    }
    
    
    @IBAction func goBack(sender:UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
//        instructionHeight.constant = instructions.size
//    }

}

extension PageViewController:UITextViewDelegate {
    
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        if dataSource?.previousRandomForPage(step) != nil {
            let randomString = dataSource?.randomElementForPage(step, atIndex: 0) ?? ""
            let range = NSString(string:textView.attributedText.string).rangeOfString(dataSource!.dataForPage(step))
            let instructionText = NSMutableAttributedString(attributedString: textView.attributedText[range])
            let linkAttributes = textView.attributedText»(range.endIndex + 2)
            let bodyAttributes = textView.attributedText»(0)
            let attributedRandomString = NSMutableAttributedString(string: randomString, attributes: linkAttributes)
            textView.attributedText = instructionText + NSMutableAttributedString(string: "\n", attributes: bodyAttributes) + attributedRandomString
        }
        return false
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        if textView.selectedRange.length != 0 {
            textView.selectedRange = NSRange(location: 0, length: 0)
        }
    }
}


@objc protocol PageControllerDataSource:NSObjectProtocol {
    func dataForPage(step:Int) -> String
    func randomElementForPage(step:Int, atIndex:Int) -> String
    func previousRandomForPage(step:Int) -> String?
}
