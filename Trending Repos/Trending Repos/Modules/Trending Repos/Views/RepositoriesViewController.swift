import UIKit
import Lottie

class RepositoriesViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: RepositoriesPresenterInput!
    private var repositories: [Repository] = []
    private var animationView: LottieAnimationView?
    private var retryButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        presenter.viewDidLoad()
    }
    
    private func setupViews() {
        setupAnimationView()
        setupRetryButton()
        registerCells()
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
    
    @objc private func retryButtonTapped() {
        presenter.didTapRetry()
    }
}

//MARK: Presenter Output
extension RepositoriesViewController: RepositoriesPresenterOutput {
    func displayRepositories(_ repositories: [Repository]) {
        
        Task { @MainActor in
            self.animationView?.isHidden = true
            self.retryButton?.isHidden = true
        }
    }
    
    func displayError(_ message: String) {
        print("Error Message :", message)
        Task { @MainActor in
            self.animationView?.isHidden = false
            self.retryButton?.isHidden = false
            self.animationView?.play()
        }
    }
}

//MARK: Table View Delegate And DataSource and UISetup
extension RepositoriesViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    private func registerCells(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: RepositoriesCell.name, bundle: nil), forCellReuseIdentifier: RepositoriesCell.getIdentifier())
    }
}
