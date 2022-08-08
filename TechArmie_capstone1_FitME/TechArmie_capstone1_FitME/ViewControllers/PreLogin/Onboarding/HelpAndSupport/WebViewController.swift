//
//  TermsAndConditionsViewController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Bhautik Pethani on 2022-08-04.
//

import UIKit
import WebKit

enum WebViewType: String{
    case tnc = "Terms and Conditions"
    case privacyPolicy = "Privacy Policy"
}

class WebViewController: UIViewController, WKUIDelegate {

    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var urlType: WebViewType = .tnc
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        addTapsOnView()
        
        titleLabel.text = urlType.rawValue
        
        var myURL: URL!
        myURL = URL(string: urlType == .tnc ? AppConstants.tncURL : AppConstants.privacyPolicy)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    @objc func backButtonTap(tapGestureRecognizer: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension WebViewController{
    func addTapsOnView(){
        let backButtonTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backButtonTap(tapGestureRecognizer:)))
        
        backButton.isUserInteractionEnabled = true
        backButton.addGestureRecognizer(backButtonTapGestureRecognizer)
    }
}
