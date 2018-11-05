//
//  FavoritetController.swift
//  Coin Tracker
//
//  Created by Hektor Kastrati on 26/10/2018
//  Copyright © 2018 Hektor Kastrati. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import AlamofireImage
import SwiftyJSON

//Klasa permbane tabele kshtuqe duhet te kete
//edhe protocolet per tabela
class FavoritetController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var coins:[CoinCellModel] = [CoinCellModel]()
    var selectedCoin:CoinCellModel!
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var context:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Lexo nga CoreData te dhenat dhe ruaj me nje varg§
        //qe duhet deklaruar mbi funksionin UIViewController
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "CoinCell", bundle: nil), forCellReuseIdentifier: "coinCell")
        context = appdelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Currency")
        request.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(request)
            print(results)
            for coin in results as! [NSManagedObject]{
                
                
                
                let foto:String = coin.value(forKey: "foto") as! String
                let emri:String = coin.value(forKey: "emri") as! String
                let total:String = coin.value(forKey: "total") as! String
                let algo:String = coin.value(forKey: "algo") as! String
                let symbol:String = coin.value(forKey: "symbol") as! String
                
                let coin:CoinCellModel  = CoinCellModel.init(coinName: emri, coinSymbol: symbol, coinAlgo: algo, totalSuppy: total, imagePath: foto)
                
                coins.append(coin)
                tableView.reloadData()
            }
            
        }catch{
            print("Gabim gjate marrjes se te dhenave")
        }
        
        
    }

   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return coins.count
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
       let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell") as! CoinCell
    
       let coinPerCell:CoinCellModel = coins[indexPath.row]
    
       cell.imgFotoja.af_setImage(withURL: URL(string: coinPerCell.imagePath)!)
       cell.lblAlgoritmi.text = coinPerCell.coinAlgo
       cell.lblEmri.text = coinPerCell.coinName
       cell.lblSymboli.text = coinPerCell.coinSymbol
       cell.lblTotali.text = coinPerCell.totalSuppy
    
       return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCoin = coins[indexPath.row]
        performSegue(withIdentifier: "shfaqDetajet2", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "shfaqDetajet2"){
        let menuShfaq = segue.destination as! DetailsController
        menuShfaq.selectedCoin = selectedCoin
        
        }
    }
        
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let request = NSFetchRequest <NSFetchRequestResult>(entityName: "Currency")
        
        selectedCoin = coins[indexPath.row]
        
        request.predicate = NSPredicate(format: "symbol == %@ ", selectedCoin.coinSymbol)
        
        do{
            
            let results = try context.fetch(request)
            for coin in results as! [NSManagedObject]{
                
                context.delete(coin)
            }
            coins.remove(at: indexPath.row)
            tableView.reloadData()
            
        }catch{
            
        }
    }

    @IBAction func btnKthehu(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
