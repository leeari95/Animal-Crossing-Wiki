//
//  ItemDetailInfoView.swift
//  Animal-Crossing-Wiki
//
//  Created by Ari on 2022/07/06.
//

import UIKit

class ItemDetailInfoView: UIView {
    
    private lazy var backgroundStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 6
        return stackView
    }()
    
    private lazy var subImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    convenience init(item: Item) {
        self.init(frame: .zero)
        configure(in: item.category, item: item)
    }
    
    private func configure(in category: Category, item: Item) {
        addSubviews(backgroundStackView)
        setUpCategory(category)
        setUpImageView(item)
        setUpInfo(item)
        setUpItemBells(item)
        
        NSLayoutConstraint.activate([
            backgroundStackView.topAnchor.constraint(equalTo: topAnchor),
            backgroundStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func infoStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }
    
    private func setUpCategory(_ category: Category) {
        let iconImage = UIImageView(image: UIImage(named: category.iconName))
        iconImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconImage.heightAnchor.constraint(equalTo: iconImage.widthAnchor).isActive = true
        let titleLabel = UILabel(
            text: category.rawValue,
            font: .preferredFont(forTextStyle: .footnote),
            color: .acText
        )
        categoryStackView.addArrangedSubviews(iconImage, titleLabel)
        backgroundStackView.addArrangedSubviews(categoryStackView)
    }
    
    private func setUpImageView(_ item: Item) {
        if Category.critters.contains(item.category) {
            let critterpediaImageView = UIImageView(path: item.critterpediaImage)
            let furnitureImageView = UIImageView(path: item.furnitureImage)
            let iconImageView = UIImageView(path: item.iconImage)
            
            NSLayoutConstraint.activate([
                critterpediaImageView.widthAnchor.constraint(equalToConstant: 150),
                critterpediaImageView.heightAnchor.constraint(equalTo: critterpediaImageView.widthAnchor),
                furnitureImageView.widthAnchor.constraint(equalToConstant: 100),
                furnitureImageView.heightAnchor.constraint(equalTo: furnitureImageView.widthAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 100),
                iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor)
            ])
            
            subImageStackView.addArrangedSubviews(furnitureImageView, iconImageView)
            backgroundStackView.addArrangedSubviews(critterpediaImageView, subImageStackView)
        } else if let art = item as? Art, let highResTexture = art.highResTexture {
            let highResTextureImageView = UIImageView(path: highResTexture)
            backgroundStackView.addArrangedSubviews(highResTextureImageView)
            NSLayoutConstraint.activate([
                highResTextureImageView.widthAnchor.constraint(equalTo: backgroundStackView.widthAnchor),
                highResTextureImageView.heightAnchor.constraint(equalTo: highResTextureImageView.widthAnchor)
            ])
        } else {
            let imageView = UIImageView(path: item.image)
            imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
            backgroundStackView.addArrangedSubviews(imageView)
        }
    }
    
    private func setUpInfo(_ item: Item) {
        let titleLabel = UILabel(
            text: "",
            font: .preferredFont(for: .callout, weight: .semibold),
            color: .acSecondaryText
        )
        if item.whereHow != "" {
            titleLabel.text = item.whereHow
        } else if item.source != "" {
            titleLabel.text = item.source
        } else if item.category == .seaCreatures {
            titleLabel.text = "Underwater"
        }
        backgroundStackView.addArrangedSubviews(titleLabel)
        
        if [Category.fishes, Category.seaCreatures].contains(item.category) {
            let titleLabel = UILabel(
                text: "Shadow size:",
                font: .preferredFont(forTextStyle: .footnote)
            )
            let shadowLabel = UILabel(
                text: item.shadow.rawValue,
                font: .preferredFont(forTextStyle: .footnote),
                color: .acSecondaryText
            )
            let infoStackView = infoStackView()
            infoStackView.addArrangedSubviews(titleLabel, shadowLabel)
            backgroundStackView.addArrangedSubviews(infoStackView)
        }
        
        if item.category == .seaCreatures {
            let titleLabel = UILabel(
                text: "Movement Speed:",
                font: .preferredFont(forTextStyle: .footnote)
            )
            let speedLabel = UILabel(
                text: item.movementSpeed.rawValue,
                font: .preferredFont(forTextStyle: .footnote),
                color: .acSecondaryText
            )
            let infoStackView = infoStackView()
            infoStackView.addArrangedSubviews(titleLabel, speedLabel)
            backgroundStackView.addArrangedSubviews(infoStackView)
        }
    }
    
    private func setUpItemBells(_ item: Item) {
        if [Category.seaCreatures, Category.fishes].contains(item.category) {
            let sell = ItemBellsView(mode: .sell, price: item.sell)
            let cjSell = ItemBellsView(mode: .cj, price: Int(Double(item.sell) * 1.5))
            let infoStackView = infoStackView()
            infoStackView.spacing = 16
            infoStackView.addArrangedSubviews(sell, cjSell)
            backgroundStackView.addArrangedSubviews(infoStackView)
        } else if item.category == .bugs {
            let sell = ItemBellsView(mode: .sell, price: item.sell)
            let flickSell = ItemBellsView(mode: .flick, price: Int(Double(item.sell) * 1.5))
            let infoStackView = infoStackView()
            infoStackView.spacing = 16
            infoStackView.addArrangedSubviews(sell, flickSell)
            backgroundStackView.addArrangedSubviews(infoStackView)
        } else if item.buy > 0 {
            let buy = ItemBellsView(mode: .buy, price: item.buy)
            let sell = ItemBellsView(mode: .sell, price: item.sell)
            let infoStackView = infoStackView()
            infoStackView.spacing = 16
            infoStackView.addArrangedSubviews(buy, sell)
            backgroundStackView.addArrangedSubviews(infoStackView)
        } else {
            let sell = ItemBellsView(mode: .sell, price: item.sell)
            backgroundStackView.addArrangedSubviews(sell)
        }
    }
}
