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
    
    var originalIndices: (clsIndex: Int, taskIndex: Int)!
    var currentIndex: Int!
    
    // Views.
    var gradientLayer = CAGradientLayer()
    
    var contentLabel: UILabel!
    var contentTextView: UITextView!
    
    var repeatedButton = UIButton()
    var emergentButton = UIButton()
    var importantButton = UIButton()
    lazy var buttonStackView = UIStackView(arrangedSubviews: [repeatedButton, emergentButton, importantButton])
    
    var isRepeated: Bool! {
        didSet {
            if self.isRepeated {
                repeatedButton.setTitleColor(.white, for: .normal)
            } else {
                repeatedButton.setTitleColor(.lightText, for: .normal)
            }
        }
    }
    var isEmergent: Bool! {
        didSet {
            if self.isEmergent {
                emergentButton.setTitleColor(.white, for: .normal)
            } else {
                emergentButton.setTitleColor(.lightText, for: .normal)
            }
        }
    }
    var isImportant: Bool! {
        didSet {
            if self.isImportant {
                importantButton.setTitleColor(.white, for: .normal)
            } else {
                importantButton.setTitleColor(.lightText, for: .normal)
            }
        }
    }
    
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
        
        // Repetition, emergent and important buttons and stack view.
//        repeatedButton = UIButton()
        
        repeatedButton.addTarget(self, action: #selector(repeatedButtonTapped), for: .touchUpInside)
        
        repeatedButton.setTitle("Repeated", for: .normal)
        repeatedButton.contentHorizontalAlignment = .center
//        if isRepeated {
//            repeatedButton.setTitleColor(.white, for: .normal)
//        } else {
//            repeatedButton.setTitleColor(.lightText, for: .normal)
//        }
        
//        emergentButton = UIButton()
        
        emergentButton.addTarget(self, action: #selector(emergentButtonTapped), for: .touchUpInside)
        
        emergentButton.setTitle("Emergent", for: .normal)
        emergentButton.contentHorizontalAlignment = .center
//        if isEmergent {
//            emergentButton.setTitleColor(.white, for: .normal)
//        } else {
//            emergentButton.setTitleColor(.lightText, for: .normal)
//        }
                
//        importantButton = UIButton()
        
        importantButton.addTarget(self, action: #selector(importantButtonTapped), for: .touchUpInside)
        
        importantButton.setTitle("Important", for: .normal)
        importantButton.contentHorizontalAlignment = .center
//        if isImportant {
//            importantButton.setTitleColor(.white, for: .normal)
//        } else {
//            importantButton.setTitleColor(.lightText, for: .normal)
//        }
        
                
//        buttonStackView = UIStackView(arrangedSubviews: [repeatedButton, emergentButton, importantButton])
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
    

    func updateValues(task: Task, toDoViewController: ToDoViewController, originalIndices: (clsIndex: Int, taskIndex: Int)?, isRepeated: Bool, isEmergent: Bool, isImportant: Bool) {
        self.task = task
        self.toDoViewController = toDoViewController
        self.originalIndices = originalIndices
        self.isRepeated = isRepeated
        self.isEmergent = isEmergent
        self.isImportant = isImportant
    }
    
    @objc func repeatedButtonTapped() {
        isRepeated.toggle()
        
        if isRepeated {
//            repeatedButton.setTitleColor(.white, for: .normal)
            
            isImportant = false
            isEmergent = false
        } else {
//            repeatedButton.setTitleColor(.lightText, for: .normal)
        }
    }
    
    @objc func emergentButtonTapped() {
        isEmergent.toggle()
        
        if isEmergent {
//            emergentButton.setTitleColor(.white, for: .normal)
            
            isRepeated = false
        } else {
//            emergentButton.setTitleColor(.lightText, for: .normal)
        }
    }
    
    @objc func importantButtonTapped() {
        isImportant.toggle()
        
        if isImportant {
//            importantButton.setTitleColor(.white, for: .normal)
            
            isRepeated = false
        } else {
//            importantButton.setTitleColor(.lightText, for: .normal)
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
        switch (isRepeated, isEmergent, isImportant) {
        case (true, false, false): return 0
        case (false, true, true): return 1
        case (false, true, false): return 2
        case (false, false, true): return 3
        case (false, false, false): return 4
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
