////
////  SampleViewController.swift
////
//
//import UIKit
//
//class SampleViewController: UIViewController {
//
//    // MARK: IBOutlets
//
//    @IBOutlet weak var headerOlt: CustomHeaderView!
//    @IBOutlet weak var homeTableView: UITableView!
//
//
//    // MARK: Properties
//    private var viewModel = HomeViewModel()
//
//    // MARK: Life Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        loadInitialSetup()
//
//    }
//
//    // MARK: Configuration Method
//
//    func loadInitialSetup(){
//        configureViews()
//        initViewModel()
//        observeEvent()
//    }
//
//
//    func initViewModel() {
//        viewModel.fetchProducts()
//    }
//    func configureViews() {
//
//        self.headerOlt.leftButton.setImage(UIImage(named: "backArrow"), for: .normal)
//        self.headerOlt.rightButton.setImage(UIImage(named: "notification"), for: .normal)
//        self.headerOlt.midLbl.isHidden = true
//        self.headerOlt.midLbl.text = "Choose a Game"
//        self.headerOlt.leftButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
//
//    }
//    // MARK: IBAction
//
//
//    // MARK: Methods
//
//    @objc func didTapBackButton() {
//        navigationController?.popViewController(animated: true)
//    }
//
//    func observeEvent() {
//        viewModelSignUp.eventHandler = { [weak self] event in
//            guard let self else { return }
//
//            switch event {
//            case .loading:
//                SVProgressHUD.show()
//            case .stopLoading:
//                SVProgressHUD.dismiss()
//            case .dataLoaded:
//                self.sucess()
//            case .error(let error):
//                print(error as Any)
//            }
//        }
//    }
//
//
//    func sucess() {
//        if viewModelSignUp.signUpDict?.status_code != 200 {
//            DispatchQueue.main.async {
//                Utilities.sharedInstance.showAlertController(title: "Error", message: (self.viewModelSignUp.signUpDict?.message)!, sourceViewController: self)
//            }
//        }else{
//            DispatchQueue.main.async {
//                Utilities.sharedInstance.showAlert2(title: "Succes", message: (self.viewModelSignUp.signUpDict?.message)!, sourceViewController: self){result in
//                    self.navigationController?.popToRootViewController(animated: true)
//                }
//            }
//        }
//    }
//
//
//    // MARK: Sercices
//
//}
// MARK: Extension
//
//
//extension SampleViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        viewModel.products.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as? ProductCell else {
//            return UITableViewCell()
//        }
//        let product = viewModel.products[indexPath.row]
//        cell.product = product
//        return cell
//    }
//
//}
//
//
//
//MARK: NotificationCenter addObserver in Swift
//
//NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
//NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["Renish":"Dadhaniya"])
//NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
//@objc func methodOfReceivedNotification(notification: Notification) {}
