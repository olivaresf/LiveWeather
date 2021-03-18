//
//  RealNetworkService.swift
//  LiveWeather
//
//  Created by Nirav Bhatt on 11/2/20.
//

import Foundation

class RealNetworkService: NSObject, URLSessionDelegate, URLSessionTaskDelegate, NetworkService {
    private var session: URLSession
    private var opQueue: OperationQueue

    override init() {
        self.opQueue = OperationQueue()
        let configuration = URLSessionConfiguration.default
        self.session = URLSession(configuration: configuration, delegate: nil, delegateQueue: self.opQueue)
        super.init()
    }

    func getFromAPI(endPoint: EndPoint, entityId: String,
					dataDownloadedBlock: @escaping DataDownloadedBlock,
					noDataBlock: @escaping NoDataAvailableBlock,
					errorBlock: @escaping NetworkErrorBlock) {
		let urlString = endPoint.url + entityId
		guard let urlReq = RequestFactory.makeGETRequest(urlString: urlString)
		else {
			errorBlock(NetworkError.invalidURL)
			return
		}

		let dataTask = self.session.dataTask(with: urlReq) { (data, urlResp, err) in
            
            guard err == nil else {
                print(err!)
                errorBlock(err!)
                return
            }
            
            guard let httpResponse = urlResp as? HTTPURLResponse else {
                #warning("We aren't handling this use case.")
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                let error = NetworkError.invalidRequest
                print(error.rawValue)
                errorBlock(error)
                return
            }
            
            guard let dataDownloaded = data else {
                noDataBlock()
                return
            }
            
            dataDownloadedBlock(dataDownloaded)
		}

		dataTask.resume()
    }
}
