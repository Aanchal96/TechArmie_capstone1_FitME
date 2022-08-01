//
//  NetworkErrorView.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 2022-07-15.
//

import UIKit


class NetworkErrorView: UIView {
    
    //MARK:- IBOutlets
    //=====================
    @IBOutlet var contentView           : UIView!
    @IBOutlet weak var viewNoInternet   : UIView!
    @IBOutlet weak var retryBtn         : UIButton!
    @IBOutlet weak var noConnectionLbl: UILabel!
    @IBOutlet weak var noConnectionDescLbl: UILabel!
    
    //MARK:- Varriable
    //=====================
    var retryBtnTapped : ((UIButton)->())?
    
    //MARK:- IBAction
    //=====================
    @IBAction func btnActionRetry(_ sender: UIButton) {
        
        guard let retry = retryBtnTapped else {return}
        return retry(sender)
    }
    
    //MARK::- Life Cyle
    //=========================
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Setup view from .xib file
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Setup view from .xib file
        commonInit()
    }
    //MARK::- FUNCTIONS
    //======================
    func commonInit() {
        Bundle.main.loadNibNamed(NetworkErrorView.className, owner: self, options: nil)
        contentView.fixInView(self)
        noConnectionLbl.text = LocalizedString.noInternetConnection.localized
        noConnectionDescLbl.text = LocalizedString.checkConnectionDesc.localized
        retryBtn.setTitle(LocalizedString.retry.localized, for: .normal)
    }
}
