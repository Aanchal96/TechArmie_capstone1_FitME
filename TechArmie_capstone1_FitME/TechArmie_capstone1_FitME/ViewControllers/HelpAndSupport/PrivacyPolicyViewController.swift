//
//  PrivacyPolicyViewController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Bhautik Pethani on 2022-08-04.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController, WKUIDelegate {

    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addTapsOnView()
        
        var myURL: URL!
        myURL = URL(string: "https://fitme.test-project.link/privacy.html")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    @objc func backButtonTap(tapGestureRecognizer: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension PrivacyPolicyViewController{
    func addTapsOnView(){
        let backButtonTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backButtonTap(tapGestureRecognizer:)))
        
        backButton.isUserInteractionEnabled = true
        backButton.addGestureRecognizer(backButtonTapGestureRecognizer)
    }
}
