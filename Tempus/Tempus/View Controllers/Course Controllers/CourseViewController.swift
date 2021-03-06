//
//  CourseViewController.swift
//  Tempus
//
//  Created by Sola on 2020/8/10.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class CourseViewController: UIViewController, CourseSemesterPickerPopViewDelegate, CourseEditViewControllerDelegate {
   
    // MARK: Models
    
    var courses: Courses! {
        didSet {
            // Saves to disk.
            Courses.saveCourses(self.courses)
        }
    }
    
    var sections: [Section] {
        var sections: [Section] = []
        for course in courses.courses {
            for section in course.sections {
                sections.append(section)
            }
        }
        
        return sections
    }
    
    // MARK: Views
    
    var dateCollectionHeight = CGFloat(50)
    lazy var dateCollectionView: UICollectionView = {
        var collectionView = UICollectionView(
            frame: CGRect(
                x: 0,
                y: navigationController!.navigationBar.frame.maxY + navigationController!.navigationBar.frame.height,
                width: view.frame.width,
                height: dateCollectionHeight
            ),
            collectionViewLayout: {
                let flowLayout = UICollectionViewFlowLayout()
                
                flowLayout.scrollDirection = .vertical
                flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                flowLayout.minimumLineSpacing = 0
                flowLayout.minimumInteritemSpacing = 0
                
                return flowLayout
        }())
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CourseDateCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "courseDateCollectionViewCell")
        collectionView.tag = DATE_COLLECTION_VIEW_TAG
        collectionView.backgroundColor = UIColor.sky.withAlphaComponent(0)
        
        return collectionView
    }()
    let DATE_COLLECTION_VIEW_TAG = 0
    var shortWeekdaySymbolsStartingFromMonday: [String] {
        var symbols = Calendar.current.shortWeekdaySymbols
        
        let sun = symbols.removeFirst()
        symbols.append(sun)
        
        return symbols
    }
    var shortMonthSymbolOfCurrentDay: String {
        let currentMonth = Date().currentTimeZone().getComponents([.month]).month!
        
        return Calendar.current.shortMonthSymbols[currentMonth - 1]
    }
    
    lazy var courseCollectionView: UICollectionView = {
        var collectionView = UICollectionView(
            frame: CGRect(
                x: 0,
                y: navigationController!.navigationBar.frame.maxY + navigationController!.navigationBar.frame.height + dateCollectionHeight,
                width: view.frame.width,
                height: view.frame.height - navigationController!.navigationBar.frame.maxY - navigationController!.navigationBar.frame.height - tabBarController!.tabBar.frame.height - dateCollectionHeight
            ),
            collectionViewLayout: {
                let layout = UICollectionViewFlowLayout()
                
                layout.scrollDirection = .vertical
                layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                layout.minimumLineSpacing = 0
                layout.minimumInteritemSpacing = 0
                
                return layout
        }())

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CourseDateCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "courseDateCollectionViewCell")
        collectionView.register(CourseCourseCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "courseCourseCollectionViewCell")
        collectionView.tag = COURSE_COLLECTION_VIEW_TAG
        collectionView.backgroundColor = UIColor.sky.withAlphaComponent(0)
        
        return collectionView
    }()
    let COURSE_COLLECTION_VIEW_TAG = 1
    let sectionIdxWidth = UIScreen.main.bounds.width / 8
    
    var courseCellSize: CGSize!
    
    var timeLine: CAShapeLayer = {
        let line = CAShapeLayer()
        
        line.strokeColor = UIColor.lightText.cgColor
        line.lineWidth = 0.5
        line.lineJoin = CAShapeLayerLineJoin.round
        
        return line
    }()
    
    var weekdayLine: CAShapeLayer = {
        let line = CAShapeLayer()
        
        line.strokeColor = UIColor.lightText.cgColor
        line.lineWidth = 0.5
        line.lineJoin = CAShapeLayerLineJoin.round
        
        return line
    }()
    
    var semesterPickerView: CourseSemesterPickerPopView!
    
    lazy var wholeScreenView: UIView = {
        let wholeScreenView = UIView()

        wholeScreenView.frame = courseCollectionView.frame
        wholeScreenView.backgroundColor = UIColor.lightText.withAlphaComponent(0)
        wholeScreenView.tag = 999

        return wholeScreenView
    }()
    
    // MARK: Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        
