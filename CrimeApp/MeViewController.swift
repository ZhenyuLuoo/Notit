//
//  MeViewController.swift
//  CrimeApp
//
//  Created by lucas on 2021/3/17.
//  Copyright © 2021 lucas. All rights reserved.
//

import UIKit

class MeViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imgAvatar: UIImageView!
    
    @IBOutlet weak var labNickname: UILabel!
    
    @IBOutlet weak var labUsername: UILabel!
    @IBOutlet weak var btnEditNickname: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.bounds.width / 2
        self.imgAvatar.layer.masksToBounds = true
        
        self.update(model: appMgr.currentUser)
    }
    
    
    func update(model: UserModel?) {
        let defaultImg = UIImage(named: "ic_user_avatar")
        
        guard let user = model else {
            self.labNickname.text = nil
            self.labUsername.text = nil
            self.imgAvatar.image = defaultImg
            return
        }
        
        self.labNickname.text = user.nickname
        self.labUsername.text = "ID: \(user.username)"
        
        if let imageName = user.avatar {
            let imgRef = appStorage.imageRef(imgName: imageName)
            self.imgAvatar.sd_setImage(with: imgRef, placeholderImage: defaultImg)
        }
        else {
            self.imgAvatar.image = defaultImg
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

    func editNickname(_ nickname: String)  {
        guard let userId = appMgr.currentUser?.uuid else { return }
        
        appDB.updateUser(userId, nickname: nickname) { (error) in
            if error == nil {
                appMgr.currentUser?.nickname = nickname
                self.update(model: appMgr.currentUser)
            }
        }
    }
    
    func editAvatar(_ capturedImage: UIImage) {
        guard let imgData = capturedImage.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        guard let me = appMgr.currentUser?.uuid else {
            return
        }
        
        self.imgAvatar.image = capturedImage
        let imageName = "user/\(UUID().uuidString).jpeg"
        
        appStorage.uploadImage(data: imgData, imgName: imageName) { (success, error) in
            // whatever succeed or not.
            appMgr.currentUser?.avatar = imageName
            appDB.updateUser(me, avatar: imageName) { (_) in
                
            }
        }
    }
    
    @IBAction func onBtnEditNicknameClicked(_ sender: Any) {
        
        guard let user = appMgr.currentUser else { return }
        
        self.showInputAlert(title: "Edit nickname", message: nil, inputPlaceholder: user.nickname) { btnIndex, inputText in
            if let nickname = inputText, !nickname.isWhitespace {
                self.editNickname(nickname)
            }
        }
    }
    
    @IBAction func onChangeAvatar(_ sender: Any) {
        
        self.showAlert(title: "",
                       message: "Update avatar from Photos?",
                       actionsText: ["Ok", "Cancel"], preferredStyle:.actionSheet) { index in
            
            if index == 0 {
                // Ok
                if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    self.showAlert(title: "No Photo Library available!", message: "Please make sure you can access Photo Library!")
                }
                else {
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    picker.sourceType = UIImagePickerController.SourceType.photoLibrary
                    picker.allowsEditing = true
                    self.present(picker, animated: true, completion: nil)
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let capturedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            picker.dismiss(animated: true, completion: nil)

            self.editAvatar(capturedImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onBtnLogoutClicked(_ sender: Any) {
        self.showAlert(title: "Logout",
                       message: "Are you sure to logout?",
                       actionsText: ["Ok", "Cancel"], preferredStyle: .actionSheet) { index in
            if index == 0 {
                // Ok
                appRouter.gotoLogin()
            }
        }
    }
    
    // Menus
    func showMenus() {
        
    }
}
