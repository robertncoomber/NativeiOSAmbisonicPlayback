//
//  Events.swift
//  NativeiOSAmbisonicPlayback
//
//  Created by Robert Coomber on 11/11/21.
//

import Foundation

class Events{
    static public let updateRotationValue = Event<Float>()
    static public let updatePlayingStatus = Event<Bool>()
}

class Event<T> {
    typealias EventHandler = (T) -> ()
    private var eventHandlers = [EventHandler]()
    
    func addHandler( handler: @escaping EventHandler){
        eventHandlers.append(handler)
    }
    
    func raise(data: T) {
        for handler in eventHandlers {
            handler(data)
        }
    }
}
