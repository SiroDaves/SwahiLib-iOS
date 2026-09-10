//
//  DiContainer.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/04/2025.
//

import Swinject

final class DiContainer {
    static let shared = DiContainer()
    let container: Container

    private init() {
        container = Container()
        DependencyMap.registerDependencies(in: container)
        validateDependencies()
    }

    private func validateDependencies() {
        let dependencies: [() -> Any?] = [
            { self.container.resolve(PrefsRepo.self) },
            { self.container.resolve(CoreDataManager.self) },
            { self.container.resolve(NotificationServiceProtocol.self) },
            { self.container.resolve(KamusiApiServiceProtocol.self) },
            { self.container.resolve(ContentSyncManagerProtocol.self) },
            { self.container.resolve(AnalyticsServiceProtocol.self) },
            { self.container.resolve(LoggerProtocol.self) },
            { self.container.resolve(HistoryDataManager.self) },
            { self.container.resolve(IdiomDataManager.self) },
            { self.container.resolve(ProverbDataManager.self) },
            { self.container.resolve(SayingDataManager.self) },
            { self.container.resolve(SearchDataManager.self) },
            { self.container.resolve(WordDataManager.self) },
            { self.container.resolve(IdiomRepoProtocol.self) },
            { self.container.resolve(ProverbRepoProtocol.self) },
            { self.container.resolve(SayingRepoProtocol.self) },
            { self.container.resolve(WordRepoProtocol.self) },
            { self.container.resolve(SubsRepoProtocol.self) },
            { self.container.resolve(InitViewModel.self) },
            { self.container.resolve(HomeViewModel.self) },
            { self.container.resolve(IdiomViewModel.self) },
            { self.container.resolve(ProverbViewModel.self) },
            { self.container.resolve(SayingViewModel.self) },
            { self.container.resolve(WordViewModel.self) },
            { self.container.resolve(SplashViewModel.self) },
            { self.container.resolve(SearchViewModel.self) },
            { self.container.resolve(NavigationCoordinator.self) },
        ]

        for resolve in dependencies {
            guard resolve() != nil else {
                fatalError("One or more dependencies are not registered in the container.")
            }
        }
        print("All dependencies are successfully registered.")
    }
}

extension DiContainer {
    func resolve<T>(_ type: T.Type) -> T {
        guard let dependency = container.resolve(type) else {
            fatalError("Failed to resolve dependency: \(type)")
        }
        return dependency
    }

    func resolve<T, Arg>(_ type: T.Type, argument: Arg) -> T {
        guard let dependency = container.resolve(type, argument: argument) else {
            fatalError("Failed to resolve dependency: \(type) with argument: \(argument)")
        }
        return dependency
    }
}
