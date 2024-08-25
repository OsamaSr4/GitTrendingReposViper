import UIKit
import Lottie
import SkeletonView

class RepositoriesViewController: UIViewController {
    
    struct Constants {
        var errorTitle = "Something went wrong"
        var errorDescription = "An alien is probably blocking you signals"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: RepositoriesPresenterInput!
    private var repositories: [Repository] = []
    private var animationView: LottieAnimationView?
    private var retryButton: UIButton?
    private var headingLabel: UILabel!
    private var descriptionLabel: UILabel!
    
    
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
        
        // Set up constraints for labels
        NSLayoutConstraint.activate([
            // Constraints for headingLabel
            headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headingLabel.topAnchor.constraint(equalTo: animationView!.bottomAnchor, constant: 20),
            
            // Constraints for descriptionLabel
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 8)
        ])
        
    }
    
    @objc private func retryButtonTapped() {
        presenter.didTapRetry()
        hideAnimationView()
    }
}

//MARK: Skeleton Loader
extension RepositoriesViewController {
    private func showSkeletonLoader() {
        tableView.showSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
    }
    
    private func hideSkeletonLoader() async {
        tableView.stopSkeletonAnimation()
        tableView.hideSkeleton()
    }
}

//MARK: Presenter Output
extension RepositoriesViewController: RepositoriesPresenterOutput {
    func showSkeletonLoader(_ bool: Bool) {
        Task{
            await bool ?  showSkeletonLoader() : hideSkeletonLoader()
        }
        
    }
    
    func displayRepositories(_ repositories: [Repository]) {
        self.repositories = repositories
        Task { @MainActor in
            self.hideAnimationView()
            self.tableView.reloadData()
        }
    }
    
    func displayError(_ message: String) {
        print("Error Message :", message)
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: presenter.threadConstant)
            self.showAnimationView()
            self.animationView?.play()
        }
    }
    
    @MainActor
    private func hideAnimationView(){
        self.animationView?.isHidden = true
        self.retryButton?.isHidden = true
        self.headingLabel.isHidden = true
        self.descriptionLabel.isHidden = true
    }
    
    @MainActor
    private func showAnimationView(){
        self.animationView?.isHidden = false
        self.retryButton?.isHidden = false
        self.headingLabel.isHidden = false
        self.descriptionLabel.isHidden = false
    }
}

//MARK: Table View Delegate And DataSource and UISetup
extension RepositoriesViewController : UITableViewDelegate, SkeletonTableViewDataSource{
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return RepositoriesCell.name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoriesCell.name, for: indexPath) as? RepositoriesCell else {return UITableViewCell()
        }
        let data = repositories[indexPath.row]
        cell.configure(with: data)
        return cell
    }
    
    private func setupTableView(){
        self.tableView.isSkeletonable = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 100
        self.tableView.estimatedRowHeight = 80
        tableView.register(UINib(nibName: RepositoriesCell.name, bundle: nil), forCellReuseIdentifier: RepositoriesCell.getIdentifier())
    }
}
