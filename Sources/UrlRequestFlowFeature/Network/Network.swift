//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/5/22.
//

import Foundation


public func sendHttpRequest(request: URLRequest)async throws->Data{
//        print(request)
//        print(request.url)
//        print(request.allHTTPHeaderFields)
//        print(request.httpBody?.count)
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        print(String(decoding: data, as: UTF8.self))
        print((response as? HTTPURLResponse)?.statusCode)
        throw URLError(.badServerResponse)
    }
    do{
        //print( String(decoding: data, as: UTF8.self) )
        //let result = try dataHandler.dataHander(data: data)
        //return result
        print(String(decoding: data, as: UTF8.self))
        return data
    }catch {
        let str = String(decoding: data, as: UTF8.self)
        print("error occured when decoding: \(error)", str)
        throw error
    }
}
