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
    private var networkError : NetworkErrorView?
    var isStatusBarWhite = false{
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    var networkErrorPageWillShow : Bool = false{
        didSet{
            networkErrorHandling()
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
        self.initialSetup()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.onViewAppear()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return self.isStatusBarWhite ? .lightContent : .darkContent
        } else {
            // Fallback on earlier versions
            return self.isStatusBarWhite ? .lightContent : .default
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // AppNetworking.reachability.stopListening()
    }
    
    // Network error call back
    func networkErrorRetryBtnTapped(retryButton: UIButton){
        printDebug("Retry tapped" )
    }
    
    // network status change call back
    func networkStatusUpdated(networkAvailable: Bool) {
        
    }
    
    deinit {
        printDebug("Deinit ==> \(self)")
    }
}

// MARK:- Private Functions
// ==========================
extension BaseVC {
    private func initialSetup() {
        
        self.setNetworkNotifier()
    }
    func onViewAppear(){
        self.setupNetworkErrorView(willSetupPage: networkErrorPageWillShow)
        self.view.endEditing(true)
    }
}

// MARK:- Functions
// ==================
extension BaseVC {
    
    func onDidLayoutSubviews(){
        guard let headerView = tableView?.tableHeaderView else {return}
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableView?.tableHeaderView = headerView
            tableView?.layoutIfNeeded()
        }
        guard let footerView = tableView?.tableFooterView else {return}
        let sizeF = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if footerView.frame.size.height != sizeF.height {
            footerView.frame.size.height = sizeF.height
            tableView?.tableFooterView = footerView
            tableView?.layoutIfNeeded()
        }
    }
}

//MARK:- Navigation Helping methods
//======================================
extension BaseVC{
    
    // Present view controllerUIView.layoutFittingCompressedSize
    func presentToViewController<T: UIViewController>(viewControllerClass: T.Type, storyBoardNameIfNotCurrent: AppStoryboard? = nil, modalPresentationStyle: UIModalPresentationStyle = .fullScreen, animated: Bool = true ,passData: ((T)->())? = nil, completetion: (()->())? = nil){
        
        var presentStoryboard = UIStoryboard()
        if let storyboardName = storyBoardNameIfNotCurrent {
            
            presentStoryboard = storyboardName.instance
        }else{
            guard let storyboardID = self.storyboard else { return}
            presentStoryboard = storyboardID
        }
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        if let obj = presentStoryboard.instantiateViewController(withIdentifier: storyboardID) as? T{
            if let passDatatoVC = passData{
                passDatatoVC(obj)
            }
            obj.modalPresentationStyle = modalPresentationStyle
            self.present(obj, animated: animated) {
                completetion?()
            }
        }
    }
    
    // Push view controller in navigation
    func navigateToViewController<T: UIViewController>(viewControllerClass: T.Type, pushToParent: Bool = false, storyBoardNameIfNotCurrent: AppStoryboard? = nil, animated: Bool = true,  passData: ((T)->())? = nil){
        
        var presentStoryboard = UIStoryboard()
        if let storyboardName = storyBoardNameIfNotCurrent {
            
            presentStoryboard = storyboardName.instance
        }else{
            guard let storyboardID = self.storyboard else { return}
            presentStoryboard = storyboardID
        }
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        if let obj = presentStoryboard.instantiateViewController(withIdentifier: storyboardID) as? T{
            if let passDatatoVC = passData{
                passDatatoVC(obj)
            }
            //            self.navigationController?.pushViewController(obj, animated: true)
            if pushToParent{
                self.parent?.navigationController?.pushViewController(obj, animated: true)
            }else{
                self.pushVC(vc: obj, checkTopVC: true, animated: animated)
            }
        }
    }
    
    func pushVC<T: UIViewController>(vc: T, checkTopVC: Bool, animated: Bool) {
        let lastVC = self.navigationController?.viewControllers.last
        if (lastVC as? T) != nil {
        } else {
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
}

extension BaseVC{
    
    private func setNetworkNotifier() {
        
        // TODO: Uncomment
//        AppNetworking.reachability.startListening()
//        AppNetworking.reachability.listener = { [weak self] (networkStatus) in
//            guard let wSelf = self else{return}
//            if networkStatus == .notReachable {
//                wSelf.networkStatusUpdated(networkAvailable: false)
//            } else {
//                wSelf.networkStatusUpdated(networkAvailable: true)
//            }
//        }
    }
    
    private func setupNetworkErrorView(willSetupPage: Bool){
        
        if willSetupPage, self.networkError == nil{
            
            networkError = NetworkErrorView(frame: self.view.frame)
            
            networkError?.retryBtnTapped = {[weak self] (retryBtn) in
                guard let wSelf = self else {return}
                wSelf.networkErrorRetryBtnTapped(retryButton: retryBtn)
            }
            self.view.addSubview(networkError!)
            networkError?.bringSubviewToFront(view)
            self.view.layoutIfNeeded()
        }
        networkErrorHandling()
    }
    
    private func networkErrorHandling(){
        
        self.networkError?.isHidden = !self.networkErrorPageWillShow
        self.networkError?.viewNoInternet.isHidden = !self.networkErrorPageWillShow
    }
}
