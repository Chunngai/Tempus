//
//  CourseSemesterPickerPopView.swift
//  Tempus
//
//  Created by Sola on 2020/8/21.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class CourseSemesterPickerPopView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Models
    
    var semester: (grade: Int, half: Int)!
    
    // MARK: - Controllers
    
    var delegate: CourseViewController!
    
    // MARK: - Views
    
    var contentView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        return view
    }()
    
    var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.setValue(UIColor.white, forKeyPath: "textColor")
        
        return pickerView
    }()
    
    // MARK: - Initializers
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(semesterPickerFrame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        updateInitialViews(semesterPickerFrame: semesterPickerFrame)
    }
    
    // MARK: - Customized initializers
    
    func updateInitialViews(semesterPickerFrame: CGRect) {
        // The frame is the whole screen.
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        // Content view.
        addSubview(contentView)
        contentView.frame = semesterPickerFrame
        contentView.addGradientLayer(endPoint: CGPoint(x: 1, y: 0),
                                     frame: contentView.bounds)
        
        // Picker.
        contentView.addSubview(pickerView)
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(UIScreen.main.bounds.width * 0.02)
            make.right.equalToSuperview().offset(-UIScreen.main.bounds.width * 0.02)
            make.height.equalToSuperview()
        }
    }
    
    func updateValues(delegate: CourseViewController) {
        self.delegate = delegate
        
        self.semester = delegate.courses.semester

        self.pickerView.selectRow(semester.grade - 1, inComponent: 0, animated: true)
        self.pickerView.selectRow(semester.half - 1, inComponent: 1, animated: true)
    }
    
    // MARK: - UIView funcs
    
    // Taps to make disappear.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (view) in
            self.removeFromSuperview()
        }
    }
    
    // Taps to make disappear.
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (view) in
            self.removeFromSuperview()
        }
    }
}

extension CourseSemesterPickerPopView {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 4
        } else {
            return 2
        }
    }
    
    // MARK: - Picker view delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return Courses.semesterTexts[row + 1]
        } else {
            return row == 0 ? "1st" : "2nd"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate.changeSemester(semester: (grade: pickerView.selectedRow(inComponent: 0) + 1, half: pickerView.selectedRow(inComponent: 1) + 1))
    }
}

protocol CourseSemesterPickerPopViewDelegate {
    func changeSemester(semester: (grade: Int, half: Int))
}
