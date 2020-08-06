//
//  ScheduleDatePicker.swift
//  Tempus
//
//  Created by Sola on 2020/3/27.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit
import SnapKit

class ScheduleDatePickerPopView: UIView {
    
    // MARK: - Controllers
    
    var delegate: ScheduleViewController!
    
    // MARK: - Views
        
    var contentView: UIView = {
        let view = UIView()

        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        return view
    }()
    
    var todayButton: UIButton = {
        let button = UIButton()
        
        button.addTarget(self, action: #selector(todayButtonTapped), for: .touchUpInside)
        button.setTitle("Today", for: .normal)
        button.setTitleColor(UIColor.blue.withAlphaComponent(0.3), for: .normal)
        
        return button
    }()
    var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date(timeInterval: 24 * 3600, since: Date())
        
        return datePicker
    }()
    
    // MARK: - Initializers
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(datePickerFrame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
                
        updateInitialViews(datePickerFrame: datePickerFrame)
    }
    
    // MARK: - Customized initializers
    
    func updateInitialViews(datePickerFrame: CGRect) {
        // The frame is the whole screen.
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        // Content view.
        addSubview(contentView)
        contentView.frame = datePickerFrame
        contentView.addGradientLayer(endPoint: CGPoint(x: 1, y: 0),
                                     frame: contentView.bounds)
        
        // Today button.
        contentView.addSubview(todayButton)
        todayButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(3)
        }
        
        // Date picker.
        contentView.addSubview(datePicker)
        datePicker.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(todayButton).inset(35)
        }
    }
    
    func updateValues(delegate: ScheduleViewController) {
        self.delegate = delegate
        
        datePicker.date = delegate.schedule.date
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
    
    // MARK: - Customized funcs
    
    @objc func todayButtonTapped() {
        datePicker.date = Date()
        delegate.changeSchedule(date: datePicker.date.currentTimeZone())
    }
    
    @objc func datePickerValueChanged() {
        delegate.changeSchedule(date: datePicker.date.currentTimeZone())
    }
}

protocol ScheduleDatePickerPopViewDelegate {
    func changeSchedule(date: Date)
}
