//
//  LoginController.swift
//  novelty
//
//  Created by 酒井文也 on 2015/07/21.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class LoginController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    var novelData: AnyObject!
    
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet var loginBtn: UIButton!
    
    @IBOutlet var readSynopsisBtn: UIButton!
    
    //あらすじを読むページへ遷移
    @IBAction func goSynopsis(sender: AnyObject) {
        
        //セグエの実行時に値を渡す
        let novel : AnyObject = self.novelData
        performSegueWithIdentifier("Synopsis", sender: novel)
    }
    
    //segueを呼び出したときに呼ばれるメソッド
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //セグエ名で判定を行う
        if segue.identifier == "Synopsis"{
            
            //遷移先のコントローラーの変数を用意する
            let noveltyController = segue.destinationViewController as! NoveltyController
            
            //遷移先のコントローラーに渡したい変数を格納（型を合わせてね）
            noveltyController.novelData = sender
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        //ログインしていない場合
        if PFUser.currentUser() == nil {
            self.loginLabel.text = "内容（あらすじ）はログインをすると見れます。"
            self.loginBtn.setTitle("ログインまたは新規登録", forState: .Normal)
            self.readSynopsisBtn.setTitle("ぜひ登録してくださいm(_ _)m", forState: .Normal)
            self.readSynopsisBtn.enabled = false
        } else {
            self.loginLabel.text = "こんにちは\(PFUser.currentUser()!.username!)さん。"
            self.loginBtn.setTitle("ログアウトする", forState: .Normal)
            self.readSynopsisBtn.setTitle("内容（あらすじ）を見る", forState: .Normal)
            self.readSynopsisBtn.enabled = true
        }
    }
    
    @IBAction func loginOrLogout(sender: AnyObject) {
        
        //ログインボタンクリック時実装
        if PFUser.currentUser() == nil {
            self.login()
        } else {
            self.logout()
        }
    }
    
    //ログイン処理
    func login() {
        
        //※UIをカスタマイズするのは面倒臭いときはこれを活用するのも一つの手かも...
        //LogInViewControllerをカスタマイズする（ParseUI.frameworkで提供されているもの）
        let login = PFLogInViewController()
        login.delegate = self
        login.fields = ([PFLogInFields.UsernameAndPassword, PFLogInFields.LogInButton, PFLogInFields.SignUpButton, PFLogInFields.PasswordForgotten, PFLogInFields.DismissButton])
        
        //SignUpViewControllerをカスタマイズする（ParseUI.frameworkで提供されているもの）
        let signup = PFSignUpViewController()
        signup.fields = ([PFSignUpFields.UsernameAndPassword, PFSignUpFields.SignUpButton, PFSignUpFields.Email, PFSignUpFields.DismissButton])
        signup.delegate = self
        login.signUpController = signup
        
        self.presentViewController(login, animated: true, completion: nil)
    }
    
    //ログアウト処理
    func logout() {
        PFUser.logOut()
        self.loginLabel.text = "内容（あらすじ）はログインをすると見れます。"
        self.loginBtn.setTitle("ログインまたは新規登録", forState: .Normal)
        self.readSynopsisBtn.setTitle("ぜひ登録してくださいm(_ _)m", forState: .Normal)
        self.readSynopsisBtn.enabled = false
    }
    
    //PFLogInViewControllerDelegateのメソッド
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        
        // ユーザ名とパスワードのチェックのメソッド
        if (!username.isEmpty || !password.isEmpty) {
            return true
        } else {
            let alertController = UIAlertController(title: "ログインできません",
                message: "ユーザー名またはパスワードに誤りがあります。", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            //エラー時にはポップアップを表示する
            logInController.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        print("Failed to log in...")
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        print("User dismissed the logInViewController")
    }
    
    //PFSignUpViewControllerDelegateのメソッド
    func signUpViewController(signUpController: PFSignUpViewController,
        shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
            
        //パスワードは8文字以上でお願いします
        if let password = info["password"] as? String {
            return password.utf16.count >= 8
        } else {
            return false
        }
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        print("Failed to sign up...")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
