
import GoogleSignIn
import UIKit
import FirebaseCore
import FirebaseAuth

class GoogleLoginController : NSObject {
    
    // MARK: Variables and properties...
    static let shared = GoogleLoginController()
    fileprivate(set) var currentGoogleUser: AuthUser?
    fileprivate weak var contentViewController:UIViewController!
    fileprivate var hasAuthInKeychain: Bool {
        let hasAuth = GIDSignIn.sharedInstance.hasPreviousSignIn()
        return hasAuth
    }
    
    var success : ((_ googleUser : AuthUser) -> ())?
    var failure : ((_ error : Error) -> ())?
    
    private override init() {}

    func handleUrl(_ url: URL, options: [UIApplication.OpenURLOptionsKey : Any])->Bool{
        
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    // MARK: - Method for google login...
    // MARK: ============================
    
    func login(fromViewController viewController : UIViewController,
               success : @escaping(_ googleUser : AuthUser) -> (),
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
            GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { user, error in

              if let error = error {
                  
                // ...
                failure(error)
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
                        viewController.showTextInputPrompt(
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
                                  viewController.showTextInputPrompt(
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
                                          viewController.navigationController?.popViewController(animated: true)
                                        }
                                      }
                                    }
                                  )
                                }
                              }
                          }
                        )
                      } else {
                        viewController.showMessagePrompt(error.localizedDescription)
                        return
                      }
                      // ...
                      return
                    }
                    // User is signed in
                    // ...
                    
                    let googleUser = AuthUser(authResult?.user)
                    self.currentGoogleUser = googleUser
                    success(googleUser)
                }
              // ...
            }
        }
        contentViewController = viewController
        self.success = success
        self.failure = failure
        
    }
    
    func loginWithEmail(
        email: String,
        password: String,
        success : @escaping(_ user : FirebaseAuth.User) -> (),
        failure : @escaping(_ error : Error) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user else { failure(error!); return }
            let currentUser = AuthUser(authResult?.user)
            self.currentGoogleUser = currentUser
            success(user)
        }
    }
    
    func signUpWithEmail(
        email: String,
        password: String,
        name: String,
        success : @escaping(_ user : FirebaseAuth.User) -> (),
        failure : @escaping(_ error : Error) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) {authResult,error in
            guard let user = authResult?.user else { failure(error!); return }
            let changeRequest = user.createProfileChangeRequest();
            changeRequest.displayName = name
            changeRequest.photoURL = NSURL(string: "https://via.placeholder.com/150.png/26424C/FFFFFF?text=" + name.prefix(1)) as URL?
            changeRequest.commitChanges { error1 in
                if let error1 = error1 {
                    failure(error1);
                } else {
                    success(user)
                }
            }
            
        }
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
class AuthUser {
    
    let id: String?
    let name: String?
    let email: String?
    
    required init(_ googleUser: User?) {
        
        id = googleUser?.uid
        name = googleUser?.displayName
        email = googleUser?.email
    }
    
    var dictionaryObject: [String:Any] {
        var dictionary          = [String:Any]()
        dictionary["_id"]       = id
        dictionary["email"]     = email
        dictionary["name"]      = name
        return dictionary
    }
}

