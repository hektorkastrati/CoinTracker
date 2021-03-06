//
//  ViewController.swift
//  Coin Tracker
//
//  Created by Hektor Kastrati on 26/10/2018
//  Copyright © 2018 Hektor Kastrati. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import CoreData


class DetailsController: UIViewController {

    var selectedCoin:CoinCellModel!
    
    //IBOutlsets jane deklaruar me poshte
    @IBOutlet weak var imgFotoja: UIImageView!
    @IBOutlet weak var lblDitaOpen: UILabel!
    @IBOutlet weak var lblDitaHigh: UILabel!
    @IBOutlet weak var lblDitaLow: UILabel!
    @IBOutlet weak var lbl24OreOpen: UILabel!
    @IBOutlet weak var lbl24OreHigh: UILabel!
    @IBOutlet weak var lbl24OreLow: UILabel!
    @IBOutlet weak var lblMarketCap: UILabel!
    @IBOutlet weak var lblCmimiBTC: UILabel!
    @IBOutlet weak var lblCmimiEUR: UILabel!
    @IBOutlet weak var lblCmimiUSD: UILabel!
    @IBOutlet weak var lblCoinName: UILabel!
    
    let APIURL = "https://min-api.cryptocompare.com/data/pricemultifull"
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var context:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgFotoja.af_setImage(withURL: URL(string: selectedCoin.imagePath)!)
        lblCoinName.text = selectedCoin.coinName
      
        context = appdelegate.persistentContainer.viewContext
        
        let fsyms = selectedCoin.coinSymbol
        let tsyms = "BTC,USD,EUR"
        
        let params:[String:String] = ["fsyms":fsyms, "tsyms":tsyms]

        getDetails(params: params)
        
        
    }

    func getDetails(params:[String:String]){
        
        Alamofire.request(APIURL, method: .get, parameters: params).responseData { (responseData) in
            
            if responseData.result.isSuccess {
                
                let coinsJSON = try! JSON(responseData.result.value)
                
                let ditaOpen = coinsJSON["DISPLAY"]["\(self.selectedCoin.coinSymbol)"]["USD"]["OPENDAY"].stringValue
                let ditaHigh = coinsJSON["DISPLAY"]["\(self.selectedCoin.coinSymbol)"]["USD"]["HIGHDAY"].stringValue
                let ditaLow = coinsJSON["DISPLAY"]["\(self.selectedCoin.coinSymbol)"]["USD"]["LOWDAY"].stringValue
                let open24h = coinsJSON["DISPLAY"]["\(self.selectedCoin.coinSymbol)"]["USD"]["OPEN24HOUR"].stringValue
                let high24h = coinsJSON["DISPLAY"]["\(self.selectedCoin.coinSymbol)"]["USD"]["HIGH24HOUR"].stringValue
                let low24h = coinsJSON["DISPLAY"]["\(self.selectedCoin.coinSymbol)"]["USD"]["LOW24HOUR"].stringValue
                let marketCap = coinsJSON["DISPLAY"]["\(self.selectedCoin.coinSymbol)"]["USD"]["MKTCAP"].stringValue
                let cmimiBTC = coinsJSON["DISPLAY"]["\(self.selectedCoin.coinSymbol)"]["BTC"]["PRICE"].stringValue
                let cmimiEUR = coinsJSON["DISPLAY"]["\(self.selectedCoin.coinSymbol)"]["EUR"]["PRICE"].stringValue
                let cmimiUSD = coinsJSON["DISPLAY"]["\(self.selectedCoin.coinSymbol)"]["USD"]["PRICE"].stringValue
                
                
                
                self.lblDitaOpen.text = ditaOpen
                self.lblDitaHigh.text = ditaHigh
                self.lblDitaLow.text = ditaLow
                self.lbl24OreOpen.text = open24h
                self.lbl24OreHigh.text = high24h
                self.lbl24OreLow.text = low24h
                self.lblMarketCap.text = marketCap
                self.lblCmimiBTC.text = cmimiBTC
                self.lblCmimiEUR.text = cmimiEUR
                self.lblCmimiUSD.text = cmimiUSD
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func btnMbyll(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func ruajFavorit(_ sender: Any) {
        
        if(selectedCoin != nil){
            
            let coinIRi = NSEntityDescription.insertNewObject(forEntityName: "Currency", into: self.context)
            coinIRi.setValue(selectedCoin?.originalImagePath, forKey: "foto")
            coinIRi.setValue(selectedCoin?.coinName, forKey: "emri")
            coinIRi.setValue(selectedCoin?.totalSuppy, forKey: "total")
            coinIRi.setValue(selectedCoin?.coinAlgo, forKey: "algo")
            coinIRi.setValue(selectedCoin?.coinSymbol, forKey: "symbol")
            
            do{
                try context.save()
              //  print("U ruajt")
            }catch{
                print("Gabim gjate ruajtejes se te dhenave")
            }
        }
        
    }

}

