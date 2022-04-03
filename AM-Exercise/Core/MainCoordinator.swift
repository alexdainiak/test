//
//  MainCoordinator.swift
//  AM-Exercise
//
//  Created by Aleksandr Dainiak on 03.04.2022.
//  Copyright © 2022 Michael Mavris. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    // MARK: - Private Properties

    private var moduleBuilder: ModulesBuilderProtocol?

    // MARK: - Public Properties

    private(set) var childCoordinators: [Coordinator] = []

    private(set) var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        moduleBuilder = ModulesBuilder(coordinator: self)
    }

    // MARK: - Public Methods

    func start() {
        guard let mainVC = moduleBuilder?.createMainModule() else { return }
        navigationController.pushViewController(mainVC, animated: false)
    }
}

