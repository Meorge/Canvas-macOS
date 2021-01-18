//
//  AsyncImageLoader.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/18/21.
//

import Foundation
import SwiftUI
import Combine
import Alamofire

//class ImageLoader: ObservableObject {
//    @Published var image: Image?
//    private let url: URL
//    
//    init(url: URL) {
//        self.url = url
//        downloadImage()
//    }
//    
//    func downloadImage() {
//        AF.request("https://httpbin.org/image/png").responseImage { response in
//            debugPrint(response)
//
//            print(response.request)
//            print(response.response)
//            debugPrint(response.result)
//
//            if case .success(let image) = response.result {
//                print("image downloaded: \(image)")
//            }
//        }
//    }
//}
