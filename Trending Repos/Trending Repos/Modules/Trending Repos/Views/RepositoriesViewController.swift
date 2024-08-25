import UIKit
import Lottie
import SkeletonView

class RepositoriesViewController: UIViewController {
    
    struct Constants {
        var errorTitle = "Something went wrong"
        var errorDescription = "An alien is probably blocking your signals"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: RepositoriesPresenterInput!
    private var repositories: [Repository] = []
    private var animationView: LottieAnimationView?
    private var retryButton: UIButton?
    private var headingLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var loadingFooterView: UIView?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter.viewDidLoad()
    }
    
    private func setupViews() {
        setupTableView()
        setupAnimationView()
        setupRetryButton()
        setupLabels()
        setupLoadingFooterView()
    }
    
    private func setupAnimationView() {
        animationView = LottieAnimationView(name: "NoInternetAnimation")
        animationView?.loopMode = .autoReverse
        animationView?.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationView?.center = view.center
        animationView?.isHidden = true  // Hide initially
        view.addSubview(animationView!)
    }
    
    private func setupRetryButton() {
        retryButton = UIButton(type: .system)
        retryButton?.setTitle("Retry", for: .normal)
        retryButton?.setTitleColor(UIColor(hexString: "#307279"), for: .normal)
        retryButton?.layer.borderWidth = 1
        retryButton?.layer.borderColor = UIColor(hexString: "#307279").cgColor
        retryButton?.layer.cornerRadius = 5
        retryButton?.frame = CGRect(x: 20, y: view.bounds.height - 100, width: view.bounds.width - 40, height: 50)
        retryButton?.isHidden = true
        retryButton?.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        view.addSubview(retryButton!)
    }
    
    private func setupLabels() {
        headingLabel = UILabel()
        headingLabel.text = Constants().errorTitle
        headingLabel.font = UIFont.boldSystemFont(ofSize: 24)
        headingLabel.textColor = .darkGray
        headingLabel.isHidden = true
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headingLabel)
        
        descriptionLabel = UILabel()
        descriptionLabel.text = Constants().errorDescription
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .gray
        descriptionLabel.isHidden = true
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headingLabel.topAnchor.constraint(equalTo: animationView!.bottomAnchor, constant: 20),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 8)
        ])
    }
    
    @objc private func retryButtonTapped() {
        presenter.didTapRetry()
        hideAnimationView()
    }
    
    
    private func setupLoadingFooterView() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = footerView.center
        activityIndicator.startAnimating()
        footerView.addSubview(activityIndicator)
        loadingFooterView = footerView
    }
}

// MARK: Skeleton Loader
extension RepositoriesViewController {
    private func showSkeletonLoader() {
        tableView.showSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
    }
    
    private func hideSkeletonLoader() async {
        tableView.stopSkeletonAnimation()
        tableView.hideSkeleton()
    }
}

// MARK: Presenter Output
extension RepositoriesViewController: RepositoriesPresenterOutput {
    func showSkeletonLoader(_ bool: Bool) {
        Task {
            await bool ? showSkeletonLoader() : hideSkeletonLoader()
        }
    }
    
    func displayRepositories(_ newRepositories: [Repository]) {
        self.repositories.append(contentsOf: newRepositories)
        Task { @MainActor in
            self.hideAnimationView()
            self.tableView.reloadData()
        }
    }
    
    func displayError(_ message: String) {
        print("Error Message:", message)
        Task { @MainActor in
            self.showAnimationView()
            self.animationView?.play()
        }
    }
    
    @MainActor
    private func hideAnimationView() {
        self.tableView.isHidden = false
        self.animationView?.isHidden = true
        self.retryButton?.isHidden = true
        self.headingLabel.isHidden = true
        self.descriptionLabel.isHidden = true
    }
    
    @MainActor
    private func showAnimationView() {
        self.tableView.isHidden = true
        self.animationView?.isHidden = false
        self.retryButton?.isHidden = false
        self.headingLabel.isHidden = false
        self.descriptionLabel.isHidden = false
    }
}

// MARK: Table View Delegate And DataSource
extension RepositoriesViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return RepositoriesCell.name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoriesCell.name, for: indexPath) as? RepositoriesCell else { return UITableViewCell() }
        let data = repositories[indexPath.row]
        cell.configure(with: data)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            tableView.tableFooterView = loadingFooterView
            presenter.fetchNextPage()
        }
    }
    
    private func setupTableView() {
        self.tableView.isSkeletonable = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 100
        self.tableView.estimatedRowHeight = 80
        tableView.register(UINib(nibName: RepositoriesCell.name, bundle: nil), forCellReuseIdentifier: RepositoriesCell.getIdentifier())
    }
}
