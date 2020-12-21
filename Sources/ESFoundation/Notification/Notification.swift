//
//  Notification.swift
//  
//
//  Created by 罗树新 on 2020/12/20.
//

import Foundation

public extension NotificationCenter {
    
    func addObserver(_ observer: Any, name: String, object: Any? = nil, block: @escaping (_ notification: Notification) -> Void) {
        
        if manager == nil { manager = ESNotificationCenterManager(self) }
        manager?.addObserver(observer, name: name, object: object, block: block)
    }
}

fileprivate extension NotificationCenter {
    struct AssociatedKey {
        static var manager: String = "com.es.foundation.AssociatedKey.NotificationCenter.manager"
    }
    
    var manager: ESNotificationCenterManager? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.manager) as? ESNotificationCenterManager
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.manager, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

open class ESNotificationCenterManager: NSObject {
    
    fileprivate var notificationCenter: NotificationCenter
    
    fileprivate var targetMaps = [NotificationTarget]()
    
    init(_ center: NotificationCenter) {
        self.notificationCenter = center
        super.init()
        center.manager = self
    }
    
    func addObserver(_ observer: Any, name: String, object: Any? = nil, block: @escaping (_ notification: Notification) -> Void) {
        let name = Notification.Name.init(name)
        let target: NotificationTarget = NotificationTarget(center: self, observer: observer, name: name, object: object, block: block)
        
        notificationCenter.addObserver(target, selector: #selector(NotificationTarget.response(notification:)), name: name, object: object)
    }

    deinit {
        targetMaps.forEach { notificationCenter.removeObserver($0) }
        targetMaps.removeAll()
        self.notificationCenter.manager = nil
    }
}

fileprivate extension ESNotificationCenterManager {
    func remove(_ target: NotificationTarget) {
        cleanTargets()
        notificationCenter.removeObserver(target)
        targetMaps.removeAll { $0 == target }
    }
    
    func addTarget(_ target: NotificationTarget) {
        cleanTargets()
        if targetMaps.contains(target) == false {
            targetMaps.append(target)
        }
    }
    
    func cleanTargets() {
        targetMaps.removeAll { $0.observer == nil }
    }
    
    func addRunloopObserver() {
        let flags: CFRunLoopActivity = [.beforeWaiting, .exit]
        let observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, flags.rawValue, true, 0) { [weak self] (observer, activity) in
            self?.cleanTargets()
        }
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, .commonModes)
    }
}


fileprivate class NotificationTarget: NSObject {
    var center: ESNotificationCenterManager?
    var observer: Any?
    var block: (_ notification: Notification) -> Void
    var name: Notification.Name
    var object: Any?
    
    init(center: ESNotificationCenterManager, observer: Any, name: Notification.Name, object: Any? = nil, block: @escaping (_ notification: Notification) -> Void) {
        self.center = center
        self.observer = observer
        self.block = block
        self.name = name
        self.object = object
    }
    
    @objc func response(notification: Notification) {
        guard let _ = observer else {
            center?.remove(self)
            return
        }
        block(notification)
    }
}
