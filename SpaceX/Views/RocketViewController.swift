import UIKit

class RocketViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstFlightLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var costPerLaunchLabel: UILabel!
    @IBOutlet weak var firstStageEngineLabel: UILabel!
    @IBOutlet weak var firstStageFuelAmountLabel: UILabel!
    @IBOutlet weak var firstStageBurnTimeLabel: UILabel!
    @IBOutlet weak var secondStageEngineLabel: UILabel!
    @IBOutlet weak var secondStageFuelAmountLabel: UILabel!
    @IBOutlet weak var secondStageBurnTimeLabel: UILabel!

    var rocket: Rocket!

    let rocketController = RocketController()

    var dateFormatter: DateFormatter = {
        let formater = DateFormatter()
        formater.locale = Locale(identifier: "ru_RU")
        formater.timeZone = .current
        formater.dateFormat = "yyyy-MM-dd"

        return formater
    }()

    init?(coder: NSCoder, rocket: Rocket) {
        self.rocket = rocket
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        loadingImage(with: rocket)
    }

    func loadingImage(with rocket: Rocket) {
        rocketController.fetchImage(with: rocket.images[0]) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.imageView.image = image
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func updateUI() {
        nameLabel.text = rocket.name

        // format and reformat date
        let date = dateFormatter.date(from: rocket.firstFlight)!
        let formatDate = dateFormatter
        formatDate.dateFormat = "d MMMM, yyyy"
        firstFlightLabel.text = formatDate.string(from: date)

        countryLabel.text = countryMaping(rocket.country)
        costPerLaunchLabel.text = formatSum(sum: rocket.costPerLaunch)

        firstStageEngineLabel.text = String(rocket.firstStage.engines)
        firstStageFuelAmountLabel.text = "\(rocket.firstStage.fuelAmount) тонн"
        firstStageBurnTimeLabel?.text = burnTime(rocket.firstStage.burnTime ?? 0)

        secondStageEngineLabel.text = String(rocket.secondStage.engines)
        secondStageFuelAmountLabel.text = "\(rocket.secondStage.fuelAmount) тонн"
        secondStageBurnTimeLabel?.text = burnTime(rocket.secondStage.burnTime ?? 0)
    }

    func countryMaping(_ country: String) -> String {
        switch country {
        case "United States":
            return "США"
        case "Republic of the Marshall Islands":
            return "Маршалловы Острова"
        default:
            return ""
        }
    }

    func formatSum(sum: Int) -> String {
        let sum = sum / 1000000
        return "$\(sum) млн."
    }

    func burnTime(_ time: Int) -> String {
        if time != 0 {
            return "\(time) сек."
        } else {
            return "—"
        }
    }

    // MARK: Navigation

    @IBSegueAction func showLaunches(_ coder: NSCoder, sender: Any?) -> LaunchTableViewController? {
        return LaunchTableViewController(coder: coder, rocket: rocket)
    }
}
