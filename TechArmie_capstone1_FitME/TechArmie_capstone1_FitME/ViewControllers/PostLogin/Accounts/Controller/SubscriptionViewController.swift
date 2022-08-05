//
//  ViewController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Vir Davinder Singh on 2022-08-04.
//

import Foundation
import UIKit
class SubscriptionViewController : BaseVC {
     
    @IBOutlet weak var btnBack: UIImageView!
    @IBOutlet weak var btnGoPremium: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        addTapsOnView()
      }
    
    @objc func btnBackTap(tapGestureRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    @IBAction func goForPremium(_ sender: Any) {
        
    }
}
extension SubscriptionViewController{
    func addTapsOnView(){
        let btnBackTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(btnBackTap(tapGestureRecognizer:)))
        
        btnBack.isUserInteractionEnabled = true
        btnBack.addGestureRecognizer(btnBackTapGestureRecognizer)
    }
}

    
    

