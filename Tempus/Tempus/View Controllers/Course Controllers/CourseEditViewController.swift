//
//  CourseEditViewController.swift
//  Tempus
//
//  Created by Sola on 2020/8/22.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class CourseEditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Controllers
    
    var delegate: CourseViewController!
    
    // MARK: - Views
    
    lazy var courseEditTableView: UITableView = {
        var tableView = UITableView()
        
        tableView = UITableView(
            frame: CGRect(x: 0,
                          y: navigationController!.navigationBar.frame.height,
                          width: view.frame.width,
                          height: view.frame.height
                            - navigationController!.navigationBar.frame.height),
            style: .plain
        )
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = UIColor.sky.withAlphaComponent(0)
//        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    var courseNameCellIndexPath: IndexPath {
        return IndexPath(row: 0, section: 0)
    }
    var instructorCellIndexPath: IndexPath {
        return IndexPath(row: 1, section: 0)
    }
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateInitialViews()
    }
    
    // MARK: - Customized init
    
    func updateInitialViews() {
        // Background.
        view.backgroundColor = UIColor.sky.withAlphaComponent(0.3)
        
        // Title.
        navigationItem.title = "Detail"
        
        // Bar button items.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        
        // Table view.
        view.addSubview(courseEditTableView)
    }
    
    func updateValues(delegate: CourseViewController) {
        self.delegate = delegate
    }
    
    // MARK: - Customized funcs
    
    @objc func cancelButtonTapped() {
        delegate.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == courseNameCellIndexPath {
            let cell = CourseEditTextTableViewCell()
            cell.updateValues(labelText: "Course: ")
            return cell
        }
        if indexPath == instructorCellIndexPath {
            let cell = CourseEditTextTableViewCell()
            cell.updateValues(labelText: "Instructor: ")
            return cell
        }
        
        return CourseEditTextTableViewCell()
    }
    
    // MARK: - Table view delegate
}
