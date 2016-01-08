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
    var randomData: NSDictionary!
    var randoms: Array<Array<NSObject>>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        randoms = gameData?.valueForKey("Randoms") as? Array<Array<NSObject>>
        let format = UnsafeMutablePointer<NSPropertyListFormat>()
        let plistPath = NSBundle.mainBundle().pathForResource("Random", ofType: "plist")!
        let plistXML = NSFileManager.defaultManager().contentsAtPath(plistPath)
        do {
            randomData = try NSPropertyListSerialization.propertyListWithData(plistXML!, options: NSPropertyListReadOptions.MutableContainersAndLeaves, format: format) as! NSDictionary
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
    
    func makeGamePage(withStep step:Int) -> GamePageViewController {
        let game = self.storyboard?.instantiateViewControllerWithIdentifier("gamePageController") as! GamePageViewController
        let _ = game.view
        game.step = step
        game.gameData = gameData?.valueForKeyPathWithIndexes("Parts.[\(game.step)]") as? String ?? ""
        game.randomData = randomData
        if randoms?.count != 0 {
            for (var i = 0; i < randoms?.count; i++) {
                if randoms![i][0] as? Int == step {
                    var buffer:Array<String> = []
                    for (var j = 1; j < randoms![i].count; j++){
                        buffer += [(randoms![i][j] as! String)]
                    }
                    game.random = buffer
                }
            }
        }
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

extension PagedGameViewController:UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let gameVC = viewController as! GamePageViewController
        if gameVC.step == 0 {
            return nil
        }
        return makeGamePage(withStep: gameVC.step - 1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let gameVC = viewController as! GamePageViewController
        
        if gameVC.step + 1 >= self.gameData?.valueForKeyPath("Parts.@count") as? Int ?? 0 {
            
            if gameData?.valueForKey("Title") as? String == "Three Lines" {
                return makeGamePage(withStep: 0)
            } else if gameData?.valueForKey("Title") as? String == "Three Things" {
                return makeGamePage(withStep: 1)
            }
            return nil
        }
        
        return makeGamePage(withStep: gameVC.step + 1)
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.gameData?.valueForKeyPath("Parts.@count") as? Int ?? 0
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}