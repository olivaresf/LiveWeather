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
            
            guard error == nil else {
                print(err!)
                errorBlock(err!)
            }
            
            if let httpResponse = urlResp as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    guard let dataDownloaded = data
                    else {
                        noDataBlock()
                        return
                    }
                    
                    dataDownloadedBlock(dataDownloaded)
                default:
                    let error = NetworkError.invalidRequest
                    print(error.rawValue)
                    errorBlock(error)
                }
            }
		}

		dataTask.resume()
    }
}
