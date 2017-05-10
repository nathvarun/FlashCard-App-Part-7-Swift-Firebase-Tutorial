//
//  SubjectsViewController.swift
//  Infinte PageViewController
//
//  Created by Varun Nath on 01/05/17.
//  Copyright © 2017 UnsureProgrammer. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class SubjectsViewController: UIViewController {

    
    var rootRef = FIRDatabase.database().reference()
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var subjectsCollectionView: UICollectionView!
    
    var subjects = [NSDictionary?]()
    var mySubjectCategories = [[String:[String:[[String:String]]]]]()

    /** Use this array to check if a subject is selected, also to show or not to show the doneButton **/
   
    var userSubjectIds:[String] = []{
        
        didSet{
            if(userSubjectIds.count>0)
            {
                print("somesubjects are selected")
                self.doneButton.isEnabled = true
            }
            else
            {
                print("no subject selected ")
                self.doneButton.isEnabled = false
            }
        }
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.subjectsCollectionView.dataSource = self
        self.subjectsCollectionView.delegate = self
        
        //Stores the mainCategory Eg. Aviation
        var mainCategoryKey:String?
        
        /** get all the subjects **/
        self.rootRef.child("subjects").observeSingleEvent(of: .value, with: { (snapshot) in
            
            /** get the USERS Selected subjects **/
            self.rootRef.child("user_subjects").child(globalLoggedInUser!.uid).observeSingleEvent(of: .value, with: { (userSubjectsSnapshot) in
                
                
                for userSubject in userSubjectsSnapshot.children.allObjects as! [FIRDataSnapshot]{
                    
                    self.userSubjectIds.append(userSubject.key)
                    
                }
                
                //multiple loops to dig deep into the data
                for category in snapshot.children.allObjects as! [FIRDataSnapshot]{
                    
                    mainCategoryKey = category.key
                    
                    for subCategory in category.children.allObjects as! [FIRDataSnapshot]{
                        
                        var subjects = [[String:String]]()
                        
                        for subject in subCategory.children.allObjects as! [FIRDataSnapshot]{
                            
                            //get the subject name
                            let key = subject.key
                            var subject = subject.value as? [String:String]
                            subject!["key"] = key
                            subjects.append(subject!)
                            
                        }
                        
                        /** We need to setup the multidimensional array for the collectionview **/
                        var mainCategorySubCategoryWithSubjects = [String:[String:[[String:String]]]]()
                        
                        //inside main category we need a variable that matches the sub category with subject
                        //eg. [dgca:[met,nav]]
                        var subCategoryWithSubjects = [String:[[String:String]]]()
                        
                        //add the subject inside the subcategory
                        //subCategory.key is dgca
                        //subjects is [met,nav,regs]
                        subCategoryWithSubjects[subCategory.key] = subjects
                        
                        //add the subcategory with subjects inside the main category
                        mainCategorySubCategoryWithSubjects[mainCategoryKey!] = subCategoryWithSubjects
                        
                        //now add the subject set to the categories array
                        self.mySubjectCategories.append(mainCategorySubCategoryWithSubjects)
                        
                        //reload the collectionView
                        self.subjectsCollectionView.reloadData()
                    }
                    
                }
                
                
            })//end get user subjects
            
        }) { (error) in
            print(error.localizedDescription)
        }

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapDone(_ sender: Any) {
        
        let pageViewNavigationController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewNavigationController") as! UINavigationController
        
        let pageViewController = pageViewNavigationController.topViewController as! PageViewController
        
        self.present(pageViewNavigationController,animated:true,completion:nil)

    }

}


