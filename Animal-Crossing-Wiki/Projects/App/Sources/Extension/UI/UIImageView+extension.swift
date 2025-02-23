//
//  UIImageView+extension.swift
//  Animal-Crossing-Wiki
//
//  Created by Ari on 2022/05/27.
//

import Kingfisher
import UIKit
import OSLog

extension UIImageView {

    convenience init(path: String) {
        self.init(frame: .zero)
        setImage(with: path)
        contentMode = .scaleAspectFit
    }

    func setImage(with urlString: String, options: KingfisherOptionsInfo? = nil) {
        self.kf.indicatorType = .activity
        ImageCache.default.retrieveImage(forKey: urlString, options: options) { result in
            switch result {
            case .success(let value):
                if let image = value.image {
                    self.image = image
                } else {
                    let url = URL(string: urlString)
                    self.kf.setImage(with: url, options: options)
                }
            case .failure(let error):
                os_log(.error, log: .default, "⛔️ 캐시에서 이미지를 가져오는데 실패였습니다.\n에러내용: \(error.localizedDescription)")
            }
        }
    }
}
