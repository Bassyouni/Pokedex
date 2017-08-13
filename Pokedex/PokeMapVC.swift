//
//  PokeMapVC.swift
//  Pokedex
//
//  Created by Bassyouni on 8/10/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class PokeMapVC: UIViewController, MKMapViewDelegate , CLLocationManagerDelegate{

    var ref: DatabaseReference!
    var geoFire: GeoFire!
    let locationManager = CLLocationManager()
    var mapHasCenterdOnce:Bool = false
    var pokeArray = [Pokemon]()
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        ref = Database.database().reference()
        geoFire = GeoFire(firebaseRef: ref)
        
        locationManager.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    func locationAuthStatus()
    {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            mapView.showsUserLocation = true
        }
        else
        {
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse
        {
            mapView.showsUserLocation = true
        }
    }
    
    func centerMapOnLocation(location : CLLocation)
    {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let location = userLocation.location
        {
            if !mapHasCenterdOnce
            {
                centerMapOnLocation(location: location)
                mapHasCenterdOnce = true
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annoIdentifier = "pokemon"
        var annotationView: MKAnnotationView!
        
        if annotation.isKind(of: MKUserLocation.self)
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotationView.image = UIImage(named: "ash")
        }
        else if let dequeAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifier)
        {
            annotationView = dequeAnno
            annotationView.annotation = annotation
        }
        else
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifier)
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let anno = annotation as? PokemonAnnotaion , let annotationView = annotationView
        {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "\(anno.pokemon.ID)")
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn.setImage(UIImage(named: "map"), for: .normal)
            annotationView.rightCalloutAccessoryView = btn
        }
        
        return annotationView
    }
    
    func createSighting(forLocation location: CLLocation , withPokemon pokemon: Pokemon)
    {
        geoFire.setLocation(location , forKey: "\(pokemon.ID)")
    }
    
    func showSightingOnMap(location: CLLocation)
    {
        let circleQuery = geoFire.query(at: location, withRadius: 2.5)
        
        _ = circleQuery?.observe(GFEventType.keyEntered, with: { (key, location) in
            
            if let key = key , let location = location
            {
                let annotaion = PokemonAnnotaion(coordinate: location.coordinate, pokemon: self.pokeArray[Int(key)! - 1])
                self.mapView.addAnnotation(annotaion)
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let anno = view.annotation as? PokemonAnnotaion
        {
            var place: MKPlacemark!
            if #available(iOS 10.0, *) {
                place = MKPlacemark(coordinate: anno.coordinate)
            } else {
                place = MKPlacemark(coordinate: anno.coordinate, addressDictionary: nil)
            }
            let destination = MKMapItem(placemark: place)
            destination.name = anno.pokemon.name.capitalized
            let regionDistance: CLLocationDistance = 1000
            let regionSpan = MKCoordinateRegionMakeWithDistance(anno.coordinate, regionDistance, regionDistance)
            
            let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey:  NSValue(mkCoordinateSpan: regionSpan.span), MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] as [String : Any]
            
            MKMapItem.openMaps(with: [destination], launchOptions: options)
        }
        
        
    }

    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        showSightingOnMap(location: location)
    }
    
    @IBAction func pokeBallPressed(_ sender: Any) {
        
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        let randomPokemon = Int(arc4random_uniform(717) + 0)
        self.createSighting(forLocation: location, withPokemon: self.pokeArray[randomPokemon])
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
