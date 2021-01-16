//
//  Renderer.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/16.
//

import Cocoa

class Renderer: NSObject {
    static func getTitle(content: String) -> String {
        guard let index = content.firstIndex(of: "\n") else {
            let content = content.trimmingCharacters(in: .whitespaces)
            if content.count == 0 {
                return "No Title"
            } else {
                return self.clearTitle(title: Substring(content))
            }
        }
        return self.clearTitle(title: content[..<index])
    }
    
    static func clearTitle(title: Substring) -> String {
        var title = title
        while title.starts(with: "#") || title.starts(with: " ") {
            title = title.dropFirst()
        }
        return String(title)
    }
    
    static func render(content: String) -> NSMutableAttributedString {
        let lines = content.split(separator: "\n")
        let rendered = NSMutableAttributedString(string: "")
        for line in lines {
            // Render headers
            var level = 0
            for c in line {
                if c == "#" {
                    level += 1
                }
                else {
                    break
                }
            }
            if level > 3 { level = 3}
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
