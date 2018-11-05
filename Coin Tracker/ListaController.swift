//
//  ListaController.swift
//  Coin Tracker
//
//  Created by Hektor Kastrati on 26/10/2018
//  Copyright © 2018 Hektor Kastrati. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

//Duhet te jete conform protocoleve per tabele
class ListaController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //Krijo IBOutlet tableView nga View
    //Krijo nje varg qe mban te dhena te tipit CoinCellModel
    //Krijo nje variable slectedCoin te tipit CoinCellModel!
    //kjo perdoret per tja derguar Controllerit "DetailsController"
    //me poshte, kur ndodh kalimi nga screen ne screen (prepare for segue)
    
    @IBOutlet weak var tableView: UITableView!
    
    var coins:[CoinCellModel] = [CoinCellModel]()
    var selectedCoin:CoinCellModel!
    
  //  var delegate:CoinsDelegate?
    
    //URL per API qe ka listen me te gjithe coins
    //per me shume detaje : https://www.cryptocompare.com/api/
    let APIURL = "https://min-api.cryptocompare.com/data/all/coinlist"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //regjistro delegate dhe datasource per tableview
        //regjistro custom cell qe eshte krijuar me NIB name dhe
        //reuse identifier
        tableView.delegate = self
        tableView.dataSource = self
     
        tableView.register(UINib.init(nibName: "CoinCell", bundle: nil), forCellReuseIdentifier: "coinCell")
        //Thirr funksionin getDataFromAPI()
        getDataFromAPI()
    }
    
    
    //Funksioni getDataFromAPI()
    //Perdor alamofire per te thirre APIURL dhe ruan te dhenat
    //ne listen vargun me CoinCellModel
    //Si perfundim, thrret tableView.reloadData()
    func getDataFromAPI(){
        
        Alamofire.request(APIURL).responseData { (data) in
            
            let jsonData = try! JSON(data: data.result.value!)
            
            for(key,coinJSON):(String,JSON) in jsonData["Data"] {
                
                   self.coins.append(CoinCellModel(coinName: coinJSON["CoinName"].stringValue, coinSymbol: coinJSON["Symbol"].stringValue, coinAlgo: coinJSON["Algorithm"].stringValue, totalSuppy: coinJSON["TotalCoinSupply"].stringValue, imagePath: coinJSON["ImageUrl"].stringValue))

               }
            
            
            self.tableView.reloadData()

        }
    }

    //Shkruaj dy funksionet e tabeles ketu
    //cellforrowat indexpath dhe numberofrowsinsection
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell") as! CoinCell
        
        let coinPerCell:CoinCellModel = coins[indexPath.row]

        cell.lblEmri.text = coinPerCell.coinName
        cell.lblTotali.text = coinPerCell.totalSuppy
        cell.lblAlgoritmi.text = coinPerCell.coinAlgo
        cell.lblSymboli.text = coinPerCell.coinSymbol
        
        let ikonaURL:URL = URL.init(string: coinPerCell.imagePath)!
        cell.imgFotoja.af_setImage(withURL: ikonaURL)
        
        return cell
    }
    
    
    //Funksioni didSelectRowAt indexPath merr parane qe eshte klikuar
    //Ruaj Coinin e klikuar tek selectedCoin variabla e deklarurar ne fillim
    //dhe e hap screenin tjeter duke perdore funksionin
    //performSeguew(withIdentifier: "EmriILidhjes", sender, self)
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCoin = coins[indexPath.row]
      //  delegate?.updateCoins(coin: selectedCoin)
        performSegue(withIdentifier: "shfaqDetajet", sender: nil)
    }
    
    
    //Beje override funksionin prepare(for segue...)
    //nese identifier eshte emri i lidhjes ne Storyboard.
    //controllerit tjeter ja vendosim si selectedCoin, coinin
    //qe e kemi ruajtur me siper
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "shfaqDetajet"){
            
            let menuShfaq = segue.destination as! DetailsController
            menuShfaq.selectedCoin = selectedCoin
        }
    }
  
  @IBAction func bntFavorit(_ sender: Any) {
        
        performSegue(withIdentifier: "lidhjafavorit", sender: nil)
    }
    

}
