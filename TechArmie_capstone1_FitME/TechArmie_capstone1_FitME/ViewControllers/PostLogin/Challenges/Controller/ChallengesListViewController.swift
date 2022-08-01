//
//  ChallengesListViewController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 31/07/22.
//

import UIKit
import SwiftyJSON


class ChallengesListViewController: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var TitleLbl: UILabel!
    
    //MARK: - PROPERTIES
    private var challengeModel : [ChallengeModel]?
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
        mainTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = true
    }
}

//MARK: - FUNCTIONS
private extension ChallengesListViewController {
    func onViewDidLoad(){
        mainTableView.delegate = self
        mainTableView.dataSource = self
        fetchData()
    }
    
    
    func fetchData() {
        var json = JSON()
        if let path = Bundle.main.path(forResource: "ChallengesData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObject =  try JSONSerialization.jsonObject(with: data , options: JSONSerialization.ReadingOptions.mutableContainers)
                if let jsonDict = jsonObject as? [String: AnyObject] {
                    json = JSON(jsonDict)
                    self.challengeModel = json[ApiKey.result][ApiKey.data].arrayValue.map({ChallengeModel($0)})
                    self.mainTableView.reloadData()
                }
            } catch {
                printDebug("error")
            }
        }
    }
}

//MARK::- TABLE VIEW DELEGATES
extension ChallengesListViewController: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = challengeModel?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewChallengeTableViewCell.className, for: indexPath) as? NewChallengeTableViewCell else {
            return UITableViewCell()
        }
        cell.challengeModel = self.challengeModel?[indexPath.row]
        return cell
    }
}
