//
//  Timer+TangoPlayer.swift
//  TTPlayerDemo
//
//  Created by Nagaraju Surisetty on 27/11/17.
//  Copyright © 2017 Nagaraju Surisetty. All rights reserved.
//

import Foundation

extension Timer {
    class func tangoPlayer_scheduledTimerWithTimeInterval(_ timeInterval: TimeInterval, block: ()->(), repeats: Bool) -> Timer {
        return self.scheduledTimer(timeInterval: timeInterval, target:
            self, selector: #selector(self.tangoPlayer_blcokInvoke(_:)), userInfo: block, repeats: repeats)
    }
    
    @objc class func tangoPlayer_blcokInvoke(_ timer: Timer) {
        let block: ()->() = timer.userInfo as! ()->()
        block()
    }
    
}
