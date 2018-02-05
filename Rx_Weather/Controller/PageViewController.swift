//
//  PageViewController.swift
//  Rx_Weather
//
//  Created by LinChico on 2/1/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    lazy var viewControllerList: [UIViewController] = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyboard.instantiateViewController(withIdentifier: "currentWeatherVC") as! CurrentWeatherViewController
        let vc2 = storyboard.instantiateViewController(withIdentifier: "futureWeatherVC")
        return [vc1, vc2]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dataSource = self
        
        if let firstVC = viewControllerList.first{
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }

    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currIdx = viewControllerList.index(of: viewController) else {return nil}
        guard currIdx > 0 else {return nil}
        return viewControllerList[currIdx - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currIdx = viewControllerList.index(of: viewController) else {return nil}
        guard currIdx < viewControllerList.count - 1 else {return nil}
        return viewControllerList[currIdx + 1]
    }
}
