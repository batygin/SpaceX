import Foundation

struct Launch: Codable {
    let rocketID: String
    let name: String
    let date: Int
    let success: Bool?

    private enum CodingKeys: String, CodingKey {
        case rocketID = "rocket"
        case name
        case date = "date_unix"
        case success
    }
}
