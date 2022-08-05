//
//  ViewController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Vir Davinder Singh on 2022-08-04.
//

import Foundation
import UIKit
class SubscriptionViewController : BaseVC {
    
    
    //MARK::- OUTLETS
    @IBOutlet weak var videoView: VideoView!
    
    
    //MARK::- PROPERTIES
    
    //MARK::- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = Bundle.main.url(forResource: "subcription", withExtension: ".mp4")  else {return}
        videoView.configure(url: url)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(appWillEnterForegroundNotification),
//                                               name: .UIApplicationWillEnterForeground, object: nil)
        //configureCollectionView()
       // onViewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        videoView.play()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        videoView.stop()
    }
    //MARK::- BUTTON ACTIONS
    @IBAction func btnActionBack(_ sender: Any) {
       self.dismissVC(completion: nil)
    }
    
    @objc func appWillEnterForegroundNotification() {
        videoView.play()
    }
    var cardUserNameArr: [String] = [
                                     LocalizedString.sofia.localized ,
                                     LocalizedString.mike.localized ,
                                     LocalizedString.emily.localized ,
                                     LocalizedString.noah.localized,
                                     LocalizedString.cooper.localized
    ]
    
    var cardCmtArr : [String] = [
        LocalizedString.greatWorkOuts.localized ,
                                 LocalizedString.bestApp.localized ,
                                 LocalizedString.reallyWorkOnMe.localized ,
                                 LocalizedString.easyToTrackCalories.localized,
                                 LocalizedString.loveThisApp.localized
    ]
    
    
    var cardDescArr : [String] = [
                                    LocalizedString.iHaveOnlyHadThisAppForFewWeek.localized ,
                                  LocalizedString.reallyEnjoyingThisAppSoFar.localized ,
                                  LocalizedString.IHaveBeenLovingThisAppFor.localized ,
                                  LocalizedString.theAbilityToScanAndDetect.localized,
                                  LocalizedString.iReallyEnjoyUsingTheFitMEApp.localized
    ]
    var totalNumberOfCards = 100
}
// first  - configure collectionview
//extension SubscriptionViewController {
//    func configureCollectionView(){
//        collectionViewDataSource = CollectionViewDataSource.init(noOfRows: totalNumberOfCards, items: self.arrTitles as Array<AnyObject>, collectionView: collectionView, cellIdentifier: NewSubscriptionCell.className, headerIdentifier: nil, cellHeight: 190, cellWidth: collectionView.frame.size.width, cellSpacing: 0, configureCellBlock: { [weak self] (cell, item, indexPath) in
//            let row = indexPath.item % (self?.arrTitles.count ?? 0)
//            guard let cell = cell as? NewSubscriptionCell else {return}
//            ez.runThisInMainThread { [weak self] in
//                let str = NSMutableAttributedString.init(attributedString: cell.lblSubTitle.attributedText ?? NSAttributedString.init())
//
//                str.mutableString.setString(self?.arrSubTitles[row] ?? "")
//                let paragraph = NSMutableParagraphStyle()
//                paragraph.alignment = CommonFunctions.getLang() == AppLanguage.en ? .left  : .right
//                paragraph.lineSpacing = 6
//                str.addAttribute(.paragraphStyle, value: paragraph, range: str.mutableString.range(of: str.mutableString as String, options: .caseInsensitive))
//                cell.lblSubTitle.attributedText = str
//                cell.lblTitle.text = self?.arrTitles[row] ?? ""
//            }
//            cell.imgIcon.image = self?.arrIcons[row]
//            }, aRowSelectedListener: nil, willDisplayCell: nil, scrollViewListener: { [weak self] (scrollView) in
//                guard let origin = self?.collectionView?.contentOffset else{return}
//                guard let size = self?.collectionView?.bounds.size else{return}
//                let visibleRect = CGRect(origin: origin, size: size )
//                let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//                let indexPath = self?.collectionView?.indexPathForItem(at: visiblePoint)
//                let row = (indexPath?.item ?? 0) % (self?.arrTitles.count ?? 0)
//                self?.pageControl?.currentPage = CommonFunctions.getLang() == AppLanguage.ar ? ((self?.arrTitles.count ?? 0)-row-1) : row
//                if (indexPath?.item ?? 0) == ((self?.totalNumberOfCards ?? 1)-1){
//                    self?.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
//                    self?.pageControl?.currentPage = CommonFunctions.getLang() == AppLanguage.ar ? (self?.arrTitles.count ?? 0) : 0
//                }
//        })
//    }
//}
//    extension SubscriptionViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
//
//        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            return cardUserNameArr.count
//        }
//
//        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            let cell = collectionView.dequeueCell(with: SubscriptionRatingCell.self, indexPath: indexPath)
//            cell.popluateData(name: cardUserNameArr[indexPath.row], comment: cardCmtArr[indexPath.row], desc: cardDescArr[indexPath.row])
//            return cell
//        }
//
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//            return CGSize(width: 284, height: collectionView.frame.height)
//        }
//
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//           return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
//        }
//    }
    
    

