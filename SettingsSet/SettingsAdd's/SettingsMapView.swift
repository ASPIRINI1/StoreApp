//
//  SettingsMapView.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 19.04.2022.
//

import UIKit
import MapKit

class SettingsMapView: MKMapView, MKMapViewDelegate {
    
    let appSettings = AppSettings()
    
    private var shopList: [CLLocation] = []
    
    /*{
        set {
            appSettings.shopList = newValue
        }
        get {
            return appSettings.shopList
        }
    }*/
    
    private var userPosition: CLLocation = CLLocation(latitude: 48.002188, longitude: 37.805033)
    
//    MARK: - Checking location premissions
    
    func checkPermissions() {
        let authoruzationStatus = CLAuthorizationStatus.notDetermined
        let locationManager = CLLocationManager()
        
        switch authoruzationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            break
        case .denied:
            let alert = UIAlertController(title: NSLocalizedString("Location services is deneid.", comment: ""), message: nil, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            let goToSettingsAction = UIAlertAction(title: NSLocalizedString("Go to settings", comment: ""), style: .default) { _ in
                
            }
            
            alert.addAction(OKAction)
            alert.addAction(goToSettingsAction)
            
//            present(alert, animated: true) ???
            
        default:
            break
        }
    }
    
    //    MARK: - Configurating mapView
    
    func configureMapView() {
        
        self.delegate = self
        shopList.append(CLLocation(latitude: 48.002655, longitude: 37.840235))
        
        let region = MKCoordinateRegion(center: shopList.first!.coordinate, latitudinalMeters: 50000, longitudinalMeters: 50000)
        
        self.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 40000)
                                  
        self.setCameraZoomRange(zoomRange, animated: true)
        self.setLocation(location: shopList.first!, regionRadius: 1000)
        
        createShopPin()
    }
    
//    MARK: - Getters/Setters
    
    func addShop(coorditate: CLLocation){
        shopList.append(coorditate)
    }
    
    func getShopList() -> [CLLocation]{
        return shopList
    }
    
//    MARK: - Creatigng store Annotation
    
    private func createShopPin() {
        
        var shopNumber = 1
        
        for shop in shopList{
            let pin = MKPointAnnotation()
            pin.title = "Shop №" + "\(shopNumber)"
//            pin.subtitle = "here"
            pin.coordinate = shop.coordinate
            self.addAnnotation(pin)
            shopNumber += 1
        }
    }
    
    //    MARK: - Creating route to store
    
    func route(to: CLLocation) {
        
        let fromPointItem = MKMapItem(placemark: MKPlacemark(coordinate: userPosition.coordinate))
        let toPointItem = MKMapItem(placemark: MKPlacemark(coordinate: to.coordinate))
        

        let request = MKDirections.Request()

        request.source = fromPointItem
        request.destination = toPointItem
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        
        directions.calculate(completionHandler: { responce, error in
            
            guard let responce = responce else { return }

            if responce.routes.count > 0 {
                let route = responce.routes.first!
                self.addOverlay(route.polyline, level: .aboveRoads)
//                let rect = route.polyline.boundingMapRect
//                self.setRegion(MKCoordinateRegion(rect), animated: true)
                self.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
            }
        })
    }
    
    
//    MARK: Opening Navigation App
    
    func openInNavigationApp(to: CLLocation){
        let toPointItem = MKMapItem(placemark: MKPlacemark(coordinate: to.coordinate))
        toPointItem.openInMaps()
    }
    
//    MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        
        render.lineWidth = 5
        render.strokeColor = .red
        
        return render
    }

}

// MARK: - MKMaoView extension

extension MKMapView {
    func setLocation(location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
