//
//  ExerciseLibraryViewController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 31/07/22.
//

import UIKit
import SDWebImage
import IBAnimatable
import AVKit
import SwiftyJSON

final class ExerciseLibraryViewController: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var viewUnderLine: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var heightTop: NSLayoutConstraint!
    
    //MARK::- PROPERTIES
    private var model : [ExerciseDetailModel] = []
    private var filteredModel : [ExerciseDetailModel] = []
    private var categoryData : [ExerciseLibraryModel] = []

    private var selectedIndex = -1
    
    //MARK::- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
    }
    
    //MARK::- BUTTON ACTION
    @IBAction func btnActionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func txtActionEditingEnd(_ sender: Any) {
        getFilteredData()
    }
}

//MARK::- FUNCTIONS
private extension ExerciseLibraryViewController {
    func onViewDidLoad(){
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        getDataFromJSON()
    }
    
    func widthOfText(str: String, _ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let boundingBox = str.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.width
    }
}

//MARK::- TABLE VIEW DELEGATE AND DATASOURCE
extension ExerciseLibraryViewController : UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.filteredModel.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseLibraryCell.className, for: indexPath) as? ExerciseLibraryCell else {
            return UITableViewCell()
        }
        cell.lblName.text = self.filteredModel[indexPath.row].exerciseName
        cell.lblExerciseType.text = self.filteredModel[indexPath.row].nameCategory
        cell.imgExercise.sd_setImage(with: URL.init(string: self.filteredModel[indexPath.row].media.first?.mediaUrlThumb1 ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // open native player
        guard let videoURL = URL(string: self.filteredModel[indexPath.row].media.first?.mediaUrl ?? "") else {return}
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }
}

// MARK:- COLLECTION VIEW DELEGATE, DATASOURCE & FLOW LAYOUT
extension ExerciseLibraryViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExerciseCategoryCollectionCell.className, for: indexPath) as? ExerciseCategoryCollectionCell else { return UICollectionViewCell()
        }
        cell.lblTitle?.text = self.categoryData[indexPath.item].categoryName
        cell.isSelect = indexPath.item == self.selectedIndex
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = widthOfText(str: self.categoryData[indexPath.item].categoryName , 20.0, font: AppFonts.semibold.withSize(15.0)) + 20
        return CGSize(width: width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.selectedIndex == indexPath.item {
            self.selectedIndex = -1
        }else{
            self.selectedIndex = indexPath.item
        }
       getFilteredData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}


//MARK::- API

extension ExerciseLibraryViewController {
    func getDataFromJSON() {
        var json = JSON()
        if let path = Bundle.main.path(forResource: "ExerciseLibraryData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObject =  try JSONSerialization.jsonObject(with: data , options: JSONSerialization.ReadingOptions.mutableContainers)
                if let jsonDict = jsonObject as? [String: AnyObject],
                   let exerciseLibData = jsonDict["exerciseLibrary"] as? [String: Any] {
                    json = JSON(exerciseLibData)
                    self.handleSuccess(
                        model: json[ApiKey.libraryData][ApiKey.data].arrayValue.map({ExerciseDetailModel($0)}),
                        categoryData: json[ApiKey.categoryData].arrayValue.map({ExerciseLibraryModel($0)})
                    )
                }
            } catch {
                printDebug("error")
            }
        }
    }
    
    func getFilteredData() {
        self.filteredModel = model
        if selectedIndex != -1 {
            self.filteredModel = self.model.filter({ model in
                model.nameCategory == self.categoryData[selectedIndex].categoryName
            })
        }
        if !(searchBar.text ?? "").isEmpty {
            self.filteredModel = self.filteredModel.filter({ model in
                model.exerciseName.contains(s: (searchBar.text ?? ""))
            })
        }
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }
    
    func handleSuccess(model: [ExerciseDetailModel], categoryData: [ExerciseLibraryModel]) {
        viewUnderLine.isHidden = false
        self.categoryData = categoryData
        self.model = model
        getFilteredData()
        self.collectionView.reloadData()
        self.tableView.reloadData()
        
    }
}

//MARK:- SEARCH BAR DELEGATE
extension ExerciseLibraryViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getFilteredData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        getFilteredData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.endEditing(true)
        getFilteredData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        self.heightTop.constant = 0
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.heightTop.constant = 52

        if let search = searchBar.text, search.isEmpty {
            getFilteredData()
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}

