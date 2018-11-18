//
//  SignUpVC.swift
//  AgriculturalApp
//
//  Created by carlos arellano on 11/15/18.
//  Copyright © 2018 nyu.edu. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var ReEnterPassword: UITextField!
    @IBOutlet weak var UserImage: UIImageView!
    var imageSelected = false
    var imagePicker: UIImagePickerController!
    
    var userUID: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func SelectImage(_ sender: Any){
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            UserImage.image = image
            imageSelected = true
        }
        else{
            print("image not selected")

        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    func CreateUser(imgURL: String!){
        let userID = KeychainWrapper.standard.string(forKey: "uid")
        let UserRef = Database.database().reference().child("users").child(userID!)
        let userData = ["username": username.text,
                        "firstName": FirstName.text,
                        "lastName":LastName.text,
                        "userImg": imgURL
                        ]
        
        
    }
    
    func uploadImage(){
        guard let img = self.UserImage.image, imageSelected == true else{
            print("image not selected")
            return
        }
        let data = img.jpegData(compressionQuality: 0.2)
        let imgUID = NSUUID().uuidString
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let storageRef = Storage.storage().reference()
        let storageItem = storageRef.child(imgUID)
        storageItem.putData(data!, metadata: metaData){
            (metaData, error) in
            if error != nil{
                print("error found!")
            }
            else{
                storageItem.downloadURL(completion: {(url, error) in
                    if error != nil{
                        print("error in download url!")
                    }
                    else if url != nil{
                        self.CreateUser(imgURL: url?.absoluteString)
                    }
                })
            }
        }
            
        
            
        
        
    }
    @IBAction func SignUp(_ sender: Any){
        
        
        if let email=Email.text, let password = Password.text{
            
            
            Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
                if error == nil{
                    if let user = user{
                        self.userUID = user.user.uid
                        KeychainWrapper.standard.set(self.userUID, forKey: "uid")
                        self.uploadImage()
                    self.performSegue(withIdentifier: "toFeed", sender: nil)
                    }
                }
                
            })
        
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
