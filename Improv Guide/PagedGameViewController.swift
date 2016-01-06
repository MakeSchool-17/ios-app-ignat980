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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let game = self.storyboard?.instantiateViewControllerWithIdentifier("gamePageController") as? GamePageViewController {
            self.setViewControllers([game], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
            game.instructions.text = (gameData?.valueForKeyPathWithIndexes("Parts[0]") as? String ?? "")
            game.instructions.setNeedsLayout()
            game.step = 0
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let game = self.storyboard?.instantiateViewControllerWithIdentifier("gamePageController") as! GamePageViewController
        let _ = game.view
        game.step = gameVC.step - 1
        game.instructions.text = gameData?.valueForKeyPathWithIndexes("Parts[\(gameVC.step - 1)]") as? String ?? ""
        return game
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let gameVC = viewController as! GamePageViewController
        if gameVC.step + 1 >= self.gameData?.valueForKeyPath("Parts.@count") as? Int ?? 0 {
            if gameData?.valueForKey("Title") as? String == "Three Lines" {
                let game = self.storyboard?.instantiateViewControllerWithIdentifier("gamePageController") as! GamePageViewController
                let _ = game.view
                game.step = 0
                game.instructions.text = gameData?.valueForKeyPathWithIndexes("Parts[\(game.step)]") as? String ?? ""
                
                return game
            }
            if gameData?.valueForKey("Title") as? String == "Three Things" {
                let game = self.storyboard?.instantiateViewControllerWithIdentifier("gamePageController") as! GamePageViewController
                let _ = game.view
                game.step = 1
                game.instructions.text = gameData?.valueForKeyPathWithIndexes("Parts[\(game.step)]") as? String ?? ""
                
                return game
            }
            return nil
        }
        let game = self.storyboard?.instantiateViewControllerWithIdentifier("gamePageController") as! GamePageViewController
        let _ = game.view
        game.step = gameVC.step + 1
        game.instructions.text = gameData?.valueForKeyPathWithIndexes("Parts[\(game.step)]") as? String ?? ""
        
        return game
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.gameData?.valueForKeyPath("Parts.@count") as? Int ?? 0
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}