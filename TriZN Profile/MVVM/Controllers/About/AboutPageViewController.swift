//
//  AboutPageViewController.swift
//  TriZN Profile
//
//  Created by Tri ZN on 5/9/18.
//  Copyright © 2018 Tri ZN. All rights reserved.
//

import UIKit

class AboutPageViewController: UIPageViewController {

    // MARK: - Properties
    var pages = [UIViewController]()
    let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        
        
        // Open file plist and config sub views
        configureSubviews()
 
    }

    // MARK: - Private methods
    private func configureSubviews() {
        // Open file plist
        var myDict = Dictionary <String , Any>()
        if let path = Bundle.main.path(forResource: "About", ofType: "plist") {
            let data = NSDictionary(contentsOfFile: path)
            myDict = data as! [String : Any]
        }

        // Instance view controller
        for item in myDict {
            if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "ShowAboutViewController") as? ShowAboutViewController {
                // Convert NSDictionay to Dictionary<String, Any>
                var dict = Dictionary<String, Any>()
                dict[item.key] = item.value
                
                pageViewController.parseDictionaryToArray(with: dict)
                
                self.pages.append(pageViewController)
            }
        }
        
        // Congigure page control
        self.configurePageControl()
    }
    
    /** Configure page Control
    *
    *
    */
    private func configurePageControl() {
        let initialPage = 0
        // Page control
        self.pageControl.frame = CGRect()
        self.pageControl.currentPageIndicatorTintColor = UIColor.blue
        self.pageControl.pageIndicatorTintColor = UIColor.black
        
        self.pageControl.numberOfPages = pages.count
        
        self.pageControl.currentPage = initialPage
        
        self.view.addSubview(pageControl)
        
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        self.pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        //        self.pageControl.bottomAnchor.constraint(equalTo: (tabBarController?.tabBar.anch)!, constant: +50).isActive = true
        self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        // set vc at page control
        setViewControllers([pages[initialPage]], direction: .forward, animated: false, completion: nil)
    }
}

// MARK: - Extensions UIPageViewControllerDataSource
extension AboutPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.pages.index(of: viewController) {
            if viewControllerIndex == 0 {
                return self.pages.last
            } else {
                return pages[viewControllerIndex - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.pages.index(of: viewController) {
            if viewControllerIndex < pages.count - 1 {
                return pages[viewControllerIndex + 1]
            } else {
                return pages.first
            }
        }
        return nil
    }
}

// MARK: Extensions UIPageViewControllerDelegate
extension AboutPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        self.view.isUserInteractionEnabled = true
        
        if let viewController = pageViewController.viewControllers {
            if let viewcontrollerIndex = pages.index(of: viewController[0]) {
                self.pageControl.currentPage = viewcontrollerIndex
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.view.isUserInteractionEnabled = false
    }
}
