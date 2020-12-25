//
//  File.swift
//  
//
//  Created by 罗树新 on 2020/12/25.
//

import Foundation

open class Timer {
    private var timer: DispatchSourceTimer?
    private var timeInterval: TimeInterval
    private var queue: DispatchQueue
    private var repeats: Bool
    private var action: (() -> ())?
    private var schedule: Bool = false
    
    init(_ timeInterval: TimeInterval, repeats: Bool = false, queue: DispatchQueue? = nil, action: (() -> ())? = nil) {
        self.timeInterval = timeInterval
        if let queue = queue {
            self.queue = queue
        } else {
            self.queue = DispatchQueue.global(qos: .default)
        }
        self.repeats = repeats
        self.action = action
    }
    
    @discardableResult
    func start(_ action: (() -> ())? = nil) -> Bool {
        if self.timer != nil { stop() }
        if let action = action { self.action = action }
        
        guard let _ = self.action else { return false }
        
        self.timer = DispatchSource.makeTimerSource(flags: [], queue: self.queue)
        self.timer?.schedule(deadline: .now(), repeating: timeInterval)
        self.timer?.setEventHandler { [unowned self] in
            self.action?()
            if repeats == false { self.stop() }
        }
        self.timer?.resume()
        return true
    }
    
    @discardableResult
    func stop() -> Bool {
        if let timer = self.timer {
            timer.cancel()
            self.timer = nil
            self.schedule = false
            return true
        }
        return true
    }
    
}
