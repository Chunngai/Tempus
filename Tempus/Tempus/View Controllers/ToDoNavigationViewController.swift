//
//  ToDoNavigationViewController.swift
//  Tempus
//
//  Created by Sola on 2020/3/28.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Customizes the navigation bar.
        navigationBar.prefersLargeTitles = true
        navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        navigationBar.setToTransparent()
        
        // Customizes the tab bar.
        tabBarItem.title = "To Do"
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
