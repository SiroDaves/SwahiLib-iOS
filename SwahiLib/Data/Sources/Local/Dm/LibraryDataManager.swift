//
//  LibraryDataManager.swift
//  SwahiLib
//
//  Created by @sirodevs on 07/09/2026.
//
//  All 9 maktaba collections share one Core Data table (CDLibraryItem),
//  scoped by a `collection` column — the iOS equivalent of Android's 9
//  separate Room DAOs, collapsed since every collection already resolves
//  to the same LibraryDisplayItem shape for display.
//

import CoreData

class LibraryDataManager {
    private let coreDataManager: CoreDataManager
    lazy var bgContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = coreDataManager.viewContext
        return context
    }()

    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }

    private var context: NSManagedObjectContext {
        coreDataManager.viewContext
    }

    /// Deletes everything currently stored for `collectionKey` and inserts
    /// `items` in its place — mirrors Android's `dao.replaceAll(...)`.
    func replaceAll(_ items: [LibraryDisplayItem], forCollection collectionKey: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            bgContext.perform {
                do {
                    let deleteRequest: NSFetchRequest<CDLibraryItem> = CDLibraryItem.fetchRequest()
                    deleteRequest.predicate = NSPredicate(format: "collection == %@", collectionKey)
                    let existing = try self.bgContext.fetch(deleteRequest)
                    existing.forEach { self.bgContext.delete($0) }

                    for item in items {
                        let cd = CDLibraryItem(context: self.bgContext)
                        cd.collection = collectionKey
                        cd.rid = item.id
                        cd.groupName = item.groupName
                        cd.primaryText = item.primaryText
                        cd.secondaryText = item.secondaryText
                        cd.orderIndex = Int32(item.orderIndex)
                        cd.detailsJson = (try? JSONEncoder().encode(item.detailFields))
                            .flatMap { String(data: $0, encoding: .utf8) } ?? "[]"
                    }

                    try self.bgContext.save()

                    Task { @MainActor in
                        do {
                            try self.context.save()
                            print("✅ \(items.count) \(collectionKey) library items saved")
                            continuation.resume()
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func fetchAll(forCollection collectionKey: String) -> [LibraryDisplayItem] {
        let request: NSFetchRequest<CDLibraryItem> = CDLibraryItem.fetchRequest()
        request.predicate = NSPredicate(format: "collection == %@", collectionKey)
        request.sortDescriptors = [NSSortDescriptor(key: "orderIndex", ascending: true)]

        do {
            return try context.fetch(request).map { cd in
                let fields: [LibraryDetailField] = cd.detailsJson
                    .flatMap { $0.data(using: .utf8) }
                    .flatMap { try? JSONDecoder().decode([LibraryDetailField].self, from: $0) } ?? []

                return LibraryDisplayItem(
                    id: cd.rid ?? UUID().uuidString,
                    groupName: cd.groupName,
                    primaryText: cd.primaryText ?? "",
                    secondaryText: cd.secondaryText,
                    detailFields: fields,
                    orderIndex: Int(cd.orderIndex)
                )
            }
        } catch {
            print("❌ Failed to fetch library items for \(collectionKey): \(error)")
            return []
        }
    }

    func count(forCollection collectionKey: String) -> Int {
        let request: NSFetchRequest<CDLibraryItem> = CDLibraryItem.fetchRequest()
        request.predicate = NSPredicate(format: "collection == %@", collectionKey)
        return (try? context.count(for: request)) ?? 0
    }

    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDLibraryItem.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("🗑️ All library items deleted successfully")
        } catch {
            print("❌ Failed to delete library items: \(error)")
        }
    }
}
