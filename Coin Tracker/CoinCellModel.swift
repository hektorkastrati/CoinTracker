//
//  CoinCellModel.swift
//  Coin Tracker
//
//  Created by Hektor Kastrati on 26/10/2018
//  Copyright © 2018 Hektor Kastrati. All rights reserved.
//

import Foundation

class CoinCellModel{
    
    internal let imageBase:String = "https://www.cryptocompare.com/"
    let imagePath:String
    let coinName:String
    let coinSymbol:String
    let coinAlgo:String
    let totalSuppy:String
    let originalImagePath:String
    
    init(coinName:String, coinSymbol:String, coinAlgo:String, totalSuppy:String, imagePath:String){
        
        self.coinName = coinName
        self.coinSymbol = coinSymbol
        self.coinAlgo = coinAlgo
        self.totalSuppy = totalSuppy
        self.originalImagePath = imagePath
        self.imagePath = "\(self.imageBase)\(imagePath)"
        
    }
    
}
