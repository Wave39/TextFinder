//
//  KeypressView.swift
//  TextFinder
//
//  Created by Brian Prescott on 11/29/16.
//  Copyright © 2016 Wave 39 LLC. All rights reserved.
//

import Cocoa

protocol KeypressViewDelegate: class {
    func didPressKey(theEvent: NSEvent)
}

class KeypressView: NSView {

    weak var delegate: KeypressViewDelegate?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override var acceptsFirstResponder : Bool {
        return true
    }
    
    override func keyDown(with theEvent: NSEvent)
    {        
        Swift.print("key code = \(theEvent.keyCode)")
        Swift.print("key = " + (theEvent.charactersIgnoringModifiers ?? ""))
        Swift.print("character = " + (theEvent.characters ?? ""))
        Swift.print("modifier = " + theEvent.modifierFlags.rawValue.description)
        
        delegate?.didPressKey(theEvent: theEvent)
    }
}