extension SubjectsViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    //reuse identifier for the collectionview
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //        return detailedSubjects.count
        return self.mySubjectCategories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        var count:Int = 0
        
        for(_,value) in self.mySubjectCategories[section]{
            for(_,value) in value{
                
                count = value.count
            }
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        let cell:SubjectsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectsCollectionViewCell", for: indexPath) as! SubjectsCollectionViewCell
        
        
        //to store each subject
        var subject = [String:String]()
        
        
        //Get the section
        let mySubjectCategory = self.mySubjectCategories[indexPath.section]
        
        for(_,value) in mySubjectCategory{
            
            for(_,value) in value{
                
                subject = value[indexPath.row]
            }
        }
        
        print(subject)
        
        cell.subjectName.text = subject["name"]!.capitalized
        cell.subjectImage.image = UIImage(named: subject["name"]!.capitalized)
        
        /** Display a green circle around subjects that are selected by the user**/
        if(self.userSubjectIds.contains(subject["key"]!))
        {
            
            self.doneButton.isEnabled = true
           
            let color = CABasicAnimation(keyPath: "borderColor")
            color.fromValue = UIColor.clear.cgColor
            color.toValue = globalAppGreen
            color.duration = 0.25
            color.repeatCount = 1
            cell.subjectImage.layer.borderWidth = 1.0
            cell.subjectImage.layer.borderColor = globalAppGreen
            
            
        }
   
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let cell = collectionView.cellForItem(at: indexPath)! as! SubjectsCollectionViewCell
        
        
        var mainCategory:String?
        var subCategory:String?
        var subjectId:String?
        //        var subject = [String:[String:[String]]]()
        
        let mySubjectDetails = self.mySubjectCategories[indexPath.section]
        //eg key = aviation
        for(key,value) in mySubjectDetails{
            
            mainCategory = key
            
            //eg key = dgca
            for(key,value) in  value{
                
                subCategory = key
                subjectId = value[indexPath.row]["key"]
                
            }
        }
        
        
        let userSubjectsRef = self.rootRef.child("user_subjects").child(globalLoggedInUser!.uid).child(subjectId!)
        

            
            if(cell.subjectImage.layer.borderColor == globalAppGreen)
            {
                cell.subjectImage.layer.borderColor = UIColor.black.cgColor
                cell.subjectImage.layer.borderWidth = 0
                
                //            self.selectedSubjects = self.selectedSubjects.filter() {$0 != cell.subjectLabel.text!}
                userSubjectsRef.setValue(NSNull())
                
                self.userSubjectIds = self.userSubjectIds.filter(){$0 != subjectId!}
                //remove the subject id from the selected subjects
                //            self.userSubjectsArray = self.selectedSubjectIds.filter(){$0 != subjectId!}
                
            }
            else
            {
                let color = CABasicAnimation(keyPath: "borderColor")
                
                color.fromValue = UIColor.clear.cgColor
                color.toValue = globalAppGreen
                color.duration = 0.25
                color.repeatCount = 1
                cell.subjectImage.layer.borderWidth = 3.0
                cell.subjectImage.layer.borderColor = globalAppGreen
                cell.subjectImage.layer.add(color, forKey: "borderColor")
                
                //add the subjectId to the userSubjectIds array
                self.userSubjectIds.append(subjectId!)
                
                //get the key
                //let key = self.rootRef.child("subjects").child(globalLoggedInUser!.uid).key
                
                
                
                let childValues = ["name":cell.subjectName.text!.lowercased(),
                                   "subCategory":subCategory!.lowercased(),
                                   "mainCategory":mainCategory!.lowercased()]
                
                userSubjectsRef.updateChildValues(childValues)
                
                //            self.rootRef.child("user_subjects").child(user.uid!).child(mainCategory!.lowercased()).child(subCategory!.lowercased()).child(key).setValue(cell.subjectLabel.text!.lowercased()
            }
        
    }

    
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        //1
        switch kind {
        //2
        case UICollectionElementKindSectionHeader:
            //3
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: "SubjectsHeaderCollectionReusableView",for: indexPath) as! SubjectsHeaderCollectionReusableView
            
            
            for(_,value) in self.mySubjectCategories[indexPath.section]
            {
                for(key,_) in value
                {
                    headerView.label.text = key.capitalized
                    headerView.label.sizeToFit()
                    headerView.headerImage.image = UIImage(named: key.capitalized)
                }
            }
            
            return headerView
            
        default:
            //4
            /** assert only works in debug configuration **/
            assert(false, "Unexpected element kind")
            
            /** fatal error is needed when the app is live **/
            fatalError("Unexpected element kind")
            
        }
    }

    
    
}




