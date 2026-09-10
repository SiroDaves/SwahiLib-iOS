//
//  DependencyMap.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/04/2025.
//

import Swinject

struct DependencyMap {
    static func registerDependencies(in container: Container) {
        container.register(PrefsRepo.self) { _ in
            PrefsRepo()
        }.inObjectScope(.container)

        container.register(CoreDataManager.self) { _ in
            CoreDataManager.shared
        }.inObjectScope(.container)
        
        container.register(NotificationServiceProtocol.self) { resolver in
            NotificationService(
                wordDataManager: resolver.resolve(WordDataManager.self)!
            )
        }.inObjectScope(.container)
        
        container.register(KamusiApiServiceProtocol.self) { _ in
            KamusiApiService()
        }.inObjectScope(.container)

        container.register(AnalyticsServiceProtocol.self) { _ in
            AnalyticsService()
        }.inObjectScope(.container)

        container.register(LoggerProtocol.self) { _ in
            Logger()
        }.inObjectScope(.container)
        
        container.register(HistoryDataManager.self) { resolver in
            HistoryDataManager(
                coreDataManager: resolver.resolve(CoreDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(IdiomDataManager.self) { resolver in
            IdiomDataManager(
                coreDataManager: resolver.resolve(CoreDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(ProverbDataManager.self) { resolver in
            ProverbDataManager(
                coreDataManager: resolver.resolve(CoreDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(SayingDataManager.self) { resolver in
            SayingDataManager(
                coreDataManager: resolver.resolve(CoreDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(SearchDataManager.self) { resolver in
            SearchDataManager(
                coreDataManager: resolver.resolve(CoreDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(WordDataManager.self) { resolver in
            WordDataManager(
                coreDataManager: resolver.resolve(CoreDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(IdiomRepoProtocol.self) { resolver in
            IdiomRepo(
                api: resolver.resolve(KamusiApiServiceProtocol.self)!,
                idiomData: resolver.resolve(IdiomDataManager.self)!
            )
        }.inObjectScope(.container)
        
        container.register(ProverbRepoProtocol.self) { resolver in
            ProverbRepo(
                api: resolver.resolve(KamusiApiServiceProtocol.self)!,
                proverbData: resolver.resolve(ProverbDataManager.self)!
            )
        }.inObjectScope(.container)
        
        container.register(SayingRepoProtocol.self) { resolver in
            SayingRepo(
                api: resolver.resolve(KamusiApiServiceProtocol.self)!,
                sayingData: resolver.resolve(SayingDataManager.self)!
            )
        }.inObjectScope(.container)
        
        container.register(WordRepoProtocol.self) { resolver in
            WordRepo(
                api: resolver.resolve(KamusiApiServiceProtocol.self)!,
                wordData: resolver.resolve(WordDataManager.self)!
            )
        }.inObjectScope(.container)
        
        container.register(ContentSyncManagerProtocol.self) { resolver in
            ContentSyncManager(
                api: resolver.resolve(KamusiApiServiceProtocol.self)!,
                prefsRepo: resolver.resolve(PrefsRepo.self)!,
                idiomRepo: resolver.resolve(IdiomRepoProtocol.self)!,
                proverbRepo: resolver.resolve(ProverbRepoProtocol.self)!,
                sayingRepo: resolver.resolve(SayingRepoProtocol.self)!,
                wordRepo: resolver.resolve(WordRepoProtocol.self)!
            )
        }.inObjectScope(.container)
        
        container.register(SubsRepoProtocol.self) { resolver in
            SubsRepo()
        }.inObjectScope(.container)
        
        container.register(SplashViewModel.self) { resolver in
            SplashViewModel(
                prefsRepo: resolver.resolve(PrefsRepo.self)!,
                subsRepo: resolver.resolve(SubsRepoProtocol.self)!
            )
        }.inObjectScope(.container)
        
        container.register(InitViewModel.self) { resolver in
            InitViewModel(
                prefsRepo: resolver.resolve(PrefsRepo.self)!,
                syncManager: resolver.resolve(ContentSyncManagerProtocol.self)!
            )
        }.inObjectScope(.container)
        
        container.register(HomeViewModel.self) { resolver in
            HomeViewModel(
                prefsRepo: resolver.resolve(PrefsRepo.self)!,
                idiomRepo: resolver.resolve(IdiomRepoProtocol.self)!,
                proverbRepo: resolver.resolve(ProverbRepoProtocol.self)!,
                sayingRepo: resolver.resolve(SayingRepoProtocol.self)!,
                wordRepo: resolver.resolve(WordRepoProtocol.self)!,
                subsRepo: resolver.resolve(SubsRepoProtocol.self)!,
                notifyService: resolver.resolve(NotificationServiceProtocol.self)!,
                syncManager: resolver.resolve(ContentSyncManagerProtocol.self)!
            )
        }.inObjectScope(.container)
        
        container.register(SearchViewModel.self) { resolver in
            SearchViewModel(
                prefsRepo: resolver.resolve(PrefsRepo.self)!,
                idiomRepo: resolver.resolve(IdiomRepoProtocol.self)!,
                proverbRepo: resolver.resolve(ProverbRepoProtocol.self)!,
                sayingRepo: resolver.resolve(SayingRepoProtocol.self)!,
                wordRepo: resolver.resolve(WordRepoProtocol.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(IdiomViewModel.self) { resolver in
            IdiomViewModel(
                prefsRepo: resolver.resolve(PrefsRepo.self)!,
                idiomRepo: resolver.resolve(IdiomRepoProtocol.self)!,
                subsRepo: resolver.resolve(SubsRepoProtocol.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(ProverbViewModel.self) { resolver in
            ProverbViewModel(
                prefsRepo: resolver.resolve(PrefsRepo.self)!,
                proverbRepo: resolver.resolve(ProverbRepoProtocol.self)!,
                subsRepo: resolver.resolve(SubsRepoProtocol.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(SayingViewModel.self) { resolver in
            SayingViewModel(
                prefsRepo: resolver.resolve(PrefsRepo.self)!,
                sayingRepo: resolver.resolve(SayingRepoProtocol.self)!,
                subsRepo: resolver.resolve(SubsRepoProtocol.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(WordViewModel.self) { resolver in
            WordViewModel(
                prefsRepo: resolver.resolve(PrefsRepo.self)!,
                proverbRepo: resolver.resolve(ProverbRepoProtocol.self)!,
                wordRepo: resolver.resolve(WordRepoProtocol.self)!,
                subsRepo: resolver.resolve(SubsRepoProtocol.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(NavigationCoordinator.self) { _ in
            NavigationCoordinator()
        }.inObjectScope(.container)

    }
}
