//
//  CourseViewController.swift
//  Tempus
//
//  Created by Sola on 2020/8/10.
//  Copyright © 2020 Sola. All rights reserved.
//

import UIKit

class CourseViewController: UIViewController {

    // MARK: Models
    
    var courses = Courses(
        courses: [
            Course(name: "中国近代史纲要", sections: [
                Section(weekday: 1, start: 1, end: 2, classroom: "南E205")
            ], instructor: "朱月白"),
            
            Course(name: "C++语言程序设计", sections: [
                Section(weekday: 1, start: 3, end: 5, classroom: "南E301"),
                Section(weekday: 3, start: 1, end: 2, classroom: "南E301")
            ], instructor: "周咏梅"),
            
            Course(name: "综合英语（4）", sections: [
                Section(weekday: 1, start: 8, end: 9, classroom: "南A401"),
                Section(weekday: 2, start: 1, end: 2, classroom: "南G206")
            ], instructor: "王斐"),
            
            Course(name: "高等数学", sections: [
                Section(weekday: 2, start: 3, end: 4, classroom: "南实C103"),
                Section(weekday: 3, start: 3, end: 4, classroom: "南G404"),
                Section(weekday: 5, start: 8, end: 9, classroom: "南A301")
            ], instructor: "钟兴富"),
            
            Course(name: "线性代数", sections: [
                Section(weekday: 2, start: 9, end: 11, classroom: "南E501")
            ], instructor: "李键红"),
            
            Course(name: "体育（1）（网球）", sections: [
                Section(weekday: 3, start: 10, end: 11, classroom: "南网球场1号")
            ], instructor: "郑少苹"),
            
            Course(name: "思想道德修养与法律基础", sections: [
                Section(weekday: 4, start: 1, end: 2, classroom: "南E404")
            ], instructor: "刘云甫"),
            
            Course(name: "基础ESP（1）", sections: [
                Section(weekday: 4, start: 3, end: 4, classroom: "南G404")
            ], instructor: "刘会英"),
            
            Course(name: "计算机科学导论", sections: [
                Section(weekday: 5, start: 1, end: 2, classroom: "南F203")
            ], instructor: "丘心颖"),
        ],
        semester: (1, 1))
    
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
                layout.minimumLineSpacing = -1
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
    var courseCellColor: UIColor {
        return UIColor.sky
    }
    
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
    
    // MARK: Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        for course in courses.courses {
            for section in course.sections {
                drawCourse(course: course, section: section)
            }
        }
        
        drawCurrentTimeLine()
        drawCurrentWeekdayLine()
    }
    
    // MARK: Customized init
    
    func updateViews() {
        navigationItem.title = "Course"
        
        // Collection Views.
        view.addSubview(dateCollectionView)
        view.addSubview(courseCollectionView)
    }
    
    // MARK: - Customized funcs
    
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
            
            view.alpha = 0.8
            view.layer.cornerRadius = 10
            view.layer.masksToBounds = true
            view.backgroundColor = courseCellColor
            
            return view
        }()

        let courseInfoLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: 3, y: 3, width: courseView.frame.size.width - 6, height: courseView.frame.size.height - 6))
            
            label.text = "\(course.name!)\n@\n\(section.classroom!)"
            label.numberOfLines = 6
            label.font = UIFont.systemFont(ofSize: 10)
            label.textAlignment = .left
            label.textColor = UIColor.white
//            label.tag = self.sections.firstIndex(of: section)!
            
            return label
        }()
        courseView.addSubview(courseInfoLabel)
        
        courseCollectionView.addSubview(courseView)
    }
    
    func drawCurrentTimeLine() {
        func getLoc() -> CGFloat {
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
            
            return 0
        }
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: getLoc()))
        linePath.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: getLoc()))
        timeLine.path = linePath.cgPath
        
        courseCollectionView.layer.addSublayer(timeLine)
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
            if indexPath.row == 0 {
                return CGSize(width: sectionIdxWidth, height: dateCollectionHeight)
            } else {
                return CGSize(width: (SCREEN_WIDTH - CGFloat(sectionIdxWidth)) / 7, height: dateCollectionHeight)
            }
        case COURSE_COLLECTION_VIEW_TAG:
            let courseCellRowHeight = CGFloat(SCREEN_HEIGHT * 0.9 / CGFloat(Section.sectionNumber))
            if indexPath.row % 8 == 0 {  // Section idx.
                return CGSize(width: CGFloat(sectionIdxWidth), height: courseCellRowHeight)
            } else {  // Course.
                courseCellSize =  CGSize(width: (SCREEN_WIDTH - sectionIdxWidth) / 7, height: courseCellRowHeight)
                return courseCellSize
            }
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}
