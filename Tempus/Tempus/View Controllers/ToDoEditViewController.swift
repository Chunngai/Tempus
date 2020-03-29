//
//  ToDoEditViewController.swift
//  Tempus
//
//  Created by Sola on 2020/3/29.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class ToDoEditViewController: UIViewController, UITextViewDelegate {

    // Data.
    var task: Task!
    
    var toDoViewController: ToDoViewController!
    
    // Views.
    var gradientLayer = CAGradientLayer()
    
    var contentLabel: UILabel!
    var contentTextView: UITextView!
    
    var emergentButton: UIButton!
    var importantButton: UIButton!
    var buttonStackView: UIStackView!
    
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
            make.left.equalToSuperview().inset(UIScreen.main.bounds.width * 0.03)
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height / 8)
            make.width.equalTo(UIScreen.main.bounds.width * 0.94)
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
            make.width.equalTo(UIScreen.main.bounds.width * 0.90)
            make.height.equalTo(UIScreen.main.bounds.height * 0.2)
        }
    }
    
    func updateValues(toDoViewController: ToDoViewController) {
        self.toDoViewController = toDoViewController
    }
    
    @objc func cancelButtonTapped() {
        toDoViewController.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