//        courses = Courses(
//            courses: [
//                Course(name: "中国近代史纲要", sections: [
//                    Section(weekday: 1, start: 1, end: 2, classroom: "南E205")
//                ], instructor: "朱月白"),
//
//                Course(name: "C++语言程序设计", sections: [
//                    Section(weekday: 1, start: 3, end: 5, classroom: "南E301"),
//                    Section(weekday: 3, start: 1, end: 2, classroom: "南E301")
//                ], instructor: "周咏梅"),
//
//                Course(name: "综合英语（4）", sections: [
//                    Section(weekday: 1, start: 8, end: 9, classroom: "南A401"),
//                    Section(weekday: 2, start: 1, end: 2, classroom: "南G206")
//                ], instructor: "王斐"),
//
//                Course(name: "高等数学", sections: [
//                    Section(weekday: 2, start: 3, end: 4, classroom: "南实C103"),
//                    Section(weekday: 3, start: 3, end: 4, classroom: "南G404"),
//                    Section(weekday: 5, start: 8, end: 9, classroom: "南A301")
//                ], instructor: "钟兴富"),
//
//                Course(name: "线性代数", sections: [
//                    Section(weekday: 2, start: 9, end: 11, classroom: "南E501")
//                ], instructor: "李键红"),
//
//                Course(name: "体育（1）（网球）", sections: [
//                    Section(weekday: 3, start: 10, end: 11, classroom: "南网球场1号")
//                ], instructor: "郑少苹"),
//
//                Course(name: "思想道德修养与法律基础", sections: [
//                    Section(weekday: 4, start: 1, end: 2, classroom: "南E404")
//                ], instructor: "刘云甫"),
//
//                Course(name: "基础ESP（1）", sections: [
//                    Section(weekday: 4, start: 3, end: 4, classroom: "南G404")
//                ], instructor: "刘会英"),
//
//                Course(name: "计算机科学导论", sections: [
//                    Section(weekday: 5, start: 1, end: 2, classroom: "南F203")
//                ], instructor: "丘心颖"),
//            ],
//            semester: (grade: 1, half: 1), isCurrent: true)
        
        for1: for grade in 1...4 {
            for half in [1, 2] {
                let courses_ = Courses.loadCourses(semester: (grade: grade, half: half))!
                if courses_.isCurrent {
                    courses = courses_
                    break for1
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        drawCourses()
        drawCurrentTimeLine()
        drawCurrentWeekdayLine()
    }
    
    // MARK: Customized init
    
    func updateViews() {
        navigationItem.title = "Course"
        
        // Bar buttons.
        let semesterBarButton = UIBarButtonItem(title: "Semester", style: .plain, target: self, action: #selector(semesterBarButtonTapped_))
        semesterBarButton.tintColor = .white
        navigationItem.leftBarButtonItem = semesterBarButton
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddingView))
        addBarButton.tintColor = .white
        navigationItem.rightBarButtonItem = addBarButton
        
        // Collection Views.
        view.addSubview(dateCollectionView)
        view.addSubview(courseCollectionView)
    }
    
    // MARK: - Customized funcs
    
    @objc func semesterBarButtonTapped_() {
        semesterPickerView = CourseSemesterPickerPopView(
            semesterPickerFrame: CGRect(x: UIScreen.main.bounds.width * 0.03,
                                    y: navigationController!.navigationBar.bounds.height
                                        + navigationController!.navigationBar.bounds.maxY,
                                    width: UIScreen.main.bounds.width * 0.75,
                                    height: UIScreen.main.bounds.height * 0.2)
        )
        semesterPickerView.updateValues(delegate: self)
        UIApplication.shared.windows.last?.addSubview(semesterPickerView)
    }
    
    @objc func presentAddingView() {
        let courseEditViewController = CourseEditViewController()
        courseEditViewController.updateValues(
            delegate: self,
            course: Course(name: "", sections: [Section(weekday: 0, start: 0, end: 0, classroom: "")], instructor: "", weekNumber: 0),
            courseIndex: nil
        )
        navigationController?.present(CourseEditNavigationController(rootViewController: courseEditViewController), animated: true, completion: nil)
    }
    
    func drawCourse(course: Course, section: Section) {
        let courseView: UIView = {
            let view = UIView(
                frame: CGRect(
                    x: CGFloat(sectionIdxWidth) + CGFloat(section.weekday - 1) * courseCellSize.width + 1,
                    y: CGFloat(section.start - 1) * courseCellSize.height + 1,
                    width: courseCellSize.width - 2,
                    height: courseCellSize.height * CGFloat(section.end - section.start + 1) - 2
                )
            )
            
            view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(viewLongPressed(_:))))
            view.alpha = 0.8
            view.layer.cornerRadius = 10
            view.layer.masksToBounds = true
            view.backgroundColor = .sky
//            view.tag = courses.courses.firstIndex(of: course)! + 1  // Cannot be the default value 0.
            view.tag = sections.firstIndex(of: section)! + 1
            
            return view
        }()

        let courseInfoLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: 3, y: 3, width: courseView.frame.size.width - 6, height: courseView.frame.size.height - 6))
            
            label.text = "\(course.name!)\n@\n\(section.classroom!)"
            label.numberOfLines = 6
            label.font = UIFont.boldSystemFont(ofSize: 10)
            label.textAlignment = .left
            label.textColor = UIColor.white
            
            return label
        }()
        courseView.addSubview(courseInfoLabel)
        
        courseCollectionView.addSubview(courseView)
    }
    
    @objc func viewLongPressed(_ longGestureRecognizer: UILongPressGestureRecognizer) {
        if view.subviews.contains(where: { (view) -> Bool in
            view.tag == 999
        }) {
            return
        }
            
        let courseView = longGestureRecognizer.view!

        view.addSubview(wholeScreenView)
        
        let editButton = UIButton()
        wholeScreenView.addSubview(editButton)
        editButton.addTarget(self, action: #selector(presentEditingView(_:)), for: .touchUpInside)
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(UIColor.blue.withAlphaComponent(0.3), for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        editButton.backgroundColor = courseView.backgroundColor
        editButton.layer.cornerRadius = 10
        editButton.layer.masksToBounds = true
        editButton.tag = courseView.tag
        editButton.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(courseView)
            make.height.equalTo(courseView).multipliedBy(0.8)
        }

        let deleteButton = UIButton()
        wholeScreenView.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteSection(_:)), for: .touchUpInside)
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(UIColor.red.withAlphaComponent(0.5), for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        deleteButton.backgroundColor = courseView.backgroundColor
        deleteButton.layer.cornerRadius = 10
        deleteButton.layer.masksToBounds = true
        deleteButton.tag = courseView.tag
        deleteButton.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(courseView)
            make.height.equalTo(courseView).multipliedBy(0.2)
        }
    }
    
    func getCourseIndex(of section_: Section) -> Int? {
        for courseIndex in 0..<courses.courses.count {
            for section in courses.courses[courseIndex].sections {
                if section == section_ {
                    return courseIndex
                }
            }
        }
        
        return nil
    }
    
    @objc func presentEditingView(_ button: UIButton) {
        let sectionIndex = button.tag - 1
        let section = sections[sectionIndex]
        if let courseIndex = getCourseIndex(of: section) {
            let course = courses.courses[courseIndex]
            let courseEditViewController = CourseEditViewController()
            courseEditViewController.updateValues(delegate: self, course: course, courseIndex: courseIndex)
            navigationController?.present(CourseEditNavigationController(rootViewController: courseEditViewController), animated: true, completion: nil)
        }
        
        removeEditAndDeleteButtons()
    }
    
    func getSectionIndex(of section: Section) -> Int? {
        for course in courses.courses {
            for sectionIndex in 0..<course.sections.count {
                if section == course.sections[sectionIndex] {
                    return sectionIndex
                }
            }
        }
        
        return nil
    }
    
    @objc func deleteSection(_ button: UIButton) {
        let sectionIndex = button.tag - 1
        let section = sections[sectionIndex]
        if let sectionIndexInCourse = getSectionIndex(of: section), let courseIndex = getCourseIndex(of: section) {
            courses.courses[courseIndex].sections.remove(at: sectionIndexInCourse)
        }
        
        removeEditAndDeleteButtons()
        
        drawCourses()
    }
    
    func removeEditAndDeleteButtons() {
        UIView.animate(withDuration: 0.25, animations: {
            for subView in self.wholeScreenView.subviews {
                subView.removeFromSuperview()
            }
        }) { (view) in
            self.wholeScreenView.removeFromSuperview()
        }
    }
    
    // Taps to make disappear.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeEditAndDeleteButtons()
    }
    
    // Taps to make disappear.
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeEditAndDeleteButtons()
    }
    
    func drawCourses() {
        for view in courseCollectionView.subviews {
            if view.tag != 0  {  // Course view.
                view.removeFromSuperview()
            }
        }
        
        for course in courses.courses {
            for section in course.sections {
                drawCourse(course: course, section: section)
            }
        }
    }
    
    func drawCurrentTimeLine() {
        func getLoc() -> CGFloat? {
            let current = Date().currentTimeZone()
            
            // Having class.
            for elem in Section.time {
                if elem.value.start <= current && current <= elem.value.end {
                    let secondsFromStart = DateInterval(
                        start: elem.value.start,
                        end: current
                        ).getComponents([.second]).second!
                    
                    return CGFloat(secondsFromStart) / courseCellSize.height + (CGFloat(elem.key - 1) * courseCellSize.height)
                }
            }
            
            // Not having class.
            for i in 1...(Section.time.count - 1) {
                let elem = Section.time[i]!
                let nextElem = Section.time[i + 1]!
                
                if elem.end <= current && current <= nextElem.start {
                    return (CGFloat(i) * courseCellSize.height)
                }
            }
            
            return nil
        }
        
        if let loc = getLoc() {
            let linePath = UIBezierPath()
            linePath.move(to: CGPoint(x: sectionIdxWidth, y: loc))
            linePath.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: loc))
            
            timeLine.path = linePath.cgPath
            courseCollectionView.layer.addSublayer(timeLine)
        }
    }
    
    func drawCurrentWeekdayLine() {
        func getLoc() -> CGFloat {
            var weekday = Date().currentTimeZone().getComponents([.weekday]).weekday!
            if weekday != 1 {
                weekday = weekday - 1
            } else {
                weekday = 7
            }
            
            return courseCellSize.width + courseCellSize.width * CGFloat((weekday - 1)) + courseCellSize.width * 0.5
        }
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: getLoc(), y: 0))
        linePath.addLine(to: CGPoint(x: getLoc(), y: courseCellSize.height * CGFloat(Section.sectionNumber)))
        weekdayLine.path = linePath.cgPath
        
        courseCollectionView.layer.addSublayer(weekdayLine)
    }
    
    func dateOfWeekday(_ weekday: Int) -> String {
        let currentWeekDay = Date().currentTimeZone().getComponents([.weekday]).weekday!
        
        let mondayOfCurrentWeek = Calendar.current.date(byAdding: .day, value: -currentWeekDay + 2, to: Date().currentTimeZone())!
        
        let date = Calendar.current.date(byAdding: .day, value: weekday, to: mondayOfCurrentWeek)!
        
        return String(date.getComponents([.day]).day!)
    }
    
    // MARK: - Course semester picker pop view delegate
    
    func changeSemester(semester: (grade: Int, half: Int)) {
        // Saves the current courses.
        Courses.saveCourses(courses)
        
        // Loads the courses given a semester.
        courses = Courses.loadCourses(semester: semester)
        courses.isCurrent = true

        // Draws new courses.
        drawCourses()
    }
    
    // MARK: - Course edit view controller delegate
    
    func editCourse(_ course: Course, at courseIndex: Int?) {
        if let courseIndex = courseIndex {
            courses.courses[courseIndex] = course
        } else {
            courses.courses.append(course)
        }
        
        drawCourses()
    }
}

