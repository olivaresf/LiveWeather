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
            // This do/catch block was only used to catch the `dataDownloadedBlock` thrown error.
            // I can see that it' was also useful to throw networing errors (first if) and http status code errors (default case).
            // However, we can easily call `errorBlock` or `noDataBlock` directly.
			do {
				if err != nil {
					throw err!
				}

				if let httpResponse = urlResp as? HTTPURLResponse {
					switch httpResponse.statusCode {
					case 200:
						guard let dataDownloaded = data
						else {
							noDataBlock()
							return
						}

						try dataDownloadedBlock(dataDownloaded)
					default:
						throw NetworkError.invalidRequest
					}
				}
			} catch let error as NetworkError {
				print(error.rawValue)
				errorBlock(error)
			} catch let error {
				print(error)
				errorBlock(error)
			}
		}

		dataTask.resume()
    }
}
