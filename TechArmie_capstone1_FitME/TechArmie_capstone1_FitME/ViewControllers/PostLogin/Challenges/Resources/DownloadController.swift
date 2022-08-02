

import Foundation
import Alamofire
import AVFoundation

extension Array {
    public func forEachEnumerated(_ body: @escaping (_ offset: Int, _ element: Element) -> Void) {
        enumerated().forEach(body)
    }
}


class BackendAPIManager: NSObject {
    
    static let sharedInstance = BackendAPIManager()
    
    var alamoFireManager : Alamofire.Session!

    
    fileprivate override init()
    {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 200 // seconds
        configuration.timeoutIntervalForResource = 200
        configuration.sessionSendsLaunchEvents = true
        self.alamoFireManager = Alamofire.Session.init(configuration: configuration, delegate: SessionDelegate(), rootQueue: DispatchQueue(label: "org.alamofire.session.rootQueue"), startRequestsImmediately: true, requestQueue: nil, serializationQueue: nil, interceptor: nil, serverTrustManager: nil, redirectHandler: nil, cachedResponseHandler: nil, eventMonitors: [])
    }
}

class DownloadController {
    
    static let shared = DownloadController()
    
    func saveVideo(urls: [String], ids: [String], completed : @escaping ([URL]) -> Void, progress: @escaping (Int) -> Void , failure : @escaping (Error) -> Void) {
        
        let dispatch = DispatchGroup()
        var localUrls = [URL]()
        var isFailed = false
        var progressCount = 0 {
            didSet {
                progress(progressCount)
            }
        }
        var arrIds : [String] = []
        
        
        
        urls.forEachEnumerated({[weak self] (offset, element) in
            
            guard let strongSelf = self else {
                return
            }
            
            
            dispatch.enter()
            if arrIds.contains(ids[offset]){
                dispatch.leave()
                progressCount += 1
                return
            }
            arrIds.append(ids[offset])
            if isFailed{
                dispatch.leave()
                return
            }
            guard let videoUrl = URL(string : element) else{
                dispatch.leave()
                isFailed = true
                failure((NSError.init(localizedDescription: "invalid error") as Error))
                return
            }
            if !videoUrl.description.lowercased().contains(".mp4"){
                dispatch.leave()
                isFailed = true
                failure((NSError.init(localizedDescription: "invalid error") as Error))
                return
            }
            
            let fileProp : (Bool,URL?) = strongSelf.checkIfFileExists(ids[offset])
            if fileProp.0 {
                if let url = fileProp.1 {
                    localUrls.append(url)
                    progressCount += 1
                    // Last element
                    if offset == urls.count - 1 && progressCount == urls.count {
                        completed(localUrls)
                    }
                }
                dispatch.leave()
                return
            }
            
            strongSelf.downloadVideo(URLString: element, id: ids[offset], success: { (url) in
                if isFailed{
                    dispatch.leave()
                    return
                }
                localUrls.append(url)
                progressCount += 1
                // Last element
                if offset == urls.count - 1 && progressCount == urls.count {
                    completed(localUrls)
                    dispatch.leave()
                } else {
                    dispatch.leave()
                }
                
            }) { (error) in
                if !isFailed{
                    isFailed = true
                    failure(error)
                }
                failure(error)

                dispatch.leave()
            }
        })
        
        //TODO:- dispatch cancel
        //        dispatch.notify(queue: DispatchQueue.main) {
        //            dispatch.leave()
        //        }
        
    }
    