extension CourseViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case DATE_COLLECTION_VIEW_TAG:
            return shortWeekdaySymbolsStartingFromMonday.count + 1
        case COURSE_COLLECTION_VIEW_TAG:
            return (shortWeekdaySymbolsStartingFromMonday.count + 1) * Section.sectionNumber
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case DATE_COLLECTION_VIEW_TAG:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "courseDateCollectionViewCell", for: indexPath) as! CourseDateCollectionViewCell
            
            if indexPath.row != 0 {
                cell.startTimeLabel.text = dateOfWeekday(indexPath.row - 1)
                cell.dateLabel.text = shortWeekdaySymbolsStartingFromMonday[indexPath.row - 1]
            } else {
                cell.startTimeLabel.text = shortMonthSymbolOfCurrentDay
            }
            
            return cell
        case COURSE_COLLECTION_VIEW_TAG:
            if indexPath.row % 8 == 0 {  // Section idx.
                let idx = Int(indexPath.row / (shortWeekdaySymbolsStartingFromMonday.count + 1) + 1)
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "courseDateCollectionViewCell", for: indexPath) as! CourseDateCollectionViewCell
                
                cell.startTimeLabel.text = Section.time[idx]?.start.formattedTime()
                cell.dateLabel.text = "\(idx)"
                
                return cell
            } else {  // Course.
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "courseCourseCollectionViewCell", for: indexPath) as! CourseCourseCollectionViewCell
                
//                cell.courseLabel.text = ""
                
                return cell
                
            }
        default:
            return UICollectionViewCell()
        }
    }
}

extension CourseViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let SCREEN_WIDTH = UIScreen.main.bounds.width
        let SCREEN_HEIGHT = UIScreen.main.bounds.height
        
        switch collectionView.tag {
        case DATE_COLLECTION_VIEW_TAG:
            return CGSize(width: sectionIdxWidth, height: dateCollectionHeight)
        case COURSE_COLLECTION_VIEW_TAG:
            let courseCellRowHeight = CGFloat(SCREEN_HEIGHT * 0.9 / CGFloat(Section.sectionNumber))
            
            courseCellSize =  CGSize(width: (SCREEN_WIDTH - sectionIdxWidth) / 7, height: courseCellRowHeight)
            
            return courseCellSize
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}
