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
                instructions.attributedText = NSMutableAttributedString(string: (dataSource?.instructionForPage(self))!, attributes: bodyAttributes)
                if let random = dataSource?.previousRandomsForPage(self) {
                    var endString:String
                    if random.isEmpty {
                        endString = "or generate here"
                    } else {
                        endString = random.joinWithSeparator("\n")
                    }
                    let attributedInstructions = NSMutableAttributedString(attributedString: instructions.attributedText)
                    var appendedRandom = NSMutableAttributedString()
                    if random.isEmpty {
                        appendedRandom = NSMutableAttributedString(string: endString, attributes: bodyAttributes + [NSLinkAttributeName: "0"])
                    } else {
                        if dataSource?.titleForPage(self) == "Good Cop, Bad Cop"{
                            for (index, word) in random.enumerate() {
                                switch index {
                                case 0:
                                    appendedRandom.appendAttributedString(NSAttributedString(string: "The Criminal committed ", attributes: bodyAttributes))
                                case 1:
                                    appendedRandom.appendAttributedString(NSAttributedString(string: "\nwith ", attributes: bodyAttributes))
                                case 2:
                                    appendedRandom.appendAttributedString(NSAttributedString(string: "\nin ", attributes: bodyAttributes))
                                default:
                                    break
                                }
                                appendedRandom.appendAttributedString(NSAttributedString(string: word, attributes: bodyAttributes + [NSLinkAttributeName: "\(index)", NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]))
                            }
                        } else {
                            for (index, word) in random.enumerate() {
                                appendedRandom.appendAttributedString(NSAttributedString(string: word, attributes: bodyAttributes + [NSLinkAttributeName: "\(index)", NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]))
                            }
                        }
                    }
                    instructions.attributedText = attributedInstructions + "\n" + appendedRandom
                }
            }
        }
    }
    
    let paragraphStyle = NSMutableParagraphStyle()
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
        dismissViewControllerAnimated(true, completion: nil)
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
        if dataSource?.previousRandomsForPage(self) != nil {
            let randomString = dataSource?.randomElementForPage(self, atIndex: Int(URL.absoluteString)!) ?? ""
            let range = NSString(string:textView.attributedText.string).rangeOfString(dataSource!.instructionForPage(self))
            let instructionText = textView.attributedText[range]
            let texts = textView.attributedText.string.componentsSeparatedByString("\n")
            let linkAttributes = bodyAttributes + [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
            var attributedRandomString = NSMutableAttributedString()
            if texts.count > 2 {
                let generatedWords = dataSource!.previousRandomsForPage(self)!
                for (index, word) in generatedWords.enumerate() {
                    let attributedWord:NSAttributedString
                    let title = dataSource?.titleForPage(self)
                    if title == "Good Cop, Bad Cop" {
                        switch index {
                        case 0:
                            attributedRandomString.appendAttributedString(NSAttributedString(string: "The Criminal committed ", attributes: bodyAttributes))
                        case 1:
                            attributedRandomString.appendAttributedString(NSAttributedString(string: "\nwith ", attributes: bodyAttributes))
                        case 2:
                            attributedRandomString.appendAttributedString(NSAttributedString(string: "\nin ", attributes: bodyAttributes))
                        default:
                            break
                        }
                    }
                    if index == Int(URL.absoluteString)! {
                        attributedWord = NSAttributedString(string: randomString, attributes: linkAttributes + [NSLinkAttributeName: "\(index)"])
                    } else {
                        attributedWord = NSAttributedString(string: word, attributes: linkAttributes + [NSLinkAttributeName:"\(index)"])
                    }
                    attributedRandomString.appendAttributedString(attributedWord)
                    if title != "Good Cop, Bad Cop" && index < generatedWords.count - 1 {
                        attributedRandomString.appendAttributedString(NSAttributedString(string: "\n", attributes: bodyAttributes))
                    }
                }
            } else {
                if dataSource?.titleForPage(self) == "Good Cop, Bad Cop" {
                    for index in 0...2 {
                        switch index {
                        case 0:
                            attributedRandomString.appendAttributedString(NSAttributedString(string: "The Criminal committed ", attributes: bodyAttributes))
                        case 1:
                            attributedRandomString.appendAttributedString(NSAttributedString(string: "with ", attributes: bodyAttributes))
                        case 2:
                            attributedRandomString.appendAttributedString(NSAttributedString(string: "in ", attributes: bodyAttributes))
                            
                        default:
                            break
                        }
                        attributedRandomString.appendAttributedString(NSAttributedString(string: (dataSource?.randomElementForPage(self, atIndex: index))! + "\n", attributes: linkAttributes + [NSLinkAttributeName: "\(index)"]))
                    }
                } else {
                    attributedRandomString = NSMutableAttributedString(string: randomString, attributes: linkAttributes + [NSLinkAttributeName: "0"])
                }
            }
            textView.attributedText = instructionText + "\n" + attributedRandomString
            textView.sizeToFit()
            instructionHeight.constant = textView.frame.height
            textView.setNeedsLayout()
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
    func instructionForPage(pageController: PageViewController) -> String
    func titleForPage(pageController: PageViewController) -> String
    func randomElementForPage(pageController: PageViewController, atIndex index:Int) -> String
    func previousRandomsForPage(pageController: PageViewController) -> [String]?
    func randomTypesForPage(pageController: PageViewController) -> [String]
}
