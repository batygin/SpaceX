import UIKit

class RocketsPageViewController: UIPageViewController {

    var orderedViewControllers = [UIViewController]()

    private let rocketController = RocketController()

    private var rocketList = [Rocket]()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self

        rocketController.fetchRockets { results in
            switch results {
            case .success(let rockets):
                self.createRocketsView(rockets)
            case .failure(let error):
                self.displayError(error, title: "Проверьте соединение")
            }
        }

        view.backgroundColor = .secondarySystemFill
    }

    func createRocketsView(_ rockets: [Rocket]) {
        DispatchQueue.main.async {
            self.rocketList = rockets

            for rocket in self.rocketList {
                let rocketStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let rocketViewController = rocketStoryboard.instantiateViewController(identifier: "Rocket") { coder in
                    RocketViewController(coder: coder, rocket: rocket)
                }
                self.orderedViewControllers.append(rocketViewController)
            }

            if let firstViewController = self.orderedViewControllers.first {
                self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            }
        }
    }

    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
    }

}

// MARK: - UIPageViewControllerDataSource

extension RocketsPageViewController: UIPageViewControllerDataSource {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
                return nil
            }

            let previousIndex = viewControllerIndex - 1

            guard previousIndex >= 0 else { return nil }
            guard orderedViewControllers.count > previousIndex else { return nil }

        return orderedViewControllers[previousIndex]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
                return nil
            }

            let nextIndex = viewControllerIndex + 1
            let orderedViewControllerCount = orderedViewControllers.count

            guard orderedViewControllerCount != nextIndex else { return nil }
            guard orderedViewControllerCount > nextIndex else { return nil }

        return orderedViewControllers[nextIndex]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
              let firstViewControllerIndex = orderedViewControllers.firstIndex(of: firstViewController) else {
            return 0
        }

        return firstViewControllerIndex
    }

    // MARK: Navigation

    @IBAction func unwindSegue(sender: UIStoryboardSegue) {}
}
