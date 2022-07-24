
import GoogleSignIn
import UIKit
import FirebaseCore
import FirebaseAuth

class GoogleLoginController : NSObject {
    
    // MARK: Variables and properties...
    static let shared = GoogleLoginController()
    fileprivate(set) var currentGoogleUser: GoogleUser?
    fileprivate weak var contentViewController:UIViewController!
    fileprivate var hasAuthInKeychain: Bool {
        let hasAuth = GIDSignIn.sharedInstance.hasPreviousSignIn()
        return hasAuth
    }
    
    var success : ((_ googleUser : GoogleUser) -> ())?
    var failure : ((_ error : Error) -> ())?
    
    private override init() {}

    func handleUrl(_ url: URL, options: [UIApplication.OpenURLOptionsKey : Any])->Bool{
        
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    // MARK: - Method for google login...
    // MARK: ============================
    
    func login(fromViewController viewController : UIViewController,
               success : @escaping(_ googleUser : GoogleUser) -> (),
               failure : @escaping(_ error : Error) -> ()) {
        
        GIDSignIn.sharedInstance.signOut()
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        if hasAuthInKeychain {
            GIDSignIn.sharedInstance.restorePreviousSignIn()
        } else {
            GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController)
            
            // Start the sign in flow!
            GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { [unowned self] user, error in

              if let error = error {
                  
                // ...
                  
                return
              }

              guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
              else {
                return
              }

              let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                             accessToken: authentication.accessToken)

                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                      let authError = error as NSError
                      if authError.code == AuthErrorCode.secondFactorRequired.rawValue {
                        // The user is a multi-factor user. Second factor challenge is required.
                        let resolver = authError
                          .userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
                        var displayNameString = ""
                        for tmpFactorInfo in resolver.hints {
                          displayNameString += tmpFactorInfo.displayName ?? ""
                          displayNameString += " "
                        }
                        self.showTextInputPrompt(
                          withMessage: "Select factor to sign in\n\(displayNameString)",
                          completionBlock: { userPressedOK, displayName in
                            var selectedHint: PhoneMultiFactorInfo?
                            for tmpFactorInfo in resolver.hints {
                              if displayName == tmpFactorInfo.displayName {
                                selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
                              }
                            }
                            PhoneAuthProvider.provider()
                              .verifyPhoneNumber(with: selectedHint!, uiDelegate: nil,
                                                 multiFactorSession: resolver
                                                   .session) { verificationID, error in
                                if error != nil {
                                  print(
                                    "Multi factor start sign in failed. Error: \(error.debugDescription)"
                                  )
                                } else {
                                  self.showTextInputPrompt(
                                    withMessage: "Verification code for \(selectedHint?.displayName ?? "")",
                                    completionBlock: { userPressedOK, verificationCode in
                                      let credential: PhoneAuthCredential? = PhoneAuthProvider.provider()
                                        .credential(withVerificationID: verificationID!,
                                                    verificationCode: verificationCode!)
                                      let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator
                                        .assertion(with: credential!)
                                      resolver.resolveSignIn(with: assertion!) { authResult, error in
                                        if error != nil {
                                          print(
                                            "Multi factor finanlize sign in failed. Error: \(error.debugDescription)"
                                          )
                                        } else {
                                          self.navigationController?.popViewController(animated: true)
                                        }
                                      }
                                    }
                                  )
                                }
                              }
                          }
                        )
                      } else {
                        self.showMessagePrompt(error.localizedDescription)
                        return
                      }
                      // ...
                      return
                    }
                    // User is signed in
                    // ...
                }
              // ...
            }
        }
        contentViewController = viewController
        self.success = success
        self.failure = failure
        
    }
    
    func logout(){
        
        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
        
    GIDSignIn.sharedInstance.signOut()
        
    }
}

// MARK: - Model class to store the user information...
// MARK: ==============================================
class GoogleUser {
    
    let id: String?
    let name: String?
    let email: String?
    let image: URL?
    
    required init(_ googleUser: GIDGoogleUser) {
        
        id = googleUser.userID
        name = googleUser.profile?.name
        email = googleUser.profile?.email
        image = googleUser.profile?.imageURL(withDimension: 200)
    }
    
    var dictionaryObject: [String:Any] {
        var dictionary          = [String:Any]()
        dictionary["_id"]       = id
        dictionary["email"]     = email
        dictionary["image"]     = image?.absoluteString ?? ""
        dictionary["name"]      = name
        return dictionary
    }
}

