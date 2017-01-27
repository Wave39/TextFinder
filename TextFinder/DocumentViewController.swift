//
//  DocumentViewController.swift
//  TextFinder
//
//  Created by Brian Prescott on 11/19/16.
//  Copyright © 2016 Wave 39 LLC. All rights reserved.
//

import Cocoa

class DocumentViewController: NSViewController {

    var theURL: URL
    @IBOutlet var theSearchField: NSSearchField?
    @IBOutlet var theTextView: NSTextView?
    var fileContents: String?
    var tabIndex: Int?
    
    init(url: URL) {
        self.theURL = url
        super.init(nibName: nil, bundle: nil)!
        let v: KeypressView = self.view as! KeypressView
        v.delegate = self
        tabIndex = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        print ("The path is " + theURL.absoluteString)
        fileContents = ""
        do {
            fileContents = try String(contentsOf: theURL)
            fileContents = fileContents?.replacingOccurrences(of: "\n", with: "")
        } catch {
            print("Failed reading from URL: \(theURL), Error: " + error.localizedDescription)
        }
        theTextView?.textStorage?.append(NSAttributedString(string: fileContents!))
        //theTextView?.font = NSFont(name: "Lucida Sans", size: 16.0)
        theTextView?.font = NSFont.systemFont(ofSize: 16.0)
        theTextView?.isEditable = false
    }
    
}

extension String {
    func indicesOf(string: String, maxMatches: Int) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex
        
        while searchStartIndex < self.endIndex,
            let range = self.range(of: string, options:NSString.CompareOptions.caseInsensitive, range: searchStartIndex..<self.endIndex),
            !range.isEmpty,
            indices.count < maxMatches
        {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        
        return indices
    }
}

extension DocumentViewController: KeypressViewDelegate {
    func didPressKey(theEvent: NSEvent) {
        print("Key pressed!!!!!!!!!!")
        
        var s = theSearchField?.stringValue
        if theEvent.keyCode == 51 {
            // backspace
            tabIndex = 0
            if (s?.characters.count)! < 2 {
                s = ""
            } else {
                let startIndex = s?.index((s?.startIndex)!, offsetBy: 0)
                let endIndex = s?.index((s?.endIndex)!, offsetBy: -2)
                s = s?[startIndex!...endIndex!]
            }
        } else if theEvent.keyCode == 53 {
            // escape
            tabIndex = 0
            s = ""
        } else if theEvent.keyCode == 48 {
            // tab
            tabIndex = tabIndex! + 1
        } else {
            tabIndex = 0
            s = s! + theEvent.characters!
        }
        
        theSearchField?.stringValue = s!
        var resetTextView = true
        if s!.characters.count > 0 {
            let indices = fileContents?.indicesOf(string: s!, maxMatches: 10)
            print ("Indices: \(indices)")
            if (indices?.count)! > 0 {
                if tabIndex! >= (indices?.count)! {
                    tabIndex = 0
                }
                
                let range = NSRange(location: (indices?[tabIndex!])!, length: s!.characters.count)
                theTextView?.scrollRangeToVisible(range)
                theTextView?.setSelectedRange(range)
                resetTextView = false
            }
        }
        
        if resetTextView {
            let range = NSRange(location: 0, length: 0)
            theTextView?.scrollRangeToVisible(range)
            theTextView?.setSelectedRange(range)
        }
    }
}
