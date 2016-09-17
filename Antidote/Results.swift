//
//  Results.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 10/07/16.
//  Copyright © 2016 dvor. All rights reserved.
//

import Foundation

/// Swift wrapper for RLMResults
class Results<T: OCTObject> {
    fileprivate let results: RLMResults<RLMObject>

    var count: Int {
        get {
            return Int(results.count)
        }
    }

    var firstObject: T {
        get {
            return results.firstObject() as! T
        }
    }

    var lastObject: T {
        get {
            return results.lastObject() as! T
        }
    }

    init(results: RLMResults<RLMObject>) {
        let name = NSStringFromClass(T.self)
        assert(name == results.objectClassName, "Specified wrong generic class")

        self.results = results
    }

    func indexOfObject(_ object: T) -> Int {
        return Int(results.index(of: object))
    }

    func sortedResultsUsingProperty(_ property: String, ascending: Bool) -> Results<T> {
        let sortedResults = results.sortedResults(usingProperty: property, ascending: ascending)
        return Results<T>(results: sortedResults)
    }

    func sortedResultsUsingDescriptors(_ properties: Array<RLMSortDescriptor>) -> Results<T> {
        let sortedResults = results.sortedResults(using: properties)
        return Results<T>(results: sortedResults)
    }

    func addNotificationBlock(_ block: @escaping (ResultsChange<T>) -> Void) -> RLMNotificationToken {
        return results.addNotificationBlock { rlmResults, changes, error in
            if let error = error {
                block(ResultsChange.error(error as NSError))
                return
            }

            let results: Results<T>? = (rlmResults != nil) ? Results<T>(results: rlmResults!) : nil

            if let changes = changes {
                block(ResultsChange.update(results,
                                           deletions: changes.deletions as [Int],
                                           insertions: changes.insertions as [Int],
                                           modifications: changes.modifications as [Int]))
                return
            }

            block(ResultsChange.initial(results))
        }
    }

    subscript(index: Int) -> T {
        return results[UInt(index)] as! T
    }
}
