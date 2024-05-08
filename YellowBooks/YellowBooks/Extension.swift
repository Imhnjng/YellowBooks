//
//  Extension.swift
//  YellowBooks
//
//  Created by IMHYEONJEONG on 5/8/24.
//

import Foundation
import UIKit

extension UIImageView {
    func loadFromURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
