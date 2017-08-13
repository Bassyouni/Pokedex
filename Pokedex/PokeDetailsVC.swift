//
//  PokeDetailsVC.swift
//  Pokedex
//
//  Created by Bassyouni on 7/2/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import UIKit

class PokeDetailsVC: ParentViewController {

    var poke :Pokemon!
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var currentEvoImage: UIImageView!
    @IBOutlet weak var nextEvoImage: UIImageView!
    
    @IBOutlet weak var basicAttackLabel: UILabel!
    @IBOutlet weak var pokedexIDLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptiomLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var nextEvoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoading()
        poke.grabDataFromApi {
            self.updateUI()
            self.hideLoading()
        }

    }
    
    func updateUI()
    {
        self.nameLabel.text = poke.name.capitalized
        self.basicAttackLabel.text = poke.attack
        self.pokedexIDLabel.text = "\(poke.ID)"
        self.heightLabel.text = poke.height
        self.defenseLabel.text = poke.defence
        self.typeLabel.text = poke.type
        self.weightLabel.text = poke.weight
        self.mainImage.image = UIImage(named: "\(poke.ID)")
        self.currentEvoImage.image = UIImage(named: "\(poke.ID)")
        self.descriptiomLabel.text = poke.description
        
        if poke.evoID == ""
        {
            self.nextEvoLabel.text = "Next Eveloution: None"
            self.nextEvoImage.isHidden = true
        }
        else
        {
            self.nextEvoLabel.text = "Next Eveloution: \(poke.evoName) - LvL \(poke.evoLvl)"
            self.nextEvoImage.isHidden = false
            self.nextEvoImage.image = UIImage(named: poke.evoID)
        }
 
    }

    @IBAction func retrunBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }


}
