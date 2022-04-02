//
//  BaseTarget.swift
//  AM-Exercise
//
//  Created by Aleksandr Dainiak on 02.04.2022.
//  Copyright © 2022 Michael Mavris. All rights reserved.
//

import Foundation

protocol BaseTarget {
    
    /// The target's scheme
    var scheme: String { get }
    
    /// Provides service's host name
    var host: String { get }
    
    /// Provides service's port
    var port: Int { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request
    var method: Method { get }
    
    /// Using stub or network
    var conectionType: ConectionType { get }
    
    /// The dta of stub sample. Using in case ConectionType.stub
    var sampleData: Data? { get }
}

extension BaseTarget {
    func loadDataInJSONFile(fileName: String, bundleToken: AnyClass) -> Data? {
        let bundle = Bundle(for: bundleToken)
        guard let filePath = bundle.path(forResource: fileName, ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            return nil
        }
        return data
    }
}


enum ConectionType {
    case stub
    case network
}

enum Method: String {
    case GET
    case POST
}

