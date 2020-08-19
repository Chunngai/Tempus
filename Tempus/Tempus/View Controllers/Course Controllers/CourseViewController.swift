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
    
    var sections = [
        Section(course: Course(name: "C++", instructor: "Ms Zhou"), weekday: 1, start: 1, end: 2, classroom: "教103"),
        Section(course: Course(name: "Java", instructor: "Mr Luo"), weekday: 3, start: 3, end: 4, classroom: "实507")
    ]
    
    // MARK: Views

    lazy var dateCollectionView: UICollectionView = {
        var collectionView = UICollectionView(
            frame: CGRect(
                x: 0,
                y: navigationController!.navigationBar.frame.maxY + navigationController!.navigationBar.frame.height,
                width: view.frame.width,
                height: 30
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
    
    lazy var courseCollectionView: UICollectionView = {
        var collectionView = UICollectionView(
            frame: CGRect(
                x: 0,
                y: navigationController!.navigationBar.frame.maxY + navigationController!.navigationBar.frame.height + 30,
                width: view.frame.width,
                height: view.frame.height - navigationController!.navigationBar.frame.maxY - navigationController!.navigationBar.frame.height - tabBarController!.tabBar.frame.height - 30
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
    
    var line: CAShapeLayer = {
        let line = CAShapeLayer()
        
        line.strokeColor = UIColor.white.cgColor
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

        for section in sections {
            drawCourse(section)
        }
        
        drawLine()
    }
    
    // MARK: Customized init
    
    func updateViews() {
        navigationItem.title = "Course"
        
        // Collection Views.
        view.addSubview(dateCollectionView)
        view.addSubview(courseCollectionView)
    }
    
    // MARK: - Customized funcs
    
    func drawCourse(_ section: Section) {
        let courseView: UIView = {
            let view = UIView(
                frame: CGRect(
                    x: CGFloat(sectionIdxWidth) + CGFloat(section.weekday - 1) * courseCellSize.width,
                    y: CGFloat(section.start - 1) * courseCellSize.height,
                    width: courseCellSize.width,
                    height: courseCellSize.height * CGFloat(section.end - section.start + 1)
                )
            )
            
            view.alpha = 0.8
            
            return view
        }()

        let courseInfoLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: 0, y: 2, width: courseView.frame.size.width - 2, height: courseView.frame.size.height))
            
            label.numberOfLines = 5
            label.font = UIFont.systemFont(ofSize: 12)
            label.textAlignment = .left
            label.textColor = UIColor.white
            label.text = "\(section.course.name!)\n@\(section.classroom!)"
            label.tag = self.sections.firstIndex(of: section)!
            label.layer.cornerRadius = 10
            label.layer.masksToBounds = true
            label.backgroundColor = courseCellColor
            
            return label
        }()
        courseView.addSubview(courseInfoLabel)
        
//        self.view.insertSubview(courseView, aboveSubview: courseCollectionView)
        courseCollectionView.addSubview(courseView)
    }
    
    func drawLine() {
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
        line.path = linePath.cgPath
        
        courseCollectionView.layer.addSublayer(line)
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
            
            cell.dateLabel.text = indexPath.row != 0 ? shortWeekdaySymbolsStartingFromMonday[indexPath.row - 1] : ""
            
            return cell
        case COURSE_COLLECTION_VIEW_TAG:
            if indexPath.row % 8 == 0 {  // Section idx.
                let idx = Int(indexPath.row / (shortWeekdaySymbolsStartingFromMonday.count + 1) + 1)
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "courseDateCollectionViewCell", for: indexPath) as! CourseDateCollectionViewCell
                
                cell.dateLabel.text = "\(idx)"
                cell.startTimeLabel.text = Section.time[idx]?.start.formattedTime()
                
                return cell
            } else {  // Course.
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "courseCourseCollectionViewCell", for: indexPath) as! CourseCourseCollectionViewCell
                
                cell.courseLabel.text = ""
                
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
                return CGSize(width: sectionIdxWidth, height: 30)
            } else {
                return CGSize(width: (SCREEN_WIDTH - CGFloat(sectionIdxWidth)) / 7, height: 30)
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
