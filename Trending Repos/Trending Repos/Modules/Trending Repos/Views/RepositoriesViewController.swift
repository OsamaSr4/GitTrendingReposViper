import UIKit
import Lottie

class RepositoriesViewController: UIViewController {
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
        retryButton?.setTitleColor(.green, for: .normal)  // Set text color to green
        retryButton?.layer.borderWidth = 1  // Set border width
        retryButton?.layer.borderColor = UIColor.green.cgColor  // Set border color to green
        retryButton?.layer.cornerRadius = 5  // Optional: add corner radius for rounded corners
        retryButton?.frame = CGRect(x: 20, y: view.bounds.height - 70, width: view.bounds.width - 40, height: 50)  // Leading and trailing 20, height 50
        retryButton?.isHidden = true  // Hide initially
        retryButton?.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        view.addSubview(retryButton!)
    }
    
    @objc private func retryButtonTapped() {
        presenter.didTapRetry()
    }
}

extension RepositoriesViewController: RepositoriesPresenterOutput {
    func displayRepositories(_ repositories: [Repository]) {
        Task { @MainActor in
            self.animationView?.isHidden = true
            self.retryButton?.isHidden = true
        }
    }
    
    func displayError(_ message: String) {
        // Show error, play Lottie animation, and show retry button
        print("Error Message :", message)
        Task { @MainActor in
            self.animationView?.isHidden = false
            self.retryButton?.isHidden = false
            self.animationView?.play()
        }
    }
}
