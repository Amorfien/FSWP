//
//  wallpaperViewController.swift
//  FSWP
//
//  Created by Pavel Grigorev on 24.02.2023.
//

import UIKit

final class WallpaperViewController: UIViewController {

    private var mode: Mode = .standart

    private let apiManager = APIManager()

    private var imageWidth: CGFloat = 0
    private var imageHeight: CGFloat = 0

    private lazy var wpImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "scribble.variable")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var contextMenu = UIContextMenuInteraction(delegate: self)

    override var prefersStatusBarHidden: Bool {
        return true
    }
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGray
        self.imageWidth = UIScreen.main.bounds.width
        self.imageHeight = UIScreen.main.bounds.height
        constrains()
        setupGestures()
        tapGesture()

    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.imageWidth = UIScreen.main.bounds.width
        self.imageHeight = UIScreen.main.bounds.height
    }

    private func constrains() {
        view.addSubview(wpImageView)
        NSLayoutConstraint.activate([
            wpImageView.topAnchor.constraint(equalTo: view.topAnchor),
            wpImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wpImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wpImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.wpImageView.addGestureRecognizer(tapGestureRecognizer)
        self.wpImageView.addGestureRecognizer(longPressGestureRecognizer)
    }
    @objc private func tapGesture() {
        apiManager.getImage(imageView: wpImageView, width: 2 * imageWidth, height: 2 * imageHeight, mode: mode)
//        print(imageWidth, imageHeight)
    }

    @objc private func longPress() {
        wpImageView.addInteraction(contextMenu)
    }

}

extension WallpaperViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(actionProvider:  { _ in
            let mode1 = UIAction(title: "Standart", state: self.mode == .standart ? .on : .off) { _ in
                self.mode = .standart
                self.tapGesture()
            }
            let mode2 = UIAction(title: "Grayscale", state: self.mode == .grayscale ? .on : .off) { _ in
                self.mode = .grayscale
                self.tapGesture()
            }
            let mode3 = UIAction(title: "Blur-1", state: self.mode == .blur1 ? .on : .off) { _ in
                self.mode = .blur1
                self.tapGesture()
            }
            let mode4 = UIAction(title: "Blur-2", state: self.mode == .blur2 ? .on : .off) { _ in
                self.mode = .blur2
                self.tapGesture()
            }
            let pasteAction = UIAction(title: "Copy to clipboard", image: UIImage(systemName: "doc.on.doc")) { _ in
                let pasteBoard = UIPasteboard.general
                pasteBoard.image = self.wpImageView.image
            }
            let saveAction = UIAction(title: "Save to gallery", image: UIImage(systemName: "photo.on.rectangle.angled")) { _ in
                if let image = self.wpImageView.image {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
            }
            let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                let avc = UIActivityViewController(activityItems: [self.wpImageView.image!], applicationActivities: nil)
                self.present(avc, animated: true)
            }
            let modeMenu = UIMenu(title: "Picture mode:", /*options: .displayInline,*/ children: [mode1, mode2, mode3, mode4])
            return UIMenu(children: [pasteAction, saveAction, shareAction, modeMenu])
        })
    }

}
