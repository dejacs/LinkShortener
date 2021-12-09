import UIKit

protocol URLShortenerDisplaying: AnyObject {
    func copy(shortURL: String)
    func updateTable(with item: URLShortenerResponse)
    func updateTable(with itemList: [URLShortenerResponse])
    func displayShortURLError()
    func displayTableError()
    func displayUnsavedURLError()
    func displayCopyMessage()
}

fileprivate enum Layout {
    enum TableView {
        static let cellIdentifier = "Cell"
        static let accessibilityIdentifier = "recentlyUrlTableView"
    }
}

final class URLShortenerViewController: UIViewController {
    private lazy var tableViewHeader: UIView = {
        let header = URLShortenerTableViewHeader()
        header.delegate = self
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    private lazy var recentlyUrlTableView: UITableView = {
        let tableView = UITableView()
        tableView.tableHeaderView = tableViewHeader
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = true
        tableView.accessibilityIdentifier = Layout.TableView.accessibilityIdentifier
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .init(named: Strings.Color.primaryBackground)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Layout.TableView.cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var recentlyUrlDataSource: [URLShortenerResponse] = []
    
    private let viewModel: URLShortenerViewModeling
    
    init(viewModel: URLShortenerViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        viewModel.fetchShortenedURLList()
    }
}


// MARK: - ViewConfiguration
extension URLShortenerViewController: ViewConfiguration {
    func buildViewHierarchy() {
        view.addSubview(recentlyUrlTableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            recentlyUrlTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recentlyUrlTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            recentlyUrlTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recentlyUrlTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            tableViewHeader.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    func configureViews() {
        view.backgroundColor = .init(named: Strings.Color.primaryBackground)
        title = NSLocalizedString(Strings.LocalizableKeys.title, comment: "")
    }
}


// MARK: - UITableViewDelegate
extension URLShortenerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard recentlyUrlDataSource.indices.contains(indexPath.row) else { return }
        viewModel.copyShortURL(for: recentlyUrlDataSource[indexPath.row])
    }
}


// MARK: - UITableViewDataSource
extension URLShortenerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recentlyUrlDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Layout.TableView.cellIdentifier, for: indexPath)
        guard recentlyUrlDataSource.indices.contains(indexPath.row) else { return UITableViewCell() }
        cell.accessibilityIdentifier = "urlCell"
        cell.textLabel?.text = recentlyUrlDataSource[indexPath.row].originalURL
        cell.textLabel?.numberOfLines = LayoutDefaults.Label.numberOfLines
        return cell
    }
}


// MARK: - ButtonDelegate
extension URLShortenerViewController: ButtonDelegate {
    func didTapButton(text: String?) {
        viewModel.fetchShortURL(for: text)
    }
}


// MARK: - URLShortenerDisplaying
extension URLShortenerViewController: URLShortenerDisplaying {
    func copy(shortURL: String) {
        UIPasteboard.general.string = shortURL
    }
    
    func updateTable(with item: URLShortenerResponse) {
        recentlyUrlDataSource.append(item)
        recentlyUrlTableView.reloadData()
    }
    
    func updateTable(with itemList: [URLShortenerResponse]) {
        recentlyUrlDataSource.append(contentsOf: itemList)
        recentlyUrlTableView.reloadData()
    }
    
    func displayShortURLError() {
        let message = NSLocalizedString(Strings.LocalizableKeys.Link.TextField.Error.send, comment: "")
        displayToastError(message: message)
    }
    
    func displayTableError() {
        let message = NSLocalizedString(Strings.LocalizableKeys.Link.List.Error.message, comment: "")
        displayToastError(message: message)
    }
    
    func displayUnsavedURLError() {
        let message = NSLocalizedString(Strings.LocalizableKeys.Link.TextField.Error.save, comment: "")
        displayToastError(message: message)
    }
    
    func displayCopyMessage() {
        let message = NSLocalizedString(Strings.LocalizableKeys.copy, comment: "")
        displayToastError(message: message)
    }
}

private extension URLShortenerViewController {
    func displayToastError(message: String) {
        let viewWidthCenter: CGFloat = view.frame.size.width / 2
        let messageWidthSize: CGFloat = 100
        let messageHeightSize: CGFloat = 50
        let extraBottomMargin: CGFloat = 50
        
        let toastLabel = ViewHelper.toastLabel(
            message: message,
            font: .systemFont(ofSize: LayoutDefaults.FontSize.base02)
        )
        let roundedCorners: CGFloat = toastLabel.frame.height / 2
        
        toastLabel.frame = CGRect(
            x: viewWidthCenter - messageWidthSize,
            y: view.frame.size.height - messageHeightSize - extraBottomMargin,
            width: viewWidthCenter,
            height: messageHeightSize
        )
        toastLabel.layer.cornerRadius = roundedCorners
        view.addSubview(toastLabel)
        
        ViewHelper.addFadeAnimation(to: toastLabel)
    }
}
