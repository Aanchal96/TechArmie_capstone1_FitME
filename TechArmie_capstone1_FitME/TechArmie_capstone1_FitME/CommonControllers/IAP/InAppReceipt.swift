//
//  InAppReceipt.swift
//  TechArmie_capstone1_FitME
//
//  Created by Aanchal Bansal on 2022-07-15.
//

import Foundation
import Foundation

public typealias ReceiptInfo = [String: Any]
// Verify subscription result
public enum VerifySubscriptionResult {
    case purchased(expiryDate: Date?, items: [ReceiptItem])
    case expired(expiryDate: Date, items: [ReceiptItem])
    case notPurchased
}

public enum SubscriptionType {
    case autoRenewable
    case nonRenewing(validDuration: TimeInterval)
    case consumable
    case nonConsumable
}

extension Date {
    
    init?(millisecondsSince1970: String) {
        guard let millisecondsNumber = Double(millisecondsSince1970) else {
            return nil
        }
        self = Date(timeIntervalSince1970: millisecondsNumber / 1000)
    }
}

public struct ReceiptItem {
    // The product identifier of the item that was purchased. This value corresponds to the productIdentifier property of the SKPayment object stored in the transaction’s payment property.
    public let productId: String
    // The number of items purchased. This value corresponds to the quantity property of the SKPayment object stored in the transaction’s payment property.
    public let quantity: Int
    // The transaction identifier of the item that was purchased. This value corresponds to the transaction’s transactionIdentifier property.
    public let transactionId: String
    // For a transaction that restores a previous transaction, the transaction identifier of the original transaction. Otherwise, identical to the transaction identifier. This value corresponds to the original transaction’s transactionIdentifier property. All receipts in a chain of renewals for an auto-renewable subscription have the same value for this field.
    public let originalTransactionId: String
    // The date and time that the item was purchased. This value corresponds to the transaction’s transactionDate property.
    public let purchaseDate: Date
    // For a transaction that restores a previous transaction, the date of the original transaction. This value corresponds to the original transaction’s transactionDate property. In an auto-renewable subscription receipt, this indicates the beginning of the subscription period, even if the subscription has been renewed.
    public let originalPurchaseDate: Date
    // The primary key for identifying subscription purchases.
    public let webOrderLineItemId: String?
    // The expiration date for the subscription, expressed as the number of milliseconds since January 1, 1970, 00:00:00 GMT. This key is only present for auto-renewable subscription receipts.
    public let subscriptionExpirationDate: Date?
    // For a transaction that was canceled by Apple customer support, the time and date of the cancellation. Treat a canceled receipt the same as if no purchase had ever been made.
    public let cancellationDate: Date?
    
    public let isTrialPeriod: Bool
}

extension ReceiptItem {
    
    public init?(receiptInfo: ReceiptInfo) {
        guard
            let productId = receiptInfo["product_id"] as? String,
            let quantityString = receiptInfo["quantity"] as? String,
            let quantity = Int(quantityString),
            let transactionId = receiptInfo["transaction_id"] as? String,
            let originalTransactionId = receiptInfo["original_transaction_id"] as? String,
            let purchaseDate = ReceiptItem.parseDate(from: receiptInfo, key: "purchase_date_ms"),
            let originalPurchaseDate = ReceiptItem.parseDate(from: receiptInfo, key: "original_purchase_date_ms")
            else {
                printDebug("could not parse receipt item: \(receiptInfo). Skipping...")
                return nil
        }
        self.productId = productId
        self.quantity = quantity
        self.transactionId = transactionId
        self.originalTransactionId = originalTransactionId
        self.purchaseDate = purchaseDate
        self.originalPurchaseDate = originalPurchaseDate
        self.webOrderLineItemId = receiptInfo["web_order_line_item_id"] as? String
        self.subscriptionExpirationDate = ReceiptItem.parseDate(from: receiptInfo, key: "expires_date_ms")
        self.cancellationDate = ReceiptItem.parseDate(from: receiptInfo, key: "cancellation_date_ms")
        if let isTrialPeriod = receiptInfo["is_trial_period"] as? String {
            self.isTrialPeriod = Bool(isTrialPeriod) ?? false
        } else {
            self.isTrialPeriod = false
        }
    }
    
    private static func parseDate(from receiptInfo: ReceiptInfo, key: String) -> Date? {
        
        guard
            let requestDateString = receiptInfo[key] as? String,
            let requestDateMs = Double(requestDateString) else {
                return nil
        }
        return Date(timeIntervalSince1970: requestDateMs / 1000)
    }
}

// MARK: - receipt mangement
class InAppReceipt {
    
