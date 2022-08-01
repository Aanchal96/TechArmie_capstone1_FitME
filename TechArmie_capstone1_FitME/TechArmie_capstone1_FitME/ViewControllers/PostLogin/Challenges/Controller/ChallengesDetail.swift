//
//  ChallengesDetail.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 31/07/22.
//


import UIKit

import SwiftyJSON

class ChallengeDetailVC: UIViewController {
    
    //MARK::- OUTLETS
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgChallenge: UIImageView!
    @IBOutlet weak var imgChallengeBg: UIImageView!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblLevel: UILabel!
    @IBOutlet weak var bottomBackgroundView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    
    //MARK::- PROPERTIES
    var challenge : Challenge?
    var level = ""
    var currentDay = 1
    
    //MARK::- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
        onViewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.layoutIfNeeded()
    }

    //MARK::- BUTTON ACTION
    @IBAction func btnActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnActionStart(_ sender: Any) {
        if currentDay > 30 {
            AppUserDefaults.removeValue(forKey: .currentChallengeDay)
        }
        let vc = ChallengeWorkoutDetailVC.instantiate(fromAppStoryboard: .Challenges)
        vc.challengeData = self.challenge
        vc.workoutData = self.challenge?.result.workoutData
        self.navigationController?.pushViewController(vc, animated: true)

    }
}

//MARK::- FUNCTIONS

extension ChallengeDetailVC {
    func onViewDidLoad(){
        lblLevel.text = level
        self.lblTitle.text = self.challenge?.challengeName ?? ""
        lblDescription.text = self.challenge?.description ?? ""
        imgChallenge.sd_setImage(with: URL(string: challenge?.media.first?.mediaUrl ?? ""))
        imgChallenge.isHidden = false
        bottomBackgroundView.isHidden = false
        scrollView.isHidden = false
        collectionView.isHidden = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
        currentDay = (AppUserDefaults.value(forKey: .currentChallengeDay).int ?? 1)
        let currentChallengeID = (AppUserDefaults.value(forKey: .currentChallengeID).string ?? "")
        if (self.challenge?.id ?? "" ) == currentChallengeID {
            btnStart.setTitle("Start Day \(currentDay)", for: .normal)
            if currentDay > 30 {
                btnStart.setTitle("Restart", for: .normal)
            }
        } else {
            currentDay = 1
            btnStart.setTitle("Join and Start Day \(currentDay)", for: .normal)
        }
    }
}

//MARK: - COLLECTION VIEW DELEGATE, DATASOURCE & FLOW LAYOUT
extension ChallengeDetailVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.challenge?.workoutData.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeDetailCollectionCell.className, for: indexPath) as? ChallengeDetailCollectionCell else { return UICollectionViewCell()
        }
        let currentDay = AppUserDefaults.value(forKey: .currentChallengeDay).int ?? 1
        let currentJoinedChallenge = AppUserDefaults.value(forKey: .currentChallengeID).stringValue
        if (self.challenge?.id ?? "") == currentJoinedChallenge {
            cell.configure(item :self.challenge?.workoutData[indexPath.item], isCompleted: indexPath.item < currentDay - 1)
        } else {
            cell.configure(item :self.challenge?.workoutData[indexPath.item], isCompleted: false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 80) / 5
        return CGSize(width: width, height:  62)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
