//
//  TangoPlayerError.swift
//  TTPlayerDemo
//
//  Created by Nagaraju Surisetty on 27/11/17.
//  Copyright © 2017 Nagaraju Surisetty. All rights reserved.
//

import Foundation
import AVFoundation

public struct TangoPlayerError: CustomStringConvertible {
    var error : Error?
    var playerItemErrorLogEvent : [AVPlayerItemErrorLogEvent]?
    var extendedLogData : Data?
    var extendedLogDataStringEncoding : UInt?
    
    public var description: String {
        return "VGPlayer Log -------------------------- \n error: \(String(describing: error))\n playerItemErrorLogEvent: \(String(describing: playerItemErrorLogEvent))\n extendedLogData: \(String(describing: extendedLogData))\n extendedLogDataStringEncoding \(String(describing: extendedLogDataStringEncoding))\n --------------------------"
    }
}
