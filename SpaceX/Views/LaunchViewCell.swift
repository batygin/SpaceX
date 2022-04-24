import UIKit

class LaunchViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!

    var dateFormatter: DateFormatter = {
        let formater = DateFormatter()
        formater.locale = Locale(identifier: "ru_RU")
        formater.timeZone = .current
        formater.dateFormat = "d MMMM, yyyy"

        return formater
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func update(_ launch: Launch) {
        nameLabel.text = launch.name

        let timeInterval = TimeInterval(launch.date)
        let date = Date(timeIntervalSince1970: timeInterval)
        dateLabel.text = dateFormatter.string(from: date)

        if launch.success == true {
            iconView.image = UIImage(named: "rocket-launch")
        } else {
            iconView.image = UIImage(named: "rocket-crash")
        }
    }
}