    class func verifySubscription(
        type: SubscriptionType,
        productId: String,
        inReceipt receipt: ReceiptInfo,
        validUntil date: Date = Date()
        ) -> VerifySubscriptionResult {
        
        switch type {
            
            /**
             *  Verify the purchase of a Consumable or NonConsumable product in a receipt
             *  - Parameter productId: the product id of the purchase to verify
             *  - Parameter inReceipt: the receipt to use for looking up the purchase
             *  - return: either notPurchased or purchased
             */
        case .consumable,.nonConsumable:
            // Get receipts info for the product
            let receipts = getInAppReceipts(receipt: receipt)
            let filteredReceiptsInfo = filterReceiptsInfo(receipts: receipts, withProductId: productId)
            let nonCancelledReceiptsInfo = filteredReceiptsInfo.filter { receipt in receipt["cancellation_date"] == nil }
            
            let receiptItems = nonCancelledReceiptsInfo.flatMap { ReceiptItem(receiptInfo: $0) }
            // Verify that at least one receipt has the right product id
            if let firstItem = receiptItems.first {
                return .purchased(expiryDate: nil, items: [firstItem])
            }
            return .notPurchased
            
        default:
            
            /**
             *  Verify the purchase of a subscription (auto-renewable, free or non-renewing) in a receipt. This method extracts all transactions mathing the given productId and sorts them by date in descending order, then compares the first transaction expiry date against the validUntil value.
             *  - parameter type: .autoRenewable or .nonRenewing(duration)
             *  - Parameter productId: the product id of the purchase to verify
             *  - Parameter inReceipt: the receipt to use for looking up the subscription
             *  - Parameter validUntil: date to check against the expiry date of the subscription. If nil, no verification
             *  - Parameter validDuration: the duration of the subscription. Only required for non-renewable subscription.
             *  - return: either NotPurchased or Purchased / Expired with the expiry date found in the receipt
             */
            
            // The values of the latest_receipt and latest_receipt_info keys are useful when checking whether an auto-renewable subscription is currently active. By providing any transaction receipt for the subscription and checking these values, you can get information about the currently-active subscription period. If the receipt being validated is for the latest renewal, the value for latest_receipt is the same as receipt-data (in the request) and the value for latest_receipt_info is the same as receipt.
            
            let (receipts, duration) = getReceiptsAndDuration(for: type, inReceipt: receipt)
            let receiptsInfo = filterReceiptsInfo(receipts: receipts, withProductId: productId)
            let nonCancelledReceiptsInfo = receiptsInfo.filter { receipt in receipt["cancellation_date"] == nil }
            if nonCancelledReceiptsInfo.count == 0 {
                return .notPurchased
            }
            
            let receiptDate = getReceiptRequestDate(inReceipt: receipt) ?? date
            
            let receiptItems = nonCancelledReceiptsInfo.flatMap { ReceiptItem(receiptInfo: $0) }
            
            if nonCancelledReceiptsInfo.count > receiptItems.count {
                printDebug("receipt has \(nonCancelledReceiptsInfo.count) items, but only \(receiptItems.count) were parsed")
            }
            
            let sortedExpiryDatesAndItems = expiryDatesAndItems(receiptItems: receiptItems, duration: duration).sorted { a, b in
                return a.0 > b.0
            }
            
            guard let firstExpiryDateItemPair = sortedExpiryDatesAndItems.first else {
                return .notPurchased
            }
            
            let sortedReceiptItems = sortedExpiryDatesAndItems.map { $0.1 }
            if firstExpiryDateItemPair.0 > receiptDate {
                return .purchased(expiryDate: firstExpiryDateItemPair.0, items: sortedReceiptItems)
            } else {
                return .expired(expiryDate: firstExpiryDateItemPair.0, items: sortedReceiptItems)
            }
        }
    }
    
    private class func expiryDatesAndItems(receiptItems: [ReceiptItem], duration: TimeInterval?) -> [(Date, ReceiptItem)] {
        
        if let duration = duration {
            return receiptItems.map {
                let expirationDate = Date(timeIntervalSince1970: $0.originalPurchaseDate.timeIntervalSince1970 + duration)
                return (expirationDate, $0)
            }
        } else {
            return receiptItems.flatMap {
                if let expirationDate = $0.subscriptionExpirationDate {
                    return (expirationDate, $0)
                }
                return nil
            }
        }
    }
    
    private class func getReceiptsAndDuration(for subscriptionType: SubscriptionType, inReceipt receipt: ReceiptInfo) -> ([ReceiptInfo]?, TimeInterval?) {
        switch subscriptionType {
        case .autoRenewable:
            return (receipt["latest_receipt_info"] as? [ReceiptInfo], nil)
        case .nonRenewing(let duration):
            return (getInAppReceipts(receipt: receipt), duration)
        default:
            return (getInAppReceipts(receipt: receipt), nil)
        }
    }
    
    private class func getReceiptRequestDate(inReceipt receipt: ReceiptInfo) -> Date? {
        
        guard let receiptInfo = receipt["receipt"] as? ReceiptInfo,
            let requestDateString = receiptInfo["request_date_ms"] as? String else {
                return nil
        }
        return Date(millisecondsSince1970: requestDateString)
    }
    
    private class func getInAppReceipts(receipt: ReceiptInfo) -> [ReceiptInfo]? {
        
        let appReceipt = receipt["receipt"] as? ReceiptInfo
        return appReceipt?["in_app"] as? [ReceiptInfo]
    }
    
    /**
     *  Get all the receipts info for a specific product
     *  - Parameter receipts: the receipts array to grab info from
     *  - Parameter productId: the product id
     */
    private class func filterReceiptsInfo(receipts: [ReceiptInfo]?, withProductId productId: String) -> [ReceiptInfo] {
        
        guard let receipts = receipts else {
            return []
        }
        
        // Filter receipts with matching product id
        let receiptsMatchingProductId = receipts
            .filter { (receipt) -> Bool in
                let product_id = receipt["product_id"] as? String
                return product_id == productId
        }
        
        return receiptsMatchingProductId
    }
}