    func saveImage(urls: [String], ids: [String], completed : @escaping ([UIImage]) -> Void, failure : @escaping (Error) -> Void) {
        
        let dispatch = DispatchGroup()
        var localUrls = [UIImage]()
        var arrIds : [String] = []
        
        urls.forEachEnumerated({[weak self] (offset, element) in
            
            guard let strongSelf = self else {
                return
            }
            
            dispatch.enter()
            guard let _ = URL(string : element) else{
                dispatch.leave()
                //isFailed = true
                failure((NSError.init(localizedDescription: "invalid error") as Error))
                return
            }
            if arrIds.contains(ids[offset]){
                dispatch.leave()
                return
            }
            arrIds.append(ids[offset])
            let fileProp : (Bool,URL?) = strongSelf.checkIfFileExists(ids[offset] , isVideo: false)
            if fileProp.0 {
                if let path = fileProp.1 {
                    if let img = UIImage(contentsOfFile: path.absoluteString) {
                        localUrls.append(img)
                    }
                    // Last element
                    if offset == urls.count - 1  {
                        completed(localUrls)
                    }
                }
                dispatch.leave()
                return
            }
            
            strongSelf.downloadImage(URLString: element, id: ids[offset], success: { (img) in
                localUrls.append(img)
                // Last element
                if offset == urls.count - 1 {
                    completed(localUrls)
                    dispatch.leave()
                } else {
                    dispatch.leave()
                }
                
            }) { (error) in
                failure(error)
                dispatch.leave()
            }
        })
    }
    
    
    
    private func downloadImage(URLString : String,
                               id : String,
                               success : @escaping (UIImage) -> Void,
                               mediaType : String = "img/png",
                               loader : Bool = false,
                               failure : @escaping (Error) -> Void) {
        
        if loader { CommonFunctions.showActivityLoader()}
        
        let destination: DownloadRequest.Destination = { _, _  in
            
            let documentsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(id + "_" + mediaType.replacingOccurrences(of: "/", with: "."))

            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        BackendAPIManager.sharedInstance.alamoFireManager.download(URLString, to: destination).response { response in
            switch response.result {
            case .success(let url):
                if let ur = url?.path {
                    if let image = UIImage(contentsOfFile: ur) {
                        success(image)
                    }
                }
            case.failure(let err):
                failure(err)
            }
        }
    }
    
    private func downloadVideo(isAudio : Bool = false ,URLString : String,
                               id : String,
                               httpMethod : HTTPMethod = .get,
                               parameters : JSONDictionary = [:],
                               encoding: ParameterEncoding = JSONEncoding.default,
                               headers : HTTPHeaders = [:],
                               mediaType : String = "video/mp4",
                               loader : Bool = false,
                               success : @escaping (URL) -> Void,
                               failure : @escaping (Error) -> Void) {
        
        if loader { CommonFunctions.showActivityLoader()}
        
        let destination: DownloadRequest.Destination = { _, _  in
            
            let documentsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(id + (isAudio ? "en" : "") +  "_" + mediaType.replacingOccurrences(of: "/", with: "."))
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        BackendAPIManager.sharedInstance.alamoFireManager.download(URLString, to: destination).response { response in
    
            switch response.result {
            case .success(let url):
                if let ur = url {
                    success(ur)
                }
            case.failure(let err):
                failure(err)
            }
        }


    }
    
    /// Retruns (true, URL?) tuple  if file with provided name exists otherwise (false, nil)
    func checkIfFileExists(_ nameOfFile: String, isVideo : Bool = true ,isAudio : Bool = false) -> (Bool,URL?) {
        var fileName = nameOfFile + "_" + "video/mp4".replacingOccurrences(of: "/", with: ".")
        if !isVideo{
            fileName = nameOfFile + "_" + "img/png".replacingOccurrences(of: "/", with: ".")
        }
        if isAudio {
            fileName = nameOfFile + "en" + "_" + "audio/mp3".replacingOccurrences(of: "/", with: ".")
        }
        guard let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first else {
            printDebug("CANNOT FETCH DIRECTORIES")
            return (false,nil)
        }
        
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(fileName) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                printDebug("FILE AVAILABLE")
                if let fileStr = URL(string: filePath) {
                    return (true,pathComponent)
                } else {
                    printDebug("FILE NOT CONVERTIBLE TO URL")
                    return (false,nil)
                }
            } else {
                printDebug("FILE NOT AVAILABLE")
                return (false,nil)
            }
        } else {
            printDebug("FILE PATH NOT AVAILABLE")
            return (false,nil)
        }
    }
}
