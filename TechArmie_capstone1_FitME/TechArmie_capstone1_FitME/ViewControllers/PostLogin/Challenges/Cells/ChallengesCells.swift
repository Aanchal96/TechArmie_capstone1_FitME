//
//  ChallengesCells.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 31/07/22.
//

import UIKit


class NewChallengeTableViewCell: UITableViewCell {
    
    //MARK: OUTLETS
    @IBOutlet weak var lblChallengeType: UILabel!
    @IBOutlet weak var lblChallengeDescription: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: PROPERTIES
    var challengeModel: ChallengeModel? {
        didSet{
            guard let challengeModel = challengeModel else {return}
            self.collectionView.reloadData()
            lblChallengeType.text = challengeModel.levelName
            lblChallengeDescription.text = challengeModel.description
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - CELL CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

//MARK: - COLLECTION VIEW DELEGATE, DATASOURCE & FLOW LAYOUT
extension NewChallengeTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.challengeModel?.challengeList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewChallengeCollectionViewCell.className, for: indexPath) as? NewChallengeCollectionViewCell else { return UICollectionViewCell()
        }
        cell.challenge = self.challengeModel?.challengeList[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 185)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ChallengeDetailVC.instantiate(fromAppStoryboard: .Challenges)
        vc.challenge = self.challengeModel?.challengeList[indexPath.item]
        vc.level = lblChallengeType.text ?? ""
        UIApplication.topMostVC?.navigationController?.pushViewController(vc, animated: true)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 11, bottom: 0, right: 12)
    }
}

class NewChallengeCollectionViewCell: UICollectionViewCell {
    
    //MARK::- OUTLETS
    @IBOutlet weak var imgChallenge: UIImageView!
    @IBOutlet weak var viewIsJoined: UIView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewIsJoined.isHidden = true
    }
    
    //MARK::- PROPERTIES
    var challenge : Challenge?{
        didSet{
            guard let challenge = challenge else {return}
            lblName.text = challenge.challengeName
            imgChallenge.sd_setImage(with: URL.init(string: challenge.media.first?.mediaUrl ?? ""))
            let joinedChallengeId = AppUserDefaults.value(forKey: .currentChallengeID).string ?? ""
            viewIsJoined.isHidden =  !(challenge.id == joinedChallengeId)
        }
    }
    
}

class ChallengeDetailCollectionCell : UICollectionViewCell{
    
    //MARK::- OUTLETS
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var imgGreenTick: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var viewTick: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK::- Function
    func configure(item : WorkoutModel?, isCompleted: Bool){
        lblDay.text = item?.dayNo.description
        imgGreenTick.isHidden = !isCompleted
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        bgView.layer.cornerRadius =  23
        viewTick.layer.cornerRadius =  20

    }
}
