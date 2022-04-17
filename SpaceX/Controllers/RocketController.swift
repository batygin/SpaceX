import Foundation
import UIKit

class RocketController {
    let baseURL = URL(string: "https://api.spacexdata.com/v4")!

    func fetchRockets(completion: @escaping (Result<[Rocket], Error>) -> Void) {
        let rocketsURL = baseURL.appendingPathComponent("rockets")

        let task = URLSession.shared.dataTask(with: rocketsURL) { (data, _, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let rocketResponse = try jsonDecoder.decode([Rocket].self, from: data)
                    completion(.success(rocketResponse))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    func fetchImage(with url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.scheme = "https"

        let task = URLSession.shared.dataTask(with: urlComponents!.url!) { (data, _, error) in
            if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else if let error = error {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    func fetchLaunch(completion: @escaping (Result<[Launch], Error>) -> Void) {
        let launchURL = baseURL.appendingPathComponent("launches")

        let task = URLSession.shared.dataTask(with: launchURL) { (data, _, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let launchResponse = try jsonDecoder.decode([Launch].self, from: data)
                    completion(.success(launchResponse))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
