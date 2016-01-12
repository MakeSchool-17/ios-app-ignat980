//
//  PagedGameViewController.swift
//  Improv Guide
//
//  Created by Ignat Remizov on 12/14/15.
//  Copyright © 2015 Ignat Remizov. All rights reserved.
//

import UIKit

class PagedGameViewController: UIPageViewController {
    
    var gameData: NSDictionary?
    var randomData = [String:[String]]()
    var randoms =  [Int:[String]]()
    var generatedRandoms = [Int:String]()
    var currentPageRandomTypes = [String]()
    var currentStep = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let unwrappedRandoms = gameData?["Randoms"] as? NSDictionary {
            for key: AnyObject in unwrappedRandoms.allKeys {
                let stringKey = key as! String
                if let keyValue = unwrappedRandoms[stringKey] {
                    self.randoms[Int(stringKey)!] = keyValue as? [String]
                }
            }
        }
        let format = UnsafeMutablePointer<NSPropertyListFormat>()
        let plistPath = NSBundle.mainBundle().pathForResource("Random", ofType: "plist")!
        let plistXML = NSFileManager.defaultManager().contentsAtPath(plistPath)
        do {
            randomData = try NSPropertyListSerialization.propertyListWithData(plistXML!, options: NSPropertyListReadOptions.MutableContainersAndLeaves, format: format) as! [String:[String]]
        } catch let error {
            print("Error reading plist: \(error), format: \(format)");
        }
        let game = makeGamePage(withStep: 0)
        self.setViewControllers([game], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        game.instructions.setNeedsLayout()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeGamePage(withStep step:Int) -> PageViewController {
        self.currentStep = step
        let game = self.storyboard?.instantiateViewControllerWithIdentifier("pageController") as! PageViewController
        let _ = game.view
        game.step = step
        self.currentStep = step
        self.currentPageRandomTypes = []
        if let randomTypesArray = randoms[step] {
            self.currentPageRandomTypes = randomTypesArray
        }
        game.dataSource = self
        return game
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PagedGameViewController: PageControllerDataSource {
    
    func dataForPage(step: Int) -> String {
        return gameData?.valueForKeyPathWithIndexes("Parts.[\(step)]") as? String ?? ""
    }
    
    func randomElementForPage(step: Int, atIndex:Int) -> String {
        if let temp = randomData[currentPageRandomTypes[atIndex]] {
            self.generatedRandoms[step] = temp~
        }
        return self.generatedRandoms[step]!
    }
    
    func previousRandomForPage(step:Int) -> String? {
        if currentPageRandomTypes.isEmpty {
            return nil
        }
        if let generated = generatedRandoms[step] {
            return generated
        }
        return ""
    }
}

extension PagedGameViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if self.currentStep == 0 {
            return nil
        } else {
            return makeGamePage(withStep: self.currentStep.predecessor())
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if self.currentStep.successor() >= self.gameData?.valueForKeyPath("Parts.@count") as? Int ?? 0 {
            let title = gameData?.valueForKey("Title") as? String
            if  title == "Three Lines" || title == "Three Things" {
                return makeGamePage(withStep: 1)
            }
            return nil
        } else {
            return makeGamePage(withStep: self.currentStep.successor())
        }
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.gameData?.valueForKeyPath("Parts.@count") as? Int ?? 0
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.currentStep
    }
}