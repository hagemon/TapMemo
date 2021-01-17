//
//  Renderer.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/16.
//

import Cocoa

class Renderer: NSObject {
    static func getTitle(content: String) -> String {
        return RE.replace(validateString: content, withContent: "", inRegex: "^#{1,3} +")
    }
    
    static func render(content: String) -> NSMutableAttributedString {
        let lines = content.split(separator: "\n", omittingEmptySubsequences: false)
        let rendered = NSMutableAttributedString(string: "")
        for line in lines {
            // Render headers
            let headerMatch = RE.RegularExpression(validateString: String(line), inRegex: "^#{1,3}")
            let level = headerMatch.isEmpty ? 0 : headerMatch[0].count
            let paraStyle = NSMutableParagraphStyle()
            paraStyle.lineHeightMultiple = PARAGRAGH_LEVELS[level]
            let font = level > 0 ? NSFont.boldSystemFont(ofSize: FONT_LEVELS[level]) : NSFont.systemFont(ofSize: FONT_LEVELS[level])
            let aString = NSAttributedString(
                string: String(line+"\n"),
                attributes: [
                    .font: font,
                    .paragraphStyle: paraStyle,
                    .foregroundColor: NSColor.textColor
                ])
            rendered.append(aString)
            if level == 0 {
                // Render list
            }
        }
        return rendered
    }
}
