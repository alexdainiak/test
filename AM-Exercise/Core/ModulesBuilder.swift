//
//  ModulesBuilder.swift
//  AM-Exercise
//
//  Created by Aleksandr Dainiak on 03.04.2022.
//  Copyright © 2022 Michael Mavris. All rights reserved.
//

import UIKit
import Foundation

protocol ModulesBuilderProtocol {
    func createMainModule() -> ViewController
}

final class ModulesBuilder: ModulesBuilderProtocol {
    // MARK: - Public Properties

    let coordinator: MainCoordinator
    static let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)

    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Public Methods

    func createMainModule() -> ViewController {

        let viewModel = MainScreenViewModel(networkClient: NetworkClient(urlSession: ModulesBuilder.session))
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let view = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        view.viewModel = viewModel
        
        return view
    }
}
