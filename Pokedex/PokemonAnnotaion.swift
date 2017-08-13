//
//  PokemonAnnotaion.swift
//  Pokedex
//
//  Created by Bassyouni on 8/13/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import Foundation
import MapKit

class PokemonAnnotaion :NSObject , MKAnnotation
{
    var coordinate = CLLocationCoordinate2D()
    var title: String?
    var pokemon: Pokemon!
    
    init(coordinate: CLLocationCoordinate2D , pokemon: Pokemon)
    {
        self.coordinate = coordinate
        self.pokemon = pokemon
        self.title = pokemon.name.capitalized
    }
}
