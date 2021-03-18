//
//  DummyNetworkService.swift
//  LiveWeather
//
//  Created by Nirav Bhatt on 11/2/20.
//  This is a stub network service class that supplies fake Data for unit tests.
//  Used for injection in viewmodel testing.

import Foundation

class DummyNetworkService: NSObject, NetworkService {
    func getFromAPI(endPoint: EndPoint, entityId: String,
					dataDownloadedBlock: @escaping DataDownloadedBlock,
					noDataBlock: @escaping NoDataAvailableBlock,
					errorBlock: @escaping NetworkErrorBlock) {
        
            if entityId.isEmpty {
                noDataBlock()
            } else {
                if let jsonData = RealFileService().dataFromJSONFile(filename: "LocationWeatherTestJSON") {
                    dataDownloadedBlock(jsonData)
                } else {
                    noDataBlock()
                }
            }
    }
}
