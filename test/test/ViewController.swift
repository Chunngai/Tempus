//
//  ViewController.swift
//  test
//
//  Created by Sola on 2020/2/9.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var a: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        // Do any additional setup after loading the view.
        
        print(a)
        
        if let presentingViewController = presentingViewController as? TableViewController {
            presentingViewController.b  = "?????????"
            print(111)
        }
        dismiss(animated: true, completion: nil)
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
