//
//  Pokemon.swift
//  Pokedex
//
//  Created by Bassyouni on 7/1/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon
{
    private var _name :String!
    private var _ID :Int!
    private var _description :String!
    private var _type :String!
    private var _defence :String!
    private var _height :String!
    private var _weight :String!
    private var _attack :String!
    private var _evoName :String!
    private var _evoID :String!
    private var _evoLvl :String!
    
    
    
    func grabDataFromApi(complete :@escaping downloadCompleted)
    {
        let path = URL(string: "\(pokeApiURL)\(_ID!)/")
        
        Alamofire.request(path!).responseJSON {
            response in
            
            let result = response.result
            
            if let dic = result.value as? Dictionary<String ,AnyObject>
            {
                if let attack = dic["attack"] as? Int
                {
                    self._attack = "\(attack)"
                }
                
                if let localDefense = dic["defense"] as? Int
                {
                    self._defence = "\(localDefense)"
                }
                
                if let localHeight = dic["height"] as? String
                {
                    self._height = localHeight
                }
                
                if let localWeight = dic["weight"] as? String
                {
                    self.weight = localWeight
                }
                
                if let typeArray = dic["types"] as? [Dictionary<String , AnyObject>] , typeArray.count > 0
                {
                    var count =  0
                    self._type = ""
                    for obj in typeArray
                    {
                        if let typeName = obj["name"] as? String
                        {
                            if count == typeArray.count - 1
                            {
                                self._type.append("\(typeName.capitalized)")
                            }
                            else{
                                self._type.append("\(typeName.capitalized) / ")
                            }
                            count += 1
                        }
                        
                    }
                    
                }
                else
                {
                    self._type = "None"
                }
                
                if let evoArray = dic["evolutions"] as? [Dictionary<String ,AnyObject>] , evoArray.count > 0
                {
                    let evoDic = evoArray[0]
                    
                    if let name = evoDic["to"] as? String
                    {
                        if name.range(of: "mega") == nil
                        {
                            self._evoName = name
                            
                            if let level = evoDic["level"] as? Int
                            {
                                self._evoLvl = "\(level)"
                            }
                            if let localEvoID = evoDic["resource_uri"] as? String
                            {
                                let temp = localEvoID.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                self._evoID = temp.replacingOccurrences(of: "/", with: "")
                            }
                        }
                    }
                }
                
                if let descArray = dic["descriptions"] as? [Dictionary<String , String>] , descArray.count > 0
                {
                    if let descURL = descArray[0]["resource_uri"]
                    {
                        let fullURL = "\(baseURL)\(descURL)"
                        Alamofire.request(fullURL).responseJSON {
                            response in
                            if let descDic = response.result.value as? Dictionary<String , AnyObject>
                            {
                                if let localDesc = descDic["description"] as? String
                                {
                                    let str = localDesc.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = str
                                }
                            }
                            complete()
                        }
                    }
                }
            }
        }
    }
    
    
    init(name :String , ID :Int) {
        self._ID = ID
        self._name = name
        self.attack = ""
        self._defence = ""
        self._description = ""
        self._height = ""
        self._type = ""
        self._weight = ""
        self._evoID = ""
        self._evoLvl = ""
        self._evoName = ""
    }
    
    var evoID :String {
        get{return _evoID}
    }
    
    var evoName :String {
        get{return _evoName}
    }
    
    var evoLvl :String {
        get{return _evoLvl}
    }
    
    var name :String
    {
        get{return _name}
        set{_name = newValue}
    }
    
    var ID :Int
    {
        get{return _ID}
        set{_ID = newValue}
    }
    
    var description :String
    {
        get{return _description}
        set{_description = newValue}
    }
    
    var type :String
    {
        get{return _type}
        set{_type = newValue}
    }
    
    var defence :String
    {
        get{return _defence}
        set{_defence = newValue}
    }
    
    var height :String
    {
        get{return _height}
        set{_height = newValue}
    }
    
    var weight :String
    {
        get{return _weight}
        set{_weight = newValue}
    }
    
    var attack :String
    {
        get{return _attack}
        set{_attack = newValue}
    }
    
    
    
    
}
