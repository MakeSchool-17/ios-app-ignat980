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
    var generatedRandoms = [Int:[String]]()
    var currentPageRandomTypes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        if let unwrappedRandoms = gameData?["Randoms"] as? NSDictionary {
            for key: AnyObject in unwrappedRandoms.allKeys {
                let stringKey = key as! String
                if let keyValue = unwrappedRandoms[stringKey] {
                    randoms[Int(stringKey)!] = keyValue as? [String]
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
        setViewControllers([game], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        game.instructions.setNeedsLayout()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeGamePage(withStep step:Int) -> PageViewController {
        let game = storyboard?.instantiateViewControllerWithIdentifier("pageController") as! PageViewController
        let _ = game.view
        game.step = step
        currentPageRandomTypes = []
        if let randomTypesArray = randoms[step] {
            currentPageRandomTypes = randomTypesArray
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
    
    func instructionForPage(pageController:PageViewController) -> String {
        return gameData?.valueForKeyPathWithIndexes("Parts.[\(pageController.step)]") as? String ?? ""
    }

    func titleForPage(pageController:PageViewController) -> String {
        return gameData?.valueForKeyPathWithIndexes("Title") as? String ?? ""
    }
    
    func randomElementForPage(pageController:PageViewController, atIndex index:Int) -> String {
        if let randomWordsForType = randomData[currentPageRandomTypes[index]] {
            if generatedRandoms[pageController.step] == nil {
                generatedRandoms[pageController.step] = []
            }
            if index >= generatedRandoms[pageController.step]?.count {
                generatedRandoms[pageController.step]?.insert(randomWordsForType~, atIndex: index)
            } else {
                generatedRandoms[pageController.step]?[index] = randomWordsForType~
            }
        }
        return generatedRandoms[pageController.step]![index]
    }
    
    func previousRandomsForPage(pageController:PageViewController) -> [String]? {
        if currentPageRandomTypes.isEmpty {
            return nil
        }
        if let generated = generatedRandoms[pageController.step] {
            return generated
        }
        return []
    }
    
    func randomTypesForPage(pageController: PageViewController) -> [String] {
        return currentPageRandomTypes
    }
    
    func pageShouldPresentRightArrow(pageController: PageViewController) -> Bool {
        if pageController.step.successor() == gameData?.valueForKeyPath("Parts.@count") as! Int && gameData?["Looping"] as! Bool == false {
            return false
        } else {
            return true
        }
    }

    func pageShouldPresentLeftArrow(pageController: PageViewController) -> Bool {
        if pageController.step == 0 {
            return false
        } else {
            return true
        }
    }
}

extension PagedGameViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if (pageViewController.viewControllers![0] as! PageViewController).step == 0 {
            return nil
        } else {
            return makeGamePage(withStep: (pageViewController.viewControllers![0] as! PageViewController).step.predecessor())
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if (pageViewController.viewControllers![0] as! PageViewController).step.successor() >= gameData?.valueForKeyPath("Parts.@count") as? Int ?? 0 {
            if gameData?["Looping"] as! Bool {
                return makeGamePage(withStep: gameData?["LoopIndex"] as! Int)
            }
            return nil
        } else {
            return makeGamePage(withStep: (pageViewController.viewControllers![0] as! PageViewController).step.successor())
        }
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return gameData?.valueForKeyPath("Parts.@count") as? Int ?? 0
    }
    
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return currentStep
//    }
}

extension PagedGameViewController: UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            self.setViewControllers([makeGamePage(withStep: (previousViewControllers[0] as! PageViewController).step)], direction: .Forward, animated: false, completion: nil)
        }
    }
    
    func pageViewControllerPreferredInterfaceOrientationForPresentation(pageViewController: UIPageViewController) -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait
    }
}
    