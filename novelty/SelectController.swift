//
//  SelectController.swift
//  novelty
//
//  Created by 酒井文也 on 2015/07/16.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

import UIKit

/* ------------------
Parse導入の事前準備
(1)Parse.comのページよりダウンロードしてきた下記のフレームワークをダウンロードする
・Parse.framework
・Bolt.framework
・ParseUI.framework(Parse.comが提供しているログインのUIを使う場合)
(2)Build SettingからFrameworkを追加します。（Objective-CとSwiftだとフレームワークの数が違いますので注意）

※更新履歴：
2015/12/16 Parseのバージョンをv1.7.5 → v1.11.0(この時点での最新版)にしました。
------------------ */

//Parseのインポート
import Parse

class SelectController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    //ノベル一覧のテーブルビュー
    @IBOutlet var novelTable: UITableView!
    
    //小説データを格納する場所
    var novelData: NSMutableArray = NSMutableArray()
    
    //テーブルビューの要素数(今回は決めうちだからこれで)
    let sectionCount: Int = 1
    
    //テーブルビューセルの高さ(Xibのサイズに合わせるのが理想)
    let tableViewCellHeight: CGFloat = 85.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        
        //tableViewデリゲート
        self.novelTable.delegate = self
        self.novelTable.dataSource = self
        
        //Xibのクラスを読み込む宣言を行う
        let nib:UINib = UINib(nibName: "novelListCell", bundle: nil)
        self.novelTable.registerNib(nib, forCellReuseIdentifier: "novelListCell")
        
        //Parseからのデータを取得してテーブルに表示する
        self.loadParseData()
        
        //Parseテスト用のコード（Object has been saved.がコンソールに表示されれば通信が成功）
        //解説：PFObject(className: "この中にはテーブル名が入ります")
        //解説：testObjectのインスタンスにKeyとValueのペアとして値を持たせる
        //解説：saveInBackgroundWithBlockで値をParseへ保存する
        /*
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            println("Object has been saved.")
        }
        */
    }

    //テーブルの行数を設定する ※必須
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //取得データの総数 ※要素数からとるようにすること！
        return self.novelData.count
    }
    
    //テーブルの要素数を設定する ※必須
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        //今回は1セクションだけ
        return sectionCount
    }
    
    //表示するセルの中身を設定する ※必須
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Xibファイルを元にデータを作成する
        let cell = tableView.dequeueReusableCellWithIdentifier("novelListCell") as? novelListCell
        let novel : AnyObject = novelData.objectAtIndex(indexPath.row)
        
        //各値をセルに入れる
        cell!.novelListTitle.text = novel.valueForKey("name") as? String
        cell!.novelListCategory.text = novel.valueForKey("category") as? String

        //※ descriptionってカラム名にしたらオブジェクトが取れた（謎）
        cell!.novelListDescription.text = novel.valueForKey("kcpy") as? String
        
        //セルの右に矢印をつけてあげる
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
        
        return cell!
    }
    
    //セルをタップした時に呼び出される
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //セグエの実行時に値を渡す
        let novel : AnyObject = novelData.objectAtIndex(indexPath.row)
        performSegueWithIdentifier("Login", sender: novel)
    }
    
    //segueを呼び出したときに呼ばれるメソッド
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //セグエ名で判定を行う
        if segue.identifier == "Login"{
            
            //遷移先のコントローラーの変数を用意する
            let loginController = segue.destinationViewController as! LoginController
            
            //遷移先のコントローラーに渡したい変数を格納（型を合わせてね）
            loginController.novelData = sender
        }
    }
    
    //セルの高さを返す ※任意
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableViewCellHeight
    }
    
    //データのリロード　※任意
    func loadParseData() {
        
        //いったん空っぽにしておく
        novelData.removeAllObjects()
        
        //parse.comのデータベースからデータを取得する
        let query:PFQuery = PFQuery(className: "Novel")
        //whereKeyメソッドで検索条件を指定
        query.whereKey("category", containsString: "小説")
        //orderByAscendingでカラムに対して昇順で並べる指定
        query.orderByAscending("createdAt")
        
        //クロージャーの中で上記の検索条件に該当するオブジェクトを取得する
        query.findObjectsInBackgroundWithBlock {
            (objects:[PFObject]?, error:NSError?) -> Void in
            
            //------ クロージャー内の処理：ここから↓ -----
            //エラーがないかの確認
            if error == nil {
                
                //正常処理（登録データあり）
                print("小説データが\(objects!.count)件あります！")
                
                //データが存在する場合はNSMutableArrayへデータを格納
                if let objects = objects {
                    
                    for object in objects {
                        
                        //該当データのUniqueなID(Optional値)
                        print(object.objectId)
                        
                        //取得したオブジェクトをメンバ変数へ格納
                        self.novelData.addObject(object)
                    }
                    //Debug.
                    //print(self.novelData)
                    
                    //テーブルビューをリロードする
                    self.novelTable.reloadData()
                    
                } else {
                    print("小説データがありませんでした！")
                }
                
            } else {
                //異常処理の際にはエラー内容の表示
                print("Error: \(error!) \(error!.userInfo)")
            }
            
        }
        //------ クロージャー内の処理：ここまで↑ -----
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

