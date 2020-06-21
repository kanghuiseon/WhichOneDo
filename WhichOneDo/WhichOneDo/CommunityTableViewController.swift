//
//  CommunityTableViewController.swift
//  WhichOneDo
//
//  Created by 임성준 on 2020/06/21.
//  Copyright © 2020 강희선. All rights reserved.
//

import UIKit

//Model에 추가하면 될 듯
struct Community {
    var boardTitle: String?
    var title: String?
    var time: String?
    var userID: String?
    var likeNum: String?
    var commentsNum: String?
}

var a = Community(boardTitle: "자유게시판", title: "안녕하세요", time: "12:34", userID: "커피입문자", likeNum: "0", commentsNum: "0")
var b = Community(boardTitle: "리뷰게시판", title: "할리스커피 한양대점 리뷰", time: "20:47", userID: "카공족대표", likeNum: "4", commentsNum: "2")
var c = Community(boardTitle: "정보게시판", title: "어떤 원두가 내 취향일까?", time: "04:04", userID: "원두감별사", likeNum: "17", commentsNum: "29")
var d = Community(boardTitle: "이벤트", title: "스타벅스 여름 이벤트", time: "10:30", userID: "스타벅스 담당자", likeNum: "281", commentsNum: "99")

var communityList : [Community] = [a, b, c, d]

class CommunityTableViewController: UITableViewController {

    @IBOutlet var communityListTable: UITableView!
    @IBOutlet var btnWrite: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        communityListTable.delegate = self
        communityListTable.dataSource = self
        
        let nibName = UINib(nibName: "CommunityTableViewCell", bundle: nil)
        communityListTable.register(nibName, forCellReuseIdentifier: "communityCell")
        
        communityListTable.rowHeight = 100
        
        self.btnWrite.image = UIImage(named: "write")

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return communityList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "communityCell", for: indexPath) as! CommunityTableViewCell

        cell.boardTitle.text = communityList[indexPath.row].boardTitle
        cell.title.text = communityList[indexPath.row].title
        cell.time.text = communityList[indexPath.row].time
        cell.userID.text = communityList[indexPath.row].userID
        cell.likeNum.text = communityList[indexPath.row].likeNum
        cell.commentsNum.text = communityList[indexPath.row].commentsNum

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func Write() {
        let view = storyboard?.instantiateViewController(identifier: "write") as! WriteViewController
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }

}

