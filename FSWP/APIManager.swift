//
//  APIManager.swift
//  FSWP
//
//  Created by Pavel Grigorev on 24.02.2023.
//

import UIKit

final class APIManager {

    func getImage(imageView: UIImageView, width: CGFloat, height: CGFloat, mode: Mode) {
        let tunnel = "https://"
        let server = "picsum.photos"
        let endpoint = "/\(Int(width))/\(Int(height))"
        let urlStr = tunnel + server + endpoint + mode.rawValue
        guard let apiURL = URL(string: urlStr) else {
            fatalError("some Error")
        }
        let session = URLSession.shared//(configuration: .default)
        let task = session.dataTask(with: apiURL) { data, response, error in
            guard let data, error == nil else { return }
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }
        task.resume()
    }
}

enum Mode: String {
    case standart = ""
    case grayscale = "/?grayscale"
    case blur1 = "/?blur=2"
    case blur2 = "/?blur=5"
}
