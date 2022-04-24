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
    @IBOutlet weak var collectionView: UICollectionView!

    var rocket: Rocket!

    let rocketController = RocketController()

    var parametersRocketList: [RocketParameters] = []

    var dateFormatter: DateFormatter = {
        let formater = DateFormatter()
        formater.locale = Locale(identifier: "ru_RU")
        formater.timeZone = .current
        formater.dateFormat = "yyyy-MM-dd"

        return formater
    }()

    var numberFormatter: NumberFormatter = {
        let formater = NumberFormatter()
        formater.locale = Locale.current
        formater.numberStyle = .decimal
        formater.maximumFractionDigits = 1

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

        rocketParameters()

        updateUI()
        loadingImage(with: rocket)
    }

    func rocketParameters() {
        let parameters = [
            RocketParameters(nameParameter: "Высота, м", valueParameter: rocket.height.meters),
            RocketParameters(nameParameter: "Диаметр, м", valueParameter: rocket.diameter.meters),
            RocketParameters(nameParameter: "Масса, кг", valueParameter: rocket.mass.killogram),
            RocketParameters(nameParameter: "Нагрузка, фут", valueParameter: rocket.payloadWeights[0].pounds)
        ]

        parametersRocketList = parameters
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
        firstStageFuelAmountLabel.text = fuelAmountFormat(rocket.firstStage.fuelAmount)
        firstStageBurnTimeLabel?.text = burnTime(rocket.firstStage.burnTime ?? 0)

        secondStageEngineLabel.text = String(rocket.secondStage.engines)
        secondStageFuelAmountLabel.text = fuelAmountFormat(rocket.secondStage.fuelAmount)
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

    func fuelAmountFormat(_ sum: Double) -> String {
        let fuelAmounFormat = numberFormatter.string(from: sum as NSNumber)
        return "\(fuelAmounFormat ?? "—") тонн"
    }

    // MARK: Navigation

    @IBSegueAction func showLaunches(_ coder: NSCoder, sender: Any?) -> LaunchTableViewController? {
        return LaunchTableViewController(coder: coder, rocket: rocket)
    }
}

// MARK: Data Source

extension RocketViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parametersRocketList.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Features",
                                                      for: indexPath) as? FeaturesCollectionViewCell
        let item = parametersRocketList[indexPath.row]

        cell?.nameLabel.text = item.nameParameter
        // swiftlint:disable force_cast
        cell?.valueLabel.text = numberFormatter.string(from: item.valueParameter as! NSNumber)
        // swiftlint:enable force_cast

        return cell!
    }

}
