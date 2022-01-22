//
//  AsyncOperation.swift
//  
//
//  Created by Павел Лунев on 18.01.2022.
//

import Foundation

class AsyncOperation: Operation {
    override var isAsynchronous: Bool {
        return true
    }

    var isAsyncFinished: Bool = false
    var debug: Bool = false
    private var startTime: Double?

    override var isFinished: Bool {
        set {
            willChangeValue(forKey: "isFinished")
            isAsyncFinished = newValue
            didChangeValue(forKey: "isFinished")
        }

        get {
            return isAsyncFinished
        }
    }

    var isAsyncExecuting: Bool = false

    override var isExecuting: Bool {
        set {
            willChangeValue(forKey: "isExecuting")
            isAsyncExecuting = newValue
            didChangeValue(forKey: "isExecuting")
        }

        get {
            return isAsyncExecuting
        }
    }

    func execute() {}

    override func start() {
        isExecuting = true
        execute()
        if debug {
            startTime = CFAbsoluteTimeGetCurrent()
            let name = String(describing: type(of: self))

            print("AQW: Task \(name) start")
        }
    }

    func end() {
        isExecuting = false
        isFinished = true
        if debug, let startTime = startTime {
            let diff = CFAbsoluteTimeGetCurrent() - startTime
            let name = String(describing: type(of: self))

            print("AQW: Task \(name) end (\(diff) sec)")
        }
    }
}

protocol HasCompletionBlock {
    associatedtype DataType
    var completionDataBlock: (DataType) -> Void { get set }
    var loadErrorBlock: (String) -> Void { get set }
}
