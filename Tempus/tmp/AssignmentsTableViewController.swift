//
//  AssignmentsTableViewController.swift
//  Tempus
//
//  Created by Sola on 2020/2/10.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class AssignmentsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        updateView()
    }
    
    func updateView() {
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationBar.backgroundColor = UIColor(red: 0.462, green: 0.838, blue: 1.000, alpha: 1)
//        navigationController?.navigationBar.barTintColor = .sky
//        setNavigationBarTintColor()
        tableView.alpha = 0
        
        navigationItem.title = "Assignments"
        navigationController?.tabBarItem.title = "Assignments"
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        let segmentedControl = UISegmentedControl(items: ["Courses", "Due Date"])
        segmentedControl.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 32)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = .sky
        segmentedControl.backgroundColor = .white
        tableView.addSubview(segmentedControl)
    }
    
//    func setNavigationBarTintColor() {
//        let gradientLayer = CAGradientLayer()
//        
//        gradientLayer.colors = [UIColor(red: 0.000, green: 0.590, blue: 1.000, alpha: 1).cgColor, UIColor(red: 0.462, green: 0.838, blue: 1.000, alpha: 1).cgColor]
//        gradientLayer.locations = [0.0, 1.0]
//        
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
//        
//        if let navigationBarBounds = navigationController?.navigationBar.bounds {
//            gradientLayer.frame = navigationBarBounds
//            
//            navigationController?.navigationBar.layer.addSublayer(gradientLayer)
//        }
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
        
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
