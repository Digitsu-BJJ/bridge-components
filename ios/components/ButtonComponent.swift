import HotwireNative
import UIKit

public final class ButtonComponent: BridgeComponent {
    override public nonisolated class var name: String { "button" }

    override public func onReceive(message: Message) {
        guard let event = Event(rawValue: message.event) else { return }

        switch event {
        case .left, .right:
            addButton(via: message, side: event)
        }
    }

    private func addButton(via message: Message, side: Event) {
        guard let data: MessageData = message.data() else { return }

        let image = UIImage(systemName: data.image ?? "")
        let action = UIAction { [weak self] _ in
            self?.reply(to: message.event)
        }
        let item = UIBarButtonItem(title: data.title, image: image, primaryAction: action)

        switch side {
        case .left:
            viewController?.navigationItem.leftItemsSupplementBackButton = true
            viewController?.navigationItem.leftBarButtonItem = item
        case .right:
            viewController?.navigationItem.rightBarButtonItem = item
        }
    }
}

private extension ButtonComponent {
    enum Event: String {
        case left
        case right
    }
}

private extension ButtonComponent {
    struct MessageData: Decodable {
        let title: String
        let image: String?

        enum CodingKeys: String, CodingKey {
            case title
            case image = "iosImage"
        }
    }
}
