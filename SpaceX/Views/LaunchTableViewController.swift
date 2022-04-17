import UIKit

class LaunchTableViewController: UITableViewController {

    var rocket: Rocket!

    var launchesList = [Launch]()

    let rocketController = RocketController()

    init?(coder: NSCoder, rocket: Rocket) {
        self.rocket = rocket
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = rocket.name

        loadingLaunches()
    }

    func loadingLaunches() {
        rocketController.fetchLaunch { results in
            switch results {
            case .success(let lauches):
                self.createLaunchesList(lauches)
            case .failure(let error):
                self.displayError(error, title: "Проверьте соединение")
            }
        }
    }

    func createLaunchesList(_ launches: [Launch]) {
        DispatchQueue.main.async {

            for launch in launches where launch.rocketID == self.rocket.id {
                self.launchesList.append(launch)
            }

            self.launchesList.sort { $0.date > $1.date}
            self.tableView.reloadData()
        }
    }

    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return launchesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "Launches", for: indexPath) as! LaunchViewCell
        // swiftlint:enable force_cast
        cell.selectionStyle = .none

        let launch = launchesList[indexPath.row]
        cell.update(launch)

        return cell
    }
}
