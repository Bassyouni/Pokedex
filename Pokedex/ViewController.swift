//
//  ViewController.swift
//  Pokedex
//
//  Created by Bassyouni on 7/1/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UISearchBarDelegate{

    @IBOutlet weak var mapBtnPressed: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokeArray = [Pokemon]()
    var filteredPoke = [Pokemon]()
    var musicPlayer :AVAudioPlayer!
    var inSearchMode :Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        self.musicInit()
        self.loadPokeinArray()
    }
    
    func musicInit()
    {
        do
        {
            let path = Bundle.main.path(forResource: "music" , ofType: "mp3")!
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()

        }
        catch let err as NSError
        {
            print(err.debugDescription)
        }
        
        
    }
    func loadPokeinArray()
    {
        do{
            let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")
            let csv = try CSV(contentsOfURL: path!)
            for row in csv.rows
            {
                let poke = Pokemon(name: row["identifier"]!, ID: Int(row["id"]!)!)
                pokeArray.append(poke)
            }
            
        }catch let err as NSError
        {
            print(err.debugDescription)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode
        {
            return filteredPoke.count
        }
        return pokeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCollectionViewCell
        {
            let poke :Pokemon!
            if inSearchMode
            {
                poke = filteredPoke[indexPath.row]
            }
            else
            {
                poke = pokeArray[indexPath.row]
            }
            cell.updateUI(poke: poke)
            return cell
        }
        else { return UICollectionViewCell() }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke :Pokemon!
        
        if inSearchMode
        {
            poke = filteredPoke[indexPath.row]
        }
        else
        {
            poke = pokeArray[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokeDetailsVC", sender: poke)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
    @IBAction func musicBtnPressed(_ sender: Any) {
        
        if musicPlayer.isPlaying
        {
            musicPlayer.pause()
            (sender as? UIButton)?.alpha = 0.3
        }
        else
        {
            musicPlayer.play()
            (sender as? UIButton)?.alpha = 1.0
        }
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == ""
        {
            inSearchMode = false
            collectionView.reloadData()
        }
        else
        {
            inSearchMode = true
            filteredPoke = pokeArray.filter({$0.name.range(of:searchBar.text!.lowercased()) != nil})
            collectionView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    @IBAction func mapBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "PokeMapVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PokeDetailsVC
        {
            if let poke = sender as? Pokemon
            {
                destination.poke = poke
            }
        }
        else if let destination = segue.destination as? PokeMapVC
        {
            destination.pokeArray = self.pokeArray
        }
    }

}

