//
//  BaseVC.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 2022-07-30.
//

import UIKit

class BaseVC: UIViewController {
    
    // MARK:- Variables
    // ==================
    var isStatusBarWhite = true{
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    // MARK:- IBOutlets
    // ==================
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK:- Life Cycle
    // ===================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isStatusBarWhite = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return self.isStatusBarWhite ? .lightContent : .darkContent
        } else {
            // Fallback on earlier versions
            return self.isStatusBarWhite ? .lightContent : .default
        }
    }

    deinit {
        printDebug("Deinit ==> \(self)")
    }
}
