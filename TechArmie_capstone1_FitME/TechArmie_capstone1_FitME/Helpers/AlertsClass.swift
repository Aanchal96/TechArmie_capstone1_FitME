
import UIKit

typealias AlertBlock = (_ success: AlertTag) -> ()

enum AlertTag {
    case done
    case yes
    case noo
}

class AlertsClass: NSObject{
    
    static let shared = AlertsClass()
    var responseBack : AlertBlock?
    
    override init() {
        super.init()
    }
    
    //MARK: Alert Controller
    func showAlertController(withTitle title : String?, message : String, buttonTitles : [String], responseBlock : @escaping AlertBlock){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitles.count > 0 ? buttonTitles.first : nil, style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
            self.responseBack?(.yes)
        }))
        if buttonTitles.count > 1{
        alert.addAction(UIAlertAction(title: buttonTitles.count > 1 ? buttonTitles.last : nil, style: .destructive, handler: { action in
            alert.dismissVC(completion: nil)
            self.responseBack?(.noo)
        }))
        }
        responseBack = responseBlock
        ez.topMostVC?.presentVC(alert)
    }
}

