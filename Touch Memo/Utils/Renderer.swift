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
        var lastOrder: Int? = nil
        for (index, subLine) in lines.enumerated() {
            var line = String(subLine) + (index == lines.count-1 ? "" : "\n")
            let headerMatch = RE.regularExpression(validateString: line, inRegex: "^#{1,3}")
            let level = headerMatch.isEmpty ? 0 : headerMatch[0].count
            if level > 0 {
                // Render headers
                let paraStyle = NSMutableParagraphStyle()
                paraStyle.paragraphSpacingBefore = PARAGRAGH_LEVELS[level]
                paraStyle.paragraphSpacing = PARAGRAGH_LEVELS[level]
                let font = NSFont.boldSystemFont(ofSize: FONT_LEVELS[level])
                let aString = NSAttributedString(
                        string: line,
                        attributes: [
                            .font: font,
                            .paragraphStyle: paraStyle,
                            .foregroundColor: NSColor.textColor
                    ]
                )
                rendered.append(aString)
            }
            else {
                // Render list
                let orderedMatched = RE.regularExpression(validateString: line, inRegex: "^[0-9]+.")
                let bulletMatched = RE.regularExpression(validateString: line, inRegex: "^-")
                let paraStyle = NSMutableParagraphStyle()
                if orderedMatched.count > 0 || bulletMatched.count > 0 {
                    paraStyle.firstLineHeadIndent = 5
                    paraStyle.paragraphSpacingBefore = 3
                    paraStyle.paragraphSpacing = 3
                }
                if orderedMatched.count > 0 {
                    if lastOrder == nil {
                        lastOrder = 1
                    } else {
                        lastOrder = lastOrder! + 1
                    }
                    line = RE.replace(validateString: line, withContent: "\(lastOrder!).", inRegex: "^[0-9]+.")
                } else {
                    lastOrder = nil
                }
                let aString = NSAttributedString(
                    string: line,
                    attributes: [
                        .font: NSFont.systemFont(ofSize: FONT_LEVELS[level]),
                        .paragraphStyle: paraStyle,
                        .foregroundColor: NSColor.textColor
                    ]
                )
                rendered.append(aString)
            }
        }
        return rendered
    }
}
