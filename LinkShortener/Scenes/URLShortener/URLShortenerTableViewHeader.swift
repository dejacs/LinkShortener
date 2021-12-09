import UIKit

protocol ButtonDelegate: AnyObject {
    func didTapButton(text: String?)
}

class URLShortenerTableViewHeader: UIView {
    private lazy var originalURLTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString(Strings.LocalizableKeys.Link.TextField.placeholder, comment: "")
        textField.borderStyle = .roundedRect
        textField.accessibilityIdentifier = "urlTextField"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "sendButton"
        button.setImage(.init(systemName: Strings.SystemImage.checkmark.rawValue), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: ButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }
    
    required init?(coder: NSCoder) { nil }
}

@objc private extension URLShortenerTableViewHeader {
    func didTapSendButton() {
        delegate?.didTapButton(text: originalURLTextField.text)
    }
}

extension URLShortenerTableViewHeader: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(originalURLTextField)
        addSubview(sendButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            originalURLTextField.topAnchor.constraint(equalTo: topAnchor, constant: LayoutDefaults.View.margin01),
            originalURLTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutDefaults.View.margin01),
            originalURLTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -LayoutDefaults.View.margin01),
            originalURLTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -LayoutDefaults.View.margin01),
        ])
        NSLayoutConstraint.activate([
            sendButton.topAnchor.constraint(equalTo: topAnchor, constant: LayoutDefaults.View.margin01),
            sendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -LayoutDefaults.View.margin01),
            sendButton.heightAnchor.constraint(equalToConstant: LayoutDefaults.Button.height),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LayoutDefaults.View.margin01)
        ])
    }
    
    func configureViews() {
        backgroundColor = .init(named: Strings.Color.primaryBackground)
    }
}
