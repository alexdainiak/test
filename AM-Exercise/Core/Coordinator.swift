//
//  Coordinator.swift
//  AM-Exercise
//
//  Created by Aleksandr Dainiak on 03.04.2022.
//  Copyright © 2022 Michael Mavris. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    var navigationController: UINavigationController { get }

    func start()
}
