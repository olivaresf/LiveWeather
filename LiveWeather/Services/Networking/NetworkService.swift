//
//  NetworkService.swift
//  LiveWeather
//
//  Created by Nirav Bhatt on 26/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import Foundation
typealias DataDownloadedBlock = (Data) -> Void
typealias NoDataAvailableBlock = () -> Void
typealias NetworkErrorBlock = (Error) -> Void

protocol NetworkService: Service {
	func getFromAPI(endPoint: EndPoint, entityId: String,
					dataDownloadedBlock: @escaping DataDownloadedBlock,
					noDataBlock: @escaping NoDataAvailableBlock, errorBlock: @escaping NetworkErrorBlock)
}
