//
//  ViewController.swift
//  MySQLData
//
//  Created by akiko hayashi on 2017/12/18.
//  Copyright © 2017年 akiko hayashi. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView = UITableView()
    
    //タップしたセル
    var tapCell: [NSIndexPath:Bool] = [:]
    //日付
    var dateArray:[String] = []
    //タイトル
    var titleArray:[String] = []
    //内容
    var contentsArray:[String] = []
    
    //通信先のURL
    let urlString = "https://xxxxxx.xxx/test.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //============================================
        //一覧
        //============================================
        tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.register(ContentsTableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView)
        
        tableView.tableFooterView = UIView()
        //データを取得する
        self.getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*********************************
     * データを取得する
     **********************************/
    func getData(){
        //GET用のリクエストを生成
        var request   = URLRequest(url: URL(string:self.urlString)!)
        // GETのメソッドを指定
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask( with: request, completionHandler: { data, response, error in
            if (error == nil) {
                let json = JSON(data: data!)
                for (index,subJson):(String, JSON) in json {
                    if(index == "0"){
                        self.dateArray = [subJson["date"].stringValue]
                        self.titleArray = [subJson["title"].stringValue]
                        self.contentsArray = [subJson["contents"].stringValue]
                    }else{
                        self.dateArray.append(subJson["date"].stringValue)
                        self.titleArray.append(subJson["title"].stringValue)
                        self.contentsArray.append(subJson["contents"].stringValue)
                    }
                }
                //メインスレッドで実行
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print(error!)
            }
        })
        task.resume()
    }
    
    /*********************************
     * セルの高さ
     **********************************/
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //デフォルトの高さ
        var result: CGFloat = 68
        let row = NSIndexPath(row: indexPath.row, section: 0)

        if (tapCell.keys.contains(row)) {
            if (tapCell[row])! {
                //縦サイズを計算するためのUILabel
                let label:UILabel = UILabel()
                label.frame = CGRect(x: 10, y: 40, width: UIScreen.main.bounds.size.width - 20, height: 0)
                label.text = "\(dateArray[indexPath.row])　 \(contentsArray[indexPath.row])"
                label.font = UIFont(name:"Arial", size:13)
                label.numberOfLines = 0
                label.textAlignment = .left
                label.sizeToFit()

                //タップしたものが閉じているときは開く(ContentsTableViewCellのお知らせ内容のy:40 + 余白:10)
                result = label.bounds.height + 50
            }else{
                //タップしたものが開いているときは閉じる
                result = 68
            }
        }
        print("result:",result)
        return result
    }

    /*********************************
     * セクションの数
     **********************************/
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /*********************************
     * セルの個数を指定するデリゲートメソッド（必須）
     **********************************/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    /*********************************
     * セルに値を設定するデータソースメソッド（必須）
     **********************************/
    func tableView(_ cellForRowAttableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellForRowAttableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ContentsTableViewCell
        
        let row = NSIndexPath(row: indexPath.row, section: 0)
        cell.cellTitle.text = titleArray[indexPath.row] + "v"

        if (tapCell.keys.contains(row)) {
            if (tapCell[row])! {
                cell.cellContent.text = "\(dateArray[indexPath.row])　 \(contentsArray[indexPath.row])"
                cell.cellTitle.text = "\(titleArray[indexPath.row])  ^"
            }else{
                cell.cellContent.text = ""
                cell.cellTitle.text = "\(titleArray[indexPath.row])  v"
            }
        }
        return cell
    }
    
    /*********************************
     * セルが選択されたとき
     **********************************/
    func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {
        let row = NSIndexPath(row: indexPath.row, section: 0)
        //初回タップ
        if (tapCell.count == 0) {
            tapCell[row] = true
        }else{
            //過去にタップしたものがあれば更新
            if (tapCell.keys.contains(row)) {
                if (tapCell[row])! {
                    tapCell[row] = false
                }else{
                    tapCell[row] = true
                }
            }else{
                //過去にタップしたものがなければ追加
                tapCell[row] = true
            }
        }
        //タップした行だけ更新する
        tableView.reloadRows(at: [row as IndexPath], with: UITableViewRowAnimation.fade)
    }
}

