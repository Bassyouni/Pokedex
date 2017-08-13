//
//  PokeCollectionViewCell.swift
//  Pokedex
//
//  Created by Bassyouni on 7/1/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import UIKit

class PokeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pokeImage: UIImageView!
    
    @IBOutlet weak var pokeNameLabel: UILabel!
    
    var pokemon :Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    
    func updateUI(poke :Pokemon)
    {
        self.pokemon = poke
        self.pokeImage.image = UIImage(named: "\(self.pokemon.ID)")
        self.pokeNameLabel.text = self.pokemon.name.capitalized
    }
    
}
