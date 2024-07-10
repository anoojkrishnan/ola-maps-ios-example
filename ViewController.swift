// MARK: - ViewController.swift
//  EnRoute
//
//  Created by Anooj Krishnan G on 11/07/24.
//

import UIKit
import OlaMapNavigationSDK
import OlaMapDirectionFramework
import OlaTurf

class ViewController: UIViewController, OlaMapServiceDelegate {

    // MARK: - Properties

    private var olaMap: OlaMapService?
    private var retryCount = 0;

    // MARK: - Constants

    private let olaClientId = Constants.olaClientId
    private let olaClientSecret = Constants.olaClientSecret
    private let olaAuthUrl = Constants.olaAuthUrl
    private let olaTileUrl = Constants.olaTileUrl
    private let olaApiKey = Constants.olaApiKey
    
    private let maxRetry = 2;

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        if let accessToken = UserDefaults.standard.string(forKey: Constants.accessKeyLabel) {
            print(accessToken)
            self.initOlaMaps(accessToken: accessToken);
        }else{
            authenticateOla()
        }
    }

    // MARK: - Authentication

    private func authenticateOla() {
        let body = [
            "grant_type": "client_credentials",
            "scope": "olamaps",
            "client_id": olaClientId,
            "client_secret": olaClientSecret
        ]

        ApiManager.fetchData(from: olaAuthUrl, with: body) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(AuthResponseModel.self, from: data)
                    UserDefaults.standard.setValue(decodedData.accessToken, forKey: Constants.accessKeyLabel)
                    self.initOlaMaps(accessToken: decodedData.accessToken)
                } catch {
                    print("Error decoding JSON: \(error)")
                    self.resetAccessToken();
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
    private func resetAccessToken(){
        UserDefaults.standard.removeObject(forKey: Constants.accessKeyLabel);
        self.retryCount += 1;
        if(self.retryCount <= self.maxRetry){
            self.authenticateOla();
        }
    }

    // MARK: - OLA Maps Initialization

    private func initOlaMaps(accessToken: String) {
        let tileUrl = URL(string: "\(olaTileUrl + olaApiKey)")!
        self.olaMap = OlaMapService(token: accessToken,
                                    tileURL: tileUrl,
                                    clientId: olaClientId,
                                    userId: nil)

        DispatchQueue.main.async {
            self.olaMap?.loadMap(onView: self.view)
            self.olaMap?.delegate = self
            self.olaMap?.addCurrentLocationButton(self.view)
            self.olaMap?.setCurrentLocationMarkerColor(.systemBlue)
            self.olaMap?.setRotatingGesture(true)
        }
    }

    // MARK: - OlaMapServiceDelegate Methods

    func didChangeLocationManagerAuthorization(_ state: CLAuthorizationStatus) {
        if state == .authorizedWhenInUse || state == .authorizedAlways {
            DispatchQueue.main.async {
                self.olaMap?.recenterMap()
                self.olaMap?.setMaxZoomLevel(16.0)
            }
        }
    }

    func didChangeCamera() {
        // Handle camera changes (optional)
    }

    func regionIsChanging(_ gesture: OlaMapNavigationSDK.OlaMapGesture) {
        // Handle region changes (optional)
    }

    func mapFailedToLoad(_ error: Error) {
        // Handle map load failure
    }
}
