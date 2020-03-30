//
//  ToDoEditViewController.swift
//  Tempus
//
//  Created by Sola on 2020/3/29.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit
import SnapKit

class ToDoEditViewController: UIViewController, UITextViewDelegate {

    // Data.
    var task: Task!
    
    var toDoViewController: ToDoViewController!
    
    var isEmergent: Bool!
    var isImportant: Bool!
    
    var originalIndices: (clsIndex: Int, taskIndex: Int)!
    var currentIndex: Int!
    
    // Views.
    var gradientLayer = CAGradientLayer()
    
    var contentLabel: UILabel!
    var contentTextView: UITextView!
    
    var emergentButton: UIButton!
    var importantButton: UIButton!
    var buttonStackView: UIStackView!
    
    var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateInitialViews()
    }
    
    func updateInitialViews() {
        // Table view.
        view.backgroundColor = UIColor.sky.withAlphaComponent(0.3)
        
        view.addGradientLayer(gradientLayer: gradientLayer,
            colors: [UIColor.aqua.cgColor, UIColor.sky.cgColor],
            locations: [0.0, 1.0],
            startPoint: CGPoint(x: 0, y: 1),
            endPoint: CGPoint(x: 1, y: 0.5),
            frame: self.view.bounds)
        
        // Title of navigation item.
        navigationItem.title = "Detail"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        
        // Content.
        contentLabel = UILabel()
        view.addSubview(contentLabel)

        contentLabel.textColor = .white
        contentLabel.text = "Content"
        contentLabel.textAlignment = .center

        contentLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height / 8)
//            make.width.equalTo(UIScreen.main.bounds.width * 0.94)
        }

        // Content text view.
        contentTextView = UITextView()
        view.addSubview(contentTextView)

        contentTextView.delegate = self

        contentTextView.backgroundColor = UIColor.sky.withAlphaComponent(0)
        contentTextView.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        contentTextView.inputAccessoryView = addDoneButton()
        if let content = task.content {
            contentTextView.text = content
            contentTextView.textColor = .white
        } else {
            contentTextView.text = "Input task content"
            contentTextView.textColor = .lightText
        }

        contentTextView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(UIScreen.main.bounds.width * 0.10)
            make.top.equalTo(contentLabel.snp.bottom).offset(20)
            make.width.equalTo(UIScreen.main.bounds.width * 0.80)
            make.height.equalTo(UIScreen.main.bounds.height * 0.2)
        }
        
        // Emergent and important buttons and stack view.
        emergentButton = UIButton()
        
        emergentButton.addTarget(self, action: #selector(emergentButtonTapped), for: .touchUpInside)
        
        emergentButton.setTitle("Emergent", for: .normal)
//        emergentButton.setTitleColor(.lightText, for: .normal)
        emergentButton.contentHorizontalAlignment = .center
        if isEmergent {
            emergentButton.setTitleColor(.white, for: .normal)
        } else {
            emergentButton.setTitleColor(.lightText, for: .normal)
        }
                
        importantButton = UIButton()
        
        importantButton.addTarget(self, action: #selector(importantButtonTapped), for: .touchUpInside)
        
        importantButton.setTitle("Important", for: .normal)
//        importantButton.setTitleColor(.lightText, for: .normal)
        importantButton.contentHorizontalAlignment = .center
        if isImportant {
            importantButton.setTitleColor(.white, for: .normal)
        } else {
            importantButton.setTitleColor(.lightText, for: .normal)
        }
        
                
        buttonStackView = UIStackView(arrangedSubviews: [emergentButton, importantButton])
        view.addSubview(buttonStackView)
        
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.alignment = .center
        buttonStackView.spacing = 20
        
        buttonStackView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalTo(contentTextView).offset(200)
        }
        
        // Delete Button.
        deleteButton = UIButton()
        if originalIndices != nil {
            view.addSubview(deleteButton)
            
            deleteButton.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.30)
                make.top.equalTo(buttonStackView).offset(320)
            }
        }
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(UIColor.red.withAlphaComponent(0.5), for: .normal)
    }
    
    func updateValues(toDoViewController: ToDoViewController) {
        self.toDoViewController = toDoViewController
    }
    
    @objc func emergentButtonTapped() {
        isEmergent.toggle()
        
        if isEmergent {
            emergentButton.setTitleColor(.white, for: .normal)
        } else {
            emergentButton.setTitleColor(.lightText, for: .normal)
        }
    }
    
    @objc func importantButtonTapped() {
        isImportant.toggle()
        
        if isImportant {
            importantButton.setTitleColor(.white, for: .normal)
        } else {
            importantButton.setTitleColor(.lightText, for: .normal)
        }
    }
    
    @objc func cancelButtonTapped() {
        toDoViewController.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        self.task.content = contentTextView.text
        
        self.toDoViewController.editTask(task: self.task, originalIndices: originalIndices, currentIndex: getClsIndex())

        toDoViewController.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func getClsIndex() -> Int {
        switch (isEmergent, isImportant) {
        case (true, true): return 0
        case (true, false): return 1
        case (false, true): return 2
        case (false, false): return 3
        default: return -1
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Input task content" {
           textView.text = ""
        }
        
        textView.textColor = .white
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text!.isEmpty {
            contentTextView.text = "Input task content"
            contentTextView.textColor = .lightText
        }
    }

    @objc func finishEditing() {
        view.endEditing(false)
    }
    
    func addDoneButton() -> UIToolbar{
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: contentTextView.frame.width, height: 20))

        toolBar.tintColor = .sky

        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(finishEditing))

        toolBar.items = [spaceButton, barButton]
        toolBar.sizeToFit()

        return toolBar
    }
    
    @objc func deleteButtonTapped() {
        self.toDoViewController.editTask(task: self.task, originalIndices: originalIndices!, currentIndex: nil)
//
        toDoViewController.navigationController?.dismiss(animated: true, completion: nil)
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
