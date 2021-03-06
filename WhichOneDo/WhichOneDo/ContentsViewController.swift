//
//  ContentsViewController.swift
//  WhichOneDo
//
//  Created by 임성준 on 2020/06/21.
//  Copyright © 2020 강희선. All rights reserved.
//

import UIKit
import Firebase
class ContentsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    @IBOutlet var detailUserID: UILabel!
    @IBOutlet var detailTitle: UILabel!
    @IBOutlet var detailContents: UITextView!
    @IBOutlet var detailLikeNum: UILabel!
    @IBOutlet var detailCommentsNum: UILabel!
    @IBOutlet var detailTime: UILabel!
    @IBOutlet var commentsList: UITableView!
    @IBOutlet var tfComment: UITextField!
    @IBOutlet var btnSend: UIButton!
    @IBOutlet var btnLike: UIButton!
    @IBOutlet var btnDone: UIButton!
    
    var receiveCommunity : CommunityModel!
    var like: String?
    var like2: Int?
    var commentn: String?
    var commentn2: Int?
    var communityId: String?
    var comments: [String] = []
    var times: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getCommentsList()
        let formatter = DateFormatter()
        let write_time_string = formatter.string(from: Date())
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        detailTime.text = write_time_string
        self.navigationController?.navigationBar.tintColor = UIColor.black

        detailUserID.text = receiveCommunity.userId
        detailTitle.text = receiveCommunity.title
        detailContents.text = receiveCommunity.contents
        detailLikeNum.text = receiveCommunity.likeNum
        detailCommentsNum.text = receiveCommunity.commentsNum
        detailTime.text = receiveCommunity.time
        like = receiveCommunity.likeNum
        like2 = Int(like!)
        commentn = receiveCommunity.commentsNum
        commentn2 = Int(commentn!)
        
        commentsList.delegate = self
        commentsList.dataSource = self
        
        let nibName = UINib(nibName: "CommentsTableViewCell", bundle: nil)
        commentsList.register(nibName, forCellReuseIdentifier: "CommentsTableViewCell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommentsTableViewCell = commentsList.dequeueReusableCell(withIdentifier: "CommentsTableViewCell") as! CommentsTableViewCell
        cell.comment!.text = comments[indexPath.row]
        cell.time!.text = times[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    func receiveCommunity(_ item: CommunityModel!, _ item2: String) {
        receiveCommunity = item
        communityId = item2
    }
    
    @IBAction func LikeEvent(_ sender: Any) {
        like2! += 1
        detailLikeNum.text = String(like2!)
        Database.database().reference().child("community").child(communityId!).child("likeNum").setValue(String(like2!))
    }
    @IBAction func uploadComment(_ sender: Any) {
        commentn2! += 1
        detailCommentsNum.text = String(commentn2!)
        Database.database().reference().child("community").child(communityId!).child("commentsNum").setValue(String(commentn2!))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let write_time_string = formatter.string(from: Date())
        let value: Dictionary<String, Any> = ["comment": tfComment.text!, "time": write_time_string]
        Database.database().reference().child("comments").child(communityId!).childByAutoId().setValue(value)
        self.comments.append(tfComment.text!)
        tfComment.text = ""
    }
    func getCommentsList(){
        Database.database().reference().child("comments").child(communityId!).observe(DataEventType.value, with: {
            (datasnapshot) in
            self.comments.removeAll()
            self.times.removeAll()
            for child in datasnapshot.children{
                let fchild = child as! DataSnapshot
                let f = fchild.value as! [String:Any]
                self.comments.append(f["comment"] as! String)
                self.times.append(f["time"] as! String)
            }
            self.commentsList.reloadData()
        })
    }
    @IBAction func doneEvent(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
