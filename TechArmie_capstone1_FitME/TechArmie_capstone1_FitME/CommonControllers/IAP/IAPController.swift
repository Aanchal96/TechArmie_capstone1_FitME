//
//  IAPController.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 2022-07-15.
//

import Foundation
import UIKit
import StoreKit

class IAPController: NSObject {
    
    fileprivate enum IAPRequestType {
        
        case fetchProduct
        case restoreProduct
        case purchaseProduct
        case fetchReceipt
        case none
    }
    
    // MARK: - Check if payment can be made.
    class var canMakePayment:Bool {  return SKPaymentQueue.canMakePayments()  }
    
    // MARK: - Shared instance
    static let shared : IAPController = {
        let instance = IAPController()
        return instance
    }()
    
    // MARK: - Completion block to notify reciver about fetched products from Appstore.
    fileprivate var fetchedProductsCompletionBlock:((_ product:[SKProduct])->Void)!
    
    // MARK: - Completion block to notify reciver about purchased, restored and failed products.
    fileprivate var purchaseCompletionBlock:((_ purchasedPID:Set<String>,_ restoredPID:Set<String>,_ failedPID:Set<String>)->Void)!
    
    // MARK: - Completion block to notify reciver about the error causing failure.
    fileprivate var recieptFailureBlock:((_ error:Error?)->Void)!
    fileprivate var productFetchFailureBlock:((_ error:Error?)->Void)!
    fileprivate var productRestoreFailureBlock:((_ error:Error?)->Void)!
    
    fileprivate var fetchReceiptBlock:((_ recipt:[AnyHashable:Any] , _ reciptToken: String)->Void)!
    fileprivate var sharedSecrete:String?
    var shouldAddStorePaymentHandler:((_ payment: SKPayment, _ product: SKProduct) -> Bool)?
    
    // MARK: - URL for app receipt.
//    fileprivate let appReceiptURL = Bundle.main.appStoreReceiptURL
    fileprivate var appReceiptURL : URL? {
        return Bundle.main.appStoreReceiptURL
    }
    
    // MARK: - URL to validate app receipt
    #if DEBUG
    fileprivate let receiptValidationURLString = "https://sandbox.itunes.apple.com/verifyReceipt"
    #else
    fileprivate let receiptValidationURLString = "https://buy.itunes.apple.com/verifyReceipt"
    #endif
    
    fileprivate var iapRequestType:IAPRequestType = .none
    
    // MARK: - Fetch available In App Purchase products
    func fetchAvailableProducts(productIdentifiers:Set<String>, success:@escaping ((_ product:[SKProduct])->Void), failure:@escaping ((_ error:Error?)->Void))  {
        CommonFunctions.showActivityLoader()
        fetchedProductsCompletionBlock = success
        productFetchFailureBlock = failure
        iapRequestType = .fetchProduct
        let iapProductsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        iapProductsRequest.delegate = self
        iapProductsRequest.start()
    }
    
    // MARK: - Purchase an In App Purchase product
    func purchaseProduct(product: SKProduct,
                         completion:@escaping ((_ purchasedPID:Set<String>,_ restoredPID:Set<String>,_ failedPID:Set<String>)->Void)) {
        
        iapRequestType = .purchaseProduct
        if IAPController.canMakePayment {
            purchaseCompletionBlock = completion
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            CommonFunctions.showToastWithMessage("Purchase failed", completion: nil)
            return
        }
    }
    
