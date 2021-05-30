//
//  CollegeReviewViewController.swift
//  Dock: Computer Science
//
//  Created by Leon Djusberg on 5/25/18.
//  Copyright © 2018 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

var isShowingReviews = true

class CollegeInfoPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var viewControllerList: [UIViewController] = {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        return [sb.instantiateViewController(withIdentifier: "review"),
                sb.instantiateViewController(withIdentifier: "advice")]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.dataSource = self
        
        if let firstViewController = viewControllerList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if isShowingReviews == true && completed == true {
            isShowingReviews = false
        } else {
            isShowingReviews = true
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = UIColor.clear
            }
        }
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            isShowingReviews = true
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let vcIndex: Int = viewControllerList.index(of: viewController) ?? 0
        
        if vcIndex <= 0 {
            return nil
        }
        
        return viewControllerList[vcIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let vcIndex: Int = viewControllerList.index(of: viewController) ?? 0
        
        if vcIndex >= viewControllerList.count - 1 {
            return nil
        }
        
        return viewControllerList[vcIndex + 1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllerList.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

    @IBAction func addTapped(_ sender: Any) {
        
        if Auth.auth().currentUser?.uid == nil {
            performSegue(withIdentifier: "toAccountInfoFromAdd", sender: self)
        } else {
            performSegue(withIdentifier: "popUpSegue", sender: self)
        }
    }
}
