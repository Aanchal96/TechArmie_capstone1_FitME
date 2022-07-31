//
//import Foundation
//import SwiftyJSON
//import Photos
//
//typealias JSONDictionary = [String : Any]
//typealias JSONDictionaryArray = [JSONDictionary]
//typealias SuccessResponse = (_ json : JSON) -> ()
//typealias FailureResponse = (NSError) -> (())
//typealias ResponseMessage = (_ message : String) -> ()
//typealias UserControllerSuccess = (_ user : AuthUser) -> ()
//typealias DownloadData = (_ data : Data) -> ()
//typealias UploadFileParameter = (fileName: String, key: String, data: Data, mimeType: String)
//
//extension Notification.Name {
//    static let NotConnectedToInternet = Notification.Name("NotConnectedToInternet")
//}
//
//enum AppNetworking {
//    
//    static let reachability = Alamofire.NetworkReachabilityManager.init()!
//    
//    static let username = "fitnessAppApi"
//    static let password = "1ca2556f34726eb0283ef1f48000bdef"
//    
//    @discardableResult
//    static func POST(endPoint : String,
//                     parameters : JSONDictionary = [:],
//                     headers : HTTPHeaders = [:],
//                     loader : Bool = false,isCached : Bool = false,
//                     success : @escaping (JSON) -> Void,
//                     failure : @escaping (NSError) -> Void)-> DataRequest? {
//        
//        
//        request(URLString: endPoint, httpMethod: .post, parameters: parameters, headers: headers, loader: loader,isCached: isCached, success: success, failure: failure)
//    }
//    
//    @discardableResult
//    static func GET(endPoint : String,
//                    parameters : JSONDictionary = [:],
//                    headers : HTTPHeaders = [:],
//                    loader : Bool = false,isCached : Bool = false,
//                    success : @escaping (JSON) -> Void,
//                    failure : @escaping (NSError) -> Void) -> DataRequest? {
//        
//       return request(URLString: endPoint, httpMethod: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers, loader: loader , isCached: isCached, success: success, failure: failure)
//    }
//    
//    @discardableResult
//    static func PUT(endPoint : String,
//                    parameters : JSONDictionary = [:],
//                    headers : HTTPHeaders = [:],
//                    loader : Bool = false,isCached : Bool = false,
//                    success : @escaping (JSON) -> Void,
//                    failure : @escaping (NSError) -> Void) -> DataRequest? {
//        
//       return request(URLString: endPoint, httpMethod: .put, parameters: parameters, headers: headers, loader: loader,isCached: isCached, success: success, failure: failure)
//    }
//    
//    @discardableResult
//    static func PATCH(endPoint : String,
//                      parameters : JSONDictionary = [:],
//                      encoding: URLEncoding = URLEncoding.httpBody,
//                      headers : HTTPHeaders = [:],
//                      loader : Bool = false,isCached : Bool = false,
//                      success : @escaping SuccessResponse,
//                      failure : @escaping FailureResponse) -> DataRequest? {
//        
//        request(URLString: endPoint, httpMethod: .patch, parameters: parameters, encoding: encoding, headers: headers, loader: loader,isCached: isCached, success: success, failure: failure)
//    }
//    
//    @discardableResult
//    static func DELETE(endPoint : String,
//                       parameters : JSONDictionary = [:],
//                       headers : HTTPHeaders = [:],
//                       loader : Bool = false,isCached : Bool = false,
//                       success : @escaping (JSON) -> Void,
//                       failure : @escaping (NSError) -> Void) -> DataRequest? {
//        
//        return request(URLString: endPoint, httpMethod: .delete, parameters: parameters, headers: headers, loader: loader,isCached: isCached, success: success, failure: failure)
//    }
//    
//    static func DOWNLOAD(endPoint : String,
//                         parameters : JSONDictionary = [:],
//                         headers : HTTPHeaders = [:],
//                         mediaType : String,
//                         loader : Bool = false,isCached : Bool = false,
//                         success : @escaping (Bool) -> Void,
//                         failure : @escaping (NSError) -> Void) {
//        
//        download(URLString: endPoint, httpMethod: .get, parameters: parameters, headers: headers, mediaType: mediaType, isCached: isCached, loader: loader, success: success, failure: failure)
//    }
//    
//    private static func download(URLString : String,
//                                 httpMethod : HTTPMethod,
//                                 parameters : JSONDictionary = [:],
//                                 encoding: URLEncoding = URLEncoding.default,
//                                 headers : HTTPHeaders = [:],
//                                 mediaType : String,isCached : Bool = false,
//                                 loader : Bool = false,
//                                 success : @escaping (Bool) -> Void,
//                                 failure : @escaping (NSError) -> Void) {
//        
//        
//        var fileURL = URL(string: "")
//        
//        let destination: DownloadRequest.DownloadFileDestination = { _, _  in
//            
//            let documentsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
//            
//            fileURL = documentsURL.appendingPathComponent(mediaType.replace(string: "/", withString: "."))
//            return (fileURL!, [.removePreviousFile, .createIntermediateDirectories])
//            
//        }
//        
//        if loader { CommonFunctions.showActivityLoader() }
//        
//        Alamofire.download(URLString, method: httpMethod, parameters: parameters, encoding: encoding, headers: headers, to: destination).response { (response) in
//            
//            if loader { CommonFunctions.hideActivityLoader() }
//            
//            if response.error != nil {
//                printDebug("===================== FAILURE =======================")
//                let e = response.error!
//                printDebug(e.localizedDescription)
//                
//                if (e as NSError).code == NSURLErrorNotConnectedToInternet {
//                    NotificationCenter.default.post(name: .NotConnectedToInternet, object: nil)
//                }
//                failure(e as NSError)
//                
//            } else {
//                printDebug("===================== RESPONSE =======================")
//                guard response.error == nil else { return }
//                
//                switch mediaType {
//                    
//                case "video/mp4":  CustomPhotoAlbum.shared.saveVideo(videoFileUrl: fileURL!)
//                    
//                case "application/pdf":
//                    break
//                    //insantiate webViewVC
//                    //webView.loadRequest(URLRequest(url: fileURL!))
//                    
//                default: CustomPhotoAlbum.shared.saveImage(imageFileUrl: fileURL!)
//                    
//                }
//                success(true)
//            }
//        }
//    }
//    
//    private static func request(URLString : String,
//                                httpMethod : HTTPMethod,
//                                parameters : JSONDictionary = [:],
//                                encoding: URLEncoding = URLEncoding.httpBody,
//                                headers : HTTPHeaders = [:],
//                                loader : Bool = false,isCached : Bool = false,
//                                success : @escaping (JSON) -> Void,
//                                failure : @escaping (NSError) -> Void)->DataRequest? {
//        
//        if loader { CommonFunctions.showActivityLoader() }
//       return makeRequest(URLString: URLString, httpMethod: httpMethod, parameters: parameters, encoding: encoding, headers: headers, loader: loader, isCached: isCached , success: { (json) in
//            CommonFunctions.hideActivityLoader()
//            let code = json[ApiKey.code].intValue
//            
//            switch code {
//            case ApiCode.tokenExpired:
//                ez.topMostVC?.view.isUserInteractionEnabled = true
//                AlertsClass.shared.showAlertController(withTitle: "", message: LocalizedString.sessionExpire.localized, buttonTitles: [LocalizedString.login.localized], responseBlock: { (tag) in
//                    switch tag{
//                    case .yes:
//                        AppRouter.goToLogin()
//                    default:
//                        return
//                    }
//                })
//            case ApiCode.userBlocked:
//                AlertsClass.shared.showAlertController(withTitle: "", message: LocalizedString.accountBlocked.localized, buttonTitles: [LocalizedString.ok.localized], responseBlock: { (tag) in
//                    switch tag{
//                    case .yes:
//                        AppRouter.goToLogin()
//                    default:
//                        return
//                    }
//                })
//            case ApiCode.userDeleted:
//                AlertsClass.shared.showAlertController(withTitle: "", message: LocalizedString.accountDeleted.localized, buttonTitles: [LocalizedString.ok.localized], responseBlock: { (tag) in
//                    switch tag{
//                    case .yes:
//                        AppRouter.goToLogin()
//                    default:
//                        return
//                    }
//                })
//                
//            case ApiCode.subscriptionExpired:
//                var model = UserModel.main
//                model.subscription.subscriptionStatus = 0
//                UserModel.main = model
//                AppRouter.goToSubscription()
//           
//                
//            default: success(json)
//            }
//        }, failure: failure)
//    }
//    
//    private static func makeRequest(URLString : String,
//                                    httpMethod : HTTPMethod,
//                                    parameters : JSONDictionary = [:],
//                                    encoding: URLEncoding = URLEncoding.httpBody,
//                                    headers : HTTPHeaders = [:],
//                                    loader : Bool = false,isCached : Bool = false,
//                                    success : @escaping (JSON) -> Void,
//                                    failure : @escaping (NSError) -> Void) -> DataRequest? {
//        var updatedHeaders : HTTPHeaders = headers
//        guard let data = "\(username):\(password)".data(using: String.Encoding.utf8) else { return nil }
//        
//        var selectedLang = ""
//        if AppUserDefaults.value(forKey: .selectedLang).stringValue == AppLanguage.en || AppUserDefaults.value(forKey: .selectedLang).stringValue.isEmpty {
//            selectedLang = "1"
//        } else {
//            selectedLang = "2"
//        }
//        
//        let base64 = data.base64EncodedString()
//        updatedHeaders = ["Authorization" : "Basic \(base64)",
//            "content-type": "application/x-www-form-urlencoded", "lang": selectedLang , "timezone" : TimeZone.current.identifier]
//        if !UserModel.main.authToken.isEmpty {
//            updatedHeaders[ApiKey.authToken] =  "\(UserModel.main.authToken)"
//        }
//        if let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString"){
//            updatedHeaders["apiversion"] = "v\(currentVersion)"
//        }
//        
//        var key = parameters.description + CommonFunctions.getLang()
//        switch URLString{
//        case   WebServices.EndPoint.allChallenges.path , WebServices.EndPoint.getStepGoals.path:
//            key =  CommonFunctions.getLang()
//        case WebServices.EndPoint.recipeLibraryMealList.path:
//            key =  CommonFunctions.getLang()
//        case WebServices.EndPoint.mealList.path:
//            break
//        case WebServices.EndPoint.exerciseList.path  :
//            key = (parameters[ApiKey.idToSend] as? String ?? "") + CommonFunctions.getLang()
//            break
//        case  WebServices.EndPoint.workoutExerciseList.path :
//            key =  (parameters[ApiKey.idToSend] as? String ?? "") + CommonFunctions.getLang()
//            break
//        case WebServices.EndPoint.allPrograms.path:
//            key = "" + CommonFunctions.getLang()
//            break
//        case WebServices.EndPoint.mealDetail.path:
//            key =  (parameters[ParamsKeys.id.rawValue] as? String ?? "") + CommonFunctions.getLang()
//            break
//        case WebServices.EndPoint.shoppingList.path:
//            key =  (parameters[ApiKey.startDate] as? String ?? "") +  (parameters[ApiKey.endDate] as? String ?? "") + CommonFunctions.getLang()
//        case WebServices.EndPoint.mealPlans.path:
//            key = "" + CommonFunctions.getLang()
//        case WebServices.EndPoint.getDairyData.path:
//            key =  "" + CommonFunctions.getLang() + (parameters[ApiKey.queryDate] as? String ?? "")
//        case WebServices.EndPoint.recentlyLoggedMeals.path:
//            key =  (parameters[ApiKey.categoryNo] as? String ?? "")  + (parameters[ApiKey.search] as? String ?? "") + CommonFunctions.getLang()
//        case WebServices.EndPoint.allChallenges.path:
//            key = "" + CommonFunctions.getLang()
//        case WebServices.EndPoint.weightProgress.path:
//            key = CommonFunctions.getLang() + (parameters[ApiKey.filterType] as? String ?? "")
//        case WebServices.EndPoint.getBurnedCalories.path:
//            key = CommonFunctions.getLang() + (parameters[ApiKey.type] as? String ?? "")
//            key = key + (parameters[ApiKey.idToSend] as? String ?? "")
//        case WebServices.EndPoint.mealplanDetail.path:
//            key = CommonFunctions.getLang() + (parameters[ApiKey.idToSend] as? String ?? "") + (parameters[ApiKey.noOfPerDayMeals] as? String ?? "")
//        case WebServices.EndPoint.todaysMeal.path:
//            key = CommonFunctions.getLang() + (parameters[ApiKey.queryDate] as? String ?? "") + (parameters[ApiKey.noOfPerDayMeals] as? String ?? "")
//        case WebServices.EndPoint.mealPlannerList.path:
//            key = CommonFunctions.getLang() + (parameters[ApiKey.queryDate] as? String ?? "") + (parameters[ApiKey.noOfPerDayMeals] as? String ?? "")
//        case WebServices.EndPoint.recipeAndSwapMeals.path:
//            key = CommonFunctions.getLang() + (parameters[ApiKey.idToSend] as? String ?? "") + (parameters[ApiKey.categoryNo] as? String ?? "")
//
//
//        default:
//            break
//        }
//        
//        let param = parameters
//        // ez.topMostVC?.view?.isUserInteractionEnabled = false
//        if !(NetworkReachabilityManager()?.isReachable ?? false){
//            ez.topMostVC?.view?.isUserInteractionEnabled = true
//            if isCached{
//                DataCache.instance.readArray(forKey: URLString+key) {  (arr) in
//                    if arr.isEmpty{
//                        if loader { CommonFunctions.hideActivityLoader() }
//                        failure(NSError.init(localizedDescription: LocalizedString.pleaseCheckInternetConnection.localized))
//                    }else{
//                        if let val = arr.first{
//                            let json = JSON(val)
//                           // ez.runThisAfterDelay(seconds: 0.2, after: {
//                                if loader { CommonFunctions.hideActivityLoader() }
//                                success(json)
//                           // })
//                            return
//                        } else{
//                            if loader { CommonFunctions.hideActivityLoader() }
//                            failure(NSError.init(localizedDescription: LocalizedString.pleaseCheckInternetConnection.localized))
//                        }
//                    }
//                }
//                return nil
//            }else{
//                if loader { CommonFunctions.hideActivityLoader() }
//                failure(NSError.init(localizedDescription: LocalizedString.pleaseCheckInternetConnection.localized))
//            }
//            return nil
//        } else if URLString != WebServices.EndPoint.allChallenges.path && URLString != WebServices.EndPoint.currentProgram.path && URLString != WebServices.EndPoint.exerciseLibrary.path  && URLString != WebServices.EndPoint.workoutExerciseList.path && URLString != WebServices.EndPoint.challengeWorkoutDetailWarmup.path && URLString != WebServices.EndPoint.recipeLib.path && URLString != WebServices.EndPoint.recipeLibraryMealList.path     && WebServices.EndPoint.todaysMeal.path != URLString && WebServices.EndPoint.mealPlannerList.path != URLString  && WebServices.EndPoint.getDairyData.path != URLString{
//            ez.topMostVC?.view?.isUserInteractionEnabled = true
//            if isCached{
//                DataCache.instance.readArray(forKey: URLString+key) {  (arr) in
//                    if arr.isEmpty{
//                        //if loader { CommonFunctions.hideActivityLoader() }workoutExerciseList challengeWorkoutDetailWarmup
//                        //failure(NSError.init(localizedDescription: LocalizedString.pleaseCheckInternetConnection.localized))
//                    }else{
//                        if let val = arr.first{
//                            let json = JSON(val)
//                           // ez.runThisAfterDelay(seconds: 0.2, after: {
//                                if loader { CommonFunctions.hideActivityLoader() }
//                                success(json)
//                           // })
//                            return
//                        }else{
//                           // if loader { CommonFunctions.hideActivityLoader() }
//                            //failure(NSError.init(localizedDescription: LocalizedString.pleaseCheckInternetConnection.localized))
//                        }
//                    }
//                }
//            }else{
////                if loader { CommonFunctions.hideActivityLoader() }
////                failure(NSError.init(localizedDescription: LocalizedString.pleaseCheckInternetConnection.localized))
//            }
//        }
//        printDebug("===================== METHOD =========================")
//        printDebug(httpMethod)
//        printDebug("===================== ENCODING =======================")
//        printDebug(encoding)
//        printDebug("===================== URL STRING =====================")
//        printDebug(URLString)
//        printDebug("===================== HEADERS ========================")
//        printDebug(updatedHeaders)
//        printDebug("===================== PARAMETERS =====================")
//        printDebug(param.description)
//        return Alamofire.request(URLString, method: httpMethod, parameters: param, encoding: encoding, headers: updatedHeaders).responseJSON { (response:DataResponse<Any>) in
//            ez.topMostVC?.view?.isUserInteractionEnabled = true
//            if loader { CommonFunctions.hideActivityLoader() }
//            switch(response.result) {
//            case .success(let value):
//                printDebug("===================== RESPONSE =======================")
//                printDebug(JSON(value))
//                let json = JSON(value)
//                if isCached  && ((json[ApiKey.code].intValue == ApiCode.success) || (json[ApiKey.code].intValue == ApiCode.successButNotVerified)){
//                    DataCache.instance.write(array: [value], forKey: URLString+key)
//                }
//                success(json)
//            case .failure(let e):
//                printDebug("===================== FAILURE =======================")
//                printDebug(e.localizedDescription)
//                if loader { CommonFunctions.hideActivityLoader() }
//                if (e as NSError).code == NSURLErrorNotConnectedToInternet {
//                    NotificationCenter.default.post(name: .NotConnectedToInternet, object: nil)
//                    failure(NSError.init(localizedDescription: LocalizedString.pleaseCheckInternetConnection.localized))
//                } else {
//                    failure(e as NSError)
//                }
//            }
//        }
//    }
//}
