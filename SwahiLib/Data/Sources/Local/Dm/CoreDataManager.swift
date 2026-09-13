//
//  CoreDataManager.swift
//  SwahiLib
//
//  Created by @sirodevs on 29/04/2025.
//  Updated to fix a launch-time crash: `loadPersistentStores` is
//  asynchronous, but nothing previously waited for it to actually finish
//  before other code started inserting/saving managed objects. On a fresh
//  install (exactly what App Review tests), ContentSyncManager's
//  concurrent sync tasks could start hammering Core Data's shared parent
//  context while the SQLite store was still in the middle of attaching,
//  causing an EXC_BAD_ACCESS in the store coordinator's internal hash
//  tables. `ensureLoaded()` gives every caller a single, awaitable,
//  idempotent point to wait on before touching Core Data at all.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    let persistentContainer: NSPersistentContainer = {
        NSPersistentContainer(name: "SwahiLib")
    }()

    /// Cached so `ensureLoaded()` only triggers `loadPersistentStores` once,
    /// no matter how many callers (or how concurrently) they call it.
    private var loadTask: Task<Void, Error>?

    /// Awaits the persistent store finishing loading. Safe to call from
    /// multiple places/concurrently — every caller shares the same
    /// underlying load. Any code that inserts, fetches, or saves via
    /// `viewContext` (or a child context of it) must await this first.
    @discardableResult
    func ensureLoaded() async throws -> Void {
        if let loadTask {
            return try await loadTask.value
        }

        let task = Task {
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                self.persistentContainer.loadPersistentStores { description, error in
                    if let error {
                        continuation.resume(throwing: error)
                        return
                    }

                    if let dbPath = description.url?.path {
                        print("📦 Core Data SQLite DB path:\n\(dbPath)")
                    } else {
                        print("⚠️ Could not determine Core Data DB path")
                    }

                    continuation.resume()
                }
            }
        }
        loadTask = task
        return try await task.value
    }

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
