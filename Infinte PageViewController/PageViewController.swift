//
//  PageViewController.swift
//  Infinte PageViewController
//
//  Created by Varun Nath on 18/04/17.
//  Copyright © 2017 UnsureProgrammer. All rights reserved.
//

import UIKit
import SnapKit


class PageViewController: UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate {

    let viewControllerOne = BaseViewController()
    let viewControllerTwo = BaseViewController()
    
    var myArray = [UIViewController]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        
        self.title = "Infinite PageViewController"
        
        viewControllerOne.articleTitle.text = "ViewController One"
        viewControllerOne.articleText.text = "ViewControllerOne Text"
        
        
        viewControllerTwo.articleTitle.text = "ViewController Two"
        viewControllerTwo.articleText.text = "ViewControllerTwo Text"
        
        self.myArray.append(viewControllerOne)
        self.myArray.append(viewControllerTwo)
        // Do any additional setup after loading the view.
    
        self.setViewControllers([self.myArray[0]], direction: .forward , animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = self.myArray.index(of:viewController as! BaseViewController) else{
            return nil
        }
        
        /** get the next index**/
        let nextIndex = vcIndex + 1
        let vcCount = self.myArray.count
        
        
        /** if count is equal to next index, return nil **/
        guard vcCount != nextIndex else {
            return nil
        }
        /** if count is not greater that next index, return nil **/
        guard vcCount > nextIndex else {
            return nil
        }
        
        
        let nextController = self.myArray[nextIndex] as! BaseViewController
        print(nextController.article)

        nextController.addImage()
        return nextController

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = self.myArray.index(of: viewController as! BaseViewController) else {
            return nil
        }
        
        /** get the previous index **/
        let preIndex = vcIndex - 1
        
        /** if previous index is less than 0 then return nil **/
        guard preIndex >= 0 else {
            return nil
        }
        /** if total controller count is less that the index, then return nil **/
        guard self.myArray.count > preIndex else {
            return nil
        }
        guard self.myArray.count > preIndex else {
            return nil
        }
        
        
        let previousController = self.myArray[preIndex] as! BaseViewController
        previousController.addImage()
        return previousController
    
    }
    
    


}
