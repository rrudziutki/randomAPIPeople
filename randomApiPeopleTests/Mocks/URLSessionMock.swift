//
//  URLSessionMock.swift
//  randomApiPeopleTests
//
//  Created by Remigiusz Makuchowski on 08/05/2022.
//

import Foundation
@testable import randomApiPeople

class URLSessionMock: URLSessionProtocol {
    var mockDataTask = URLSessionDataTaskMock()
    var response: URLResponse?
    var data: Data?
    var error: Error?
    
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        completionHandler(data, response, error)
        return mockDataTask
    }
}

class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}
