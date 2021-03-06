//
//  DetailCafeInfoViewController.swift
//  WhichOneDo
//
//  Created by 임성준 on 2020/05/22.
//  Copyright © 2020 강희선. All rights reserved.
//

import UIKit
import Firebase
class DetailCafeInfoViewController: UIViewController {
    //txt outlet
    @IBOutlet var txtCoffeeBeanHome: UILabel!
    @IBOutlet var txtCoffeeFlavor: UILabel!
    @IBOutlet var txtAmericanoPrice: UILabel!
    @IBOutlet var txtCafeBusinessHours: UILabel!
    @IBOutlet var txtCafeAddress: UILabel!
    @IBOutlet var txtCafePhone: UILabel!
    //variable outlet
    @IBOutlet var cafeImage: UIImageView!
    @IBOutlet var cafeName: UILabel!
    @IBOutlet var coffeeBeanHome: UILabel!
    @IBOutlet var coffeeFlavor: UILabel!
    @IBOutlet var americanoPrice: UILabel!
    @IBOutlet var cafeBusinessHours: UILabel!
    @IBOutlet var cafeAddress: UILabel!
    @IBOutlet var cafePhone: UILabel!
    var cafePosition: [Double] = []
    var cafeArray:[CafeModel] = []
    var name: String!
    var cafeId: String!
    @IBOutlet var btnStar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCafeDetail(name)
        isStar()
    }
    func get(_ name1:String){
        name = name1
    }

    func getCafeDetail(_ name1: String){
        Database.database().reference().child("cafes").observe(DataEventType.value, with: {
            (datasnapshot) in
            self.cafeArray.removeAll()
            for child in datasnapshot.children{
                let fchild = child as! DataSnapshot
                let cafeModel = CafeModel()
                cafeModel.setValuesForKeys(fchild.value as! [String:Any])
                if cafeModel.cafeName == name1{
                    self.cafeArray.append(cafeModel)
                    self.cafeName.text = name1
                    self.americanoPrice.text = self.cafeArray[0].americanoPrice
                    self.cafeAddress.text = self.cafeArray[0].location
                    self.cafePhone.text = self.cafeArray[0].number
                    self.cafeBusinessHours.text = self.cafeArray[0].cafeBusinessHours
                    self.coffeeFlavor.text = self.cafeArray[0].taste
                    self.coffeeBeanHome.text = self.cafeArray[0].coffeeBeanHome
                    self.cafePosition = self.cafeArray[0].coordinate
                    self.cafeId = self.cafeArray[0].cafeId
                    break
                }
            }
        })
    }
    
    @IBAction func favoriteTapped(_ sender: UIButton){
        let vc = self.presentingViewController as! UITabBarController
        let mapViewController = vc.viewControllers![0] as! MapViewController
        let favoriteViewContoller = vc.viewControllers![1] as! FavoriteViewController
        var stars = favoriteViewContoller.stars
        
        if sender.isSelected {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).child("stars").observeSingleEvent(of:DataEventType.value, with: {
                (datasnapshot) in
                for child in datasnapshot.children{
                    let fchild = child as! DataSnapshot
                    let starModel = StarModel()
                    starModel.setValuesForKeys(fchild.value as! [String : Any])
                    if starModel.cafeName == self.cafeName.text{
                        for (i,star) in stars.enumerated(){
                            if(star.cafeName == starModel.cafeName){
                                stars.remove(at: i)
                                favoriteViewContoller.stars = stars
                                break
                            }
                        }
                        Database.database().reference().child("users").child(uid!).child("stars").child(fchild.key).removeValue()
                        break
                    }
                }
            })
            mapViewController.mapUpdate()
            sender.isSelected = false
        } else {
            sender.isSelected = true
            let uid = Auth.auth().currentUser?.uid
            let value: Dictionary<String, Any> = ["cafeName": cafeName.text!, "cafePosition": cafePosition, "cafeId": cafeId!]
            Database.database().reference().child("users").child(uid!).child("stars").childByAutoId().setValue(value)
            favoriteViewContoller.getStarList1()
            mapViewController.mapUpdate()
        }
    }
    func isStar(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).child("stars").observe(DataEventType.value, with: {
            (datasnapshot) in
            for item in datasnapshot.children{
                let fchild = item as! DataSnapshot
                let starModel = StarModel()
                starModel.setValuesForKeys(fchild.value as! [String:Any])
                if self.cafeName.text == starModel.cafeName{
                    self.btnStar.isSelected = true
                }
            }
        })
    }
   
}
