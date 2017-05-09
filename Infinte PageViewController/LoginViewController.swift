//
//  LoginViewController.swift
//  Infinte PageViewController
//
//  Created by Varun Nath on 26/04/17.
//  Copyright © 2017 UnsureProgrammer. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController,FBSDKLoginButtonDelegate{

    
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    
    var rootRef:FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.rootRef = FIRDatabase.database().reference()
        
        //setup the permissions required from facebook
        self.fbLoginButton.readPermissions = ["public_profile","email","user_friends"]
        
        //set the delegate to self
        self.fbLoginButton.delegate = self

    }

    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        print("User logged into facebook")
        
        if(result.isCancelled)
        {
            //do nothing
            return
        }
        
        self.fbLoginButton.isHidden = true

        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            
            print("user signed in ")
            
            if(error != nil)
            {
                print("error")
            }
            
            self.rootRef.child("user_profiles").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                //create a variable to store the child updates
                var childUpdates = [String:Any]()
                
                
                if(!snapshot.exists())
                {
                    
                    //user has signed in for the first time
                    childUpdates["email"] = user?.email
                    childUpdates["name"] = user?.displayName
                    childUpdates["profile_pic"] = "\((user?.photoURL)!)"
                    childUpdates["age"] = ""
                    childUpdates["gender"] = ""
                    childUpdates["date_joined"] = Date().timeIntervalSince1970
                    childUpdates["last_login"] = Date().timeIntervalSince1970
                    self.rootRef.child("user_profiles").child(user!.uid).updateChildValues(childUpdates)
                    
                }
                else
                {
                    print("User already exists, just sign him in")
                    //update the last login row
                    childUpdates["last_login"] = Date().timeIntervalSince1970
                    self.rootRef.child("user_profiles").child(user!.uid).updateChildValues(childUpdates)
                }
                
                print("User Logged Into Firebase")
                
                
            }, withCancel: { (error) in
                print(error)
            })
            
            
            
            
        }

        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logged out")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        /* check if the user is logged in */
        if FIRAuth.auth()?.currentUser != nil {
            
            let loggedInUser = FIRAuth.auth()?.currentUser
            
            /** Store the user in a global variable **/
            globalLoggedInUser = loggedInUser
            
            /** Store the users details into a variable**/
            self.rootRef.child("user_profiles").child((globalLoggedInUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                let key = snapshot.key
                var snapshot = snapshot.value as! [String:Any]
                snapshot["uid"] = key
                globalLoggedInUserDetails = snapshot
                
                
            }, withCancel: { (error) in
                print(error.localizedDescription)
            })
            
            let subjectsRef = self.rootRef.child("user_subjects").child((globalLoggedInUser?.uid)!)
            subjectsRef.keepSynced(true)
            
            subjectsRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                /** iF the user has already selected subjects - take the user to the pageviewcontroller directly**/
                if(snapshot.exists())
                {
                    /** routes via the navigation controller, so show the navigation controller first **/
                    let pageViewNavigationController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewNavigationController") as! UINavigationController
                    
                    let pageViewController = pageViewNavigationController.topViewController as! PageViewController
                    self.present(pageViewNavigationController,animated:true,completion:nil)
                }
                    
                    /** else take the user to the subjects page and let him select subjects **/
                else
                {
                    
                    let subjectsViewController = self.storyboard?.instantiateViewController(withIdentifier: "SubjectsViewController") as! SubjectsViewController
                    
                    //pass the current user to the pageviewcontroller
                    self.present(subjectsViewController,animated:true,completion:nil)
                }
                
            }, withCancel: { (error) in
                print(error.localizedDescription)
            })
            
        }
    }
    
    
    

}

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