    // MARK: - Restore In App Purchase products
    func restoreIAPProducts(success:@escaping ((_ purchasedPID:Set<String>,_ restoredPID:Set<String>,_ failedPID:Set<String>)->Void), failure:@escaping ((_ error:Error?)->Void)){
        CommonFunctions.showActivityLoader()
        purchaseCompletionBlock = success
        productRestoreFailureBlock = failure
        iapRequestType = .restoreProduct
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // MARK: - Fetch latest app receipt
    func fetchIAPReceipt(forceRefresh:Bool = false, sharedSecrete:String?, success:@escaping ((_ receipt:[AnyHashable:Any],_ reciptToken: String)->Void),
                         failure:@escaping ((_ error:Error?)->Void)) {
        
        fetchReceiptBlock = success
        recieptFailureBlock = failure
        iapRequestType = .fetchReceipt
        self.sharedSecrete = sharedSecrete
        
        if forceRefresh {
            refreshReceipt()
        }
        else{
            guard let receiptURL = appReceiptURL else {  refreshReceipt()
                /* receiptURL is nil, it would be very weird to end up here */  return }
            do {
                let receipt = try Data(contentsOf: receiptURL)
                validateReceipt(receipt)
            } catch {
                // there is no app receipt, don't panic, ask apple to refresh it
                refreshReceipt()
            }
        }
    }
    
    // MARK: - Refresh reciept by fetching latest one from Appstore
    fileprivate func refreshReceipt(){
        
        iapRequestType = .fetchReceipt
        let appReceiptRefreshRequest = SKReceiptRefreshRequest(receiptProperties: nil)
        appReceiptRefreshRequest.delegate = self
        appReceiptRefreshRequest.start()
        // If all goes well control will land in the requestDidFinish() delegate method.
        // If something bad happens control will land in didFailWithError.
    }
    
    // MARK: - validate reciept from Appstore
    fileprivate func validateReceipt(_ receipt: Data) {
        
        func errorOccured(reason:String){
            let error = NSError(domain: reason, code: 500, userInfo: [NSLocalizedDescriptionKey:reason])
            recieptFailureBlock?(error as Error)
        }
        
        let base64encodedReceipt = receipt.base64EncodedString()
        self.fetchReceiptBlock?([:],base64encodedReceipt)

    }
    
    // MARK: - Verify if a product purchased is stil valid or not.
    func verifyProduct(
        type: SubscriptionType,
        productId: String, receipt: ReceiptInfo) -> VerifySubscriptionResult{
        
        let result = InAppReceipt.verifySubscription(type: type, productId: productId, inReceipt: receipt)
        NSLog("\(result)")
        return result
    }
}

// MARK: - SKProductsRequestDelegate delegate methods
extension IAPController:SKProductsRequestDelegate{
    
    //MARK: - Accepts the response from the App Store that contains the requested product information.
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
       
        fetchedProductsCompletionBlock?(response.products)
    }
    
    // MARK: - Tells the delegate that the request has completed.
    func requestDidFinish(_ request: SKRequest) {
        
        if iapRequestType == .fetchReceipt{
            // a fresh receipt should now be present at the url
            do {
                let receipt = try Data(contentsOf: appReceiptURL!) //force unwrap is safe here, control can't land here if receiptURL is nil
                validateReceipt(receipt)
            } catch {
                // still no receipt, possible but unlikely to occur since this is the "success" delegate method
            }
        }
    }
    //MARK: - Tells the delegate that the request failed to execute.
    func request(_ request: SKRequest, didFailWithError error: Error) {
        
        switch iapRequestType {
        case .fetchReceipt:
            recieptFailureBlock?(error)
        case .fetchProduct:
            productFetchFailureBlock?(error)
        case .restoreProduct:
            productRestoreFailureBlock?(error)
        default:
            break
        }
    }
}

// MARK: - SKPaymentTransactionObserver delegate methods
extension IAPController:SKPaymentTransactionObserver{
    
    //MARK: - Tells the observer that the payment queue has finished sending restored transactions.
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        CommonFunctions.hideActivityLoader()
      //  CommonFunctions.showToastWithMessage(LocalizedString.restoreCompleted.localized, completion: nil)
       
    }
    
    //MARK: - Tells the observer that an error occurred while restoring transactions.
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        CommonFunctions.hideActivityLoader()
        switch iapRequestType {
        case .restoreProduct:
            productRestoreFailureBlock?(error)
        default:
            break
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return shouldAddStorePaymentHandler?(payment, product) ?? false
    }
    //MARK: - Tells an observer that one or more transactions have been updated.
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        var purchasedPID:Set<String> = []
        var restoredPID:Set<String> = []
        var failedPID:Set<String> = []
        var shouldFireCompletionHandler = false
        for transaction in transactions {
            switch transaction.transactionState{
            case .purchased:
                purchasedPID.insert(transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
                shouldFireCompletionHandler = true
            case .restored:
                restoredPID.insert(transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
                shouldFireCompletionHandler = true
            case .failed:
                failedPID.insert(transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
                shouldFireCompletionHandler = true
            default:
                break
            }
        }
        if shouldFireCompletionHandler{
            purchaseCompletionBlock?(purchasedPID,restoredPID,failedPID)
        }
    }
}
