//
//  BookmarksViewController.swift
//  KnowGo
//
//  Created by Varun Nath on 11/12/16.
//  Copyright © 2016 UnsureProgrammer. All rights reserved.
//

import UIKit
import SnapKit




class BaseViewController: UIViewController {
    
    var articleImage = UIImageView()
    var articleTextContainer = UIView()
    var articleTitle = UITextView()
    var articleText = UITextView()
    var article = [String:Any]()
    var titleViews = [UIView]()
    var articleChapter = UILabel()
    
    var titleImage = UIImageView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /** Add the imageview and article text container to the main view **/
        self.view.addSubview(self.articleImage)
        self.view.addSubview(self.articleTextContainer)
        self.view.addSubview(self.articleTitle)
        self.view.addSubview(self.articleChapter)
        

        
        /** Add Article Title and Article Text and the titleImage to the articleTextContainer**/
        self.articleTextContainer.addSubview(self.articleText)
        self.articleTextContainer.addSubview(self.articleTitle)
        self.articleTextContainer.addSubview(self.titleImage)
        
        self.articleTitle.isSelectable = false
        self.articleTitle.isEditable = false
        self.articleTitle.isScrollEnabled = false
        self.articleText.isEditable = false
        self.articleText.isSelectable = false

        
        /** Set the image of the article **/
        self.articleImage.image = UIImage(named: "logo")
        self.articleImage.contentMode = .scaleAspectFill
        self.articleImage.clipsToBounds = true
        self.articleTitle.font = UIFont(name: "HelveticaNeue-Bold",size:16)
        self.articleTitle.autoresizesSubviews = true
        self.articleChapter.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        

        /** title font size for different screen sizes **/
        let screenHeight = UIScreen.main.bounds.height
        switch screenHeight {
        case 480: // 3.5 inch
            self.articleTitle.font = UIFont(name: "HelveticaNeue-Bold",size:13)
        case 568: // 4 inch
            self.articleTitle.font = UIFont(name: "HelveticaNeue-Bold",size:14)
        default: // rest of screen sizes
            self.articleTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
            
        }
        
        
        /** Image Constraints **/
        self.articleImage.snp.makeConstraints { (articleImage) in
            
            articleImage.top.left.right.equalTo(self.view)
            articleImage.height.equalTo(self.view).multipliedBy(0.40)
        }
        
        /** textContainer Constraints
            - TextContainer contains the articleTitle and articleText
        **/
        self.articleTextContainer.snp.makeConstraints { (container) in
            
            self.view.backgroundColor = UIColor.white
            container.left.bottom.right.equalTo(self.view)
            container.height.equalTo(self.view).multipliedBy(0.60)
        }

        /** articleTitle Constraints **/
        self.articleTitle.snp.makeConstraints { (make) in
            
            make.right.equalTo(self.articleTextContainer)
            make.top.equalTo(self.articleTextContainer)
            make.left.equalTo(self.articleTextContainer).inset(10)
            make.height.greaterThanOrEqualTo(self.articleTextContainer).multipliedBy(0.06)
        }
        
        /** articleChapter Constraints **/
        self.articleChapter.snp.makeConstraints { (make) in
   
            make.left.equalTo(self.articleTitle.snp.left).inset(5)
            make.right.equalTo(self.articleTitle.snp.right)
            make.top.equalTo(self.articleTitle.snp.bottom)
            make.height.equalTo(self.articleTextContainer).multipliedBy(0.04)
        }
        
        /** articleText Constraints **/
        self.articleText.snp.makeConstraints { (articleText) in
            
            articleText.bottom.equalTo(self.articleTextContainer)
            articleText.left.equalTo(self.articleTextContainer).inset(10)
            articleText.right.equalTo(self.articleTextContainer).inset(10)
            articleText.height.equalTo(self.articleTextContainer).multipliedBy(0.88)
        }
    
        /** titleImage Contstraints **/
        self.titleImage.snp.makeConstraints { (titleImage) in
            
            titleImage.top.equalTo(self.articleTitle).inset(5)
            titleImage.width.equalTo(30)
            titleImage.height.equalTo(30)
            titleImage.left.equalTo(self.articleTextContainer).inset(5)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //called from the pageViewController when article doesn't have image
    func removeImage(){
        
        self.articleImage.snp.remakeConstraints { (articleImage) in
            
            articleImage.height.equalTo(self.view).multipliedBy(0)
        }
        
        self.articleTextContainer.snp.remakeConstraints { (container) in
            
            container.left.bottom.right.equalTo(self.view)
            self.view.backgroundColor = UIColor.white
            container.top.equalTo(self.view).inset(10)
            //            container.height.equalTo(self.view)
        }
    }
    
    func addImage()
    {
        
        self.articleImage.snp.makeConstraints { (articleImage) in
            
            articleImage.left.right.equalTo(self.view)
            //  articleImage.top.equalTo(self.view).offset(44)
            articleImage.height.equalTo(self.view).multipliedBy(0.40)
        }
        
        /** Article Text container takes up 60% of the height **/
        self.articleTextContainer.snp.makeConstraints { (container) in
            
            container.left.bottom.right.equalTo(self.view)
            container.height.equalTo(self.view).multipliedBy(0.60)
        }
        
    }
    

    
}



