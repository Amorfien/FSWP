//
//  APIManager.swift
//  FSWP
//
//  Created by Pavel Grigorev on 24.02.2023.
//

import UIKit

final class APIManager {

    func getImage(imageView: UIImageView, width: CGFloat, height: CGFloat, mode: Mode) {
        let API = "https://picsum.photos/\(Int(width))/\(Int(height))" + mode.rawValue
        guard let apiURL = URL(string: API) else {
            fatalError("some Error")
        }
        let session = URLSession.shared//(configuration: .default)
        let task = session.dataTask(with: apiURL) { data, response, error in
            guard let data, error == nil else { return }
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
//                print(data)
            }
        }
        task.resume()
    }
}
