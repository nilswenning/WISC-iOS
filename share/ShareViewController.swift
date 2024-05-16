import UIKit
import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers

class ShareViewController: UIViewController {
    var shareMainViewModel = ShareMainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the closure to close the extension
        shareMainViewModel.onClose = { [weak self] in
            self?.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        }

        guard
            let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProvider = extensionItem.attachments?.first else {
            close()
            return
        }

        if itemProvider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
            itemProvider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { [weak self] (item, error) in
                if let nsUrl = item as? NSURL {
                    self?.shareMainViewModel.item = nsUrl
                }
                self?.shareMainViewModel.error = error
            }
        } else if itemProvider.hasItemConformingToTypeIdentifier(UTType.data.identifier) {
            itemProvider.loadItem(forTypeIdentifier: UTType.data.identifier, options: nil) { [weak self] (item, error) in
                if let nsData = item as? NSData {
                    self?.shareMainViewModel.item = nsData
                }
                self?.shareMainViewModel.error = error
            }
        } else {
            print("Unsupported item type.")
            close()
        }

        DispatchQueue.main.async {
            let contentView = UIHostingController(rootView: ShareMainView(shareMainViewModel: self.shareMainViewModel))
            self.addChild(contentView)
            self.view.addSubview(contentView.view)
            contentView.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                contentView.view.topAnchor.constraint(equalTo: self.view.topAnchor),
                contentView.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                contentView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                contentView.view.rightAnchor.constraint(equalTo: self.view.rightAnchor)
            ])
        }
    }

    func close() {
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
