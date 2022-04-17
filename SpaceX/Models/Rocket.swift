import Foundation

struct Rocket: Codable {
    let id: String
    let name: String
    let height: Size
    let diameter: Size
    let mass: Mass
    let payloadWeights: [PayloadWeights]
    let firstFlight: String
    let country: String
    let costPerLaunch: Int
    let firstStage: Stage
    let secondStage: Stage
    let images: [URL]

    private enum CodingKeys: String, CodingKey {
        case id, name, height, diameter, mass, country
        case payloadWeights = "payload_weights"
        case firstFlight = "first_flight"
        case costPerLaunch = "cost_per_launch"
        case firstStage = "first_stage"
        case secondStage = "second_stage"
        case images = "flickr_images"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.height = try container.decode(Size.self, forKey: .height)
        self.diameter = try container.decode(Size.self, forKey: .diameter)
        self.mass = try container.decode(Mass.self, forKey: .mass)
        self.country = try container.decode(String.self, forKey: .country)
        self.payloadWeights = try container.decode([PayloadWeights].self, forKey: .payloadWeights)
        self.firstFlight = try container.decode(String.self, forKey: .firstFlight)
        self.costPerLaunch = try container.decode(Int.self, forKey: .costPerLaunch)
        self.firstStage = try container.decode(Stage.self, forKey: .firstStage)
        self.secondStage = try container.decode(Stage.self, forKey: .secondStage)
        self.images = try container.decode([URL].self, forKey: .images)
    }
}

struct Size: Codable {
    let meters: Double
    let feet: Double
}

struct Mass: Codable {
    let killogram: Int
    let pounds: Int

    enum MassCodingKeys: String, CodingKey {
        case killogram = "kg"
        case pounds = "lb"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MassCodingKeys.self)

        self.killogram = try container.decode(Int.self, forKey: .killogram)
        self.pounds = try container.decode(Int.self, forKey: .pounds)
    }
}

struct PayloadWeights: Codable {
    let id: String
    let pounds: Int

    enum PayloadWeightsCodingKeys: String, CodingKey {
        case id
        case pounds = "lb"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PayloadWeightsCodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.pounds = try container.decode(Int.self, forKey: .pounds)
    }
}

struct Stage: Codable {
    let engines: Int
    let fuelAmount: Double
    let burnTime: Int?

    enum StageCodingKeys: String, CodingKey {
        case engines
        case fuelAmount = "fuel_amount_tons"
        case burnTime = "burn_time_sec"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StageCodingKeys.self)

        self.engines = try container.decode(Int.self, forKey: .engines)
        self.fuelAmount = try container.decode(Double.self, forKey: .fuelAmount)
        self.burnTime = try? container.decode(Int.self, forKey: .burnTime)
    }
}
