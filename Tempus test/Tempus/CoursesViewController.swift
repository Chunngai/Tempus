//
//  CoursesViewController.swift
//  Tempus
//
//  Created by Sola on 2020/2/8.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class CoursesViewController: UIViewController {

    let numberOfPages = 2
    let pageWidth = UIScreen.main.bounds.size.width
    let pageHeight = UIScreen.main.bounds.size.height
    
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.frame = self.view.bounds
        
        scrollView.contentSize = CGSize(width: pageWidth * CGFloat(numberOfPages), height: pageHeight)
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        
        let assignmentsTableViewController = AssignmentsTableViewController()
        assignmentsTableViewController.view.frame = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        scrollView.addSubview(assignmentsTableViewController.view)
        
        let timeTableTableViewController = TimetableTableViewController()
        timeTableTableViewController.view.frame = CGRect(x: pageWidth, y: 0, width: pageWidth, height: pageHeight)
        scrollView.addSubview(timeTableTableViewController.view)
        
        view.addSubview(scrollView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
