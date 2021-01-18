//
//  MDParser.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/16.
//

import Cocoa

class MDParser: NSObject {
    
    static let headerRegex = "^#{1,3}"
    static let orderRegex = "^[0-9]+."
    static let bulletRegex = "^-"
    
    static func getTitle(content: String) -> String {
        return RE.replace(validateString: content, withContent: "", inRegex: "^#{1,3} +")
    }
    
    static func renderAll(storage: NSTextStorage) -> NSAttributedString {
        let result = NSMutableAttributedString(string: storage.string)
        let paragraphs = storage.paragraphs
        var start = 0
        for s in paragraphs {
            guard let range = Range(NSRange(location: 0, length: s.string.count), in: s.string)
            else {continue}
            let attr = self.render(content: s.string, with: range)
            let paraRange = NSRange(location: start, length: s.string.count)
            start += s.string.count
            result.setAttributes(attr, range: paraRange)
        }
        return result
    }
    
    static func render(content: String, with range: Range<String.Index>) -> [NSAttributedString.Key: Any]{
        let para = String(content[range])
        // header
        var attr:[NSAttributedString.Key: Any] = self.normalAttribute()
        let headerMatch = RE.regularExpression(validateString: para, inRegex: headerRegex)
        let level = headerMatch.isEmpty ? 0 : headerMatch[0].count
        if level > 0 {
            attr = self.headerAttribute(level: level)
        }
        else {
            let orderedMatched = RE.regularExpression(validateString: para, inRegex: self.orderRegex)
            let bulletMatched = RE.regularExpression(validateString: para, inRegex: self.bulletRegex)
            if bulletMatched.count > 0 {
                attr = self.listAttribute()
            }
            else if orderedMatched.count > 0{
                attr = self.listAttribute()
            }
        }
        return attr
    }
    
    private static func headerAttribute(level: Int) -> [NSAttributedString.Key: Any] {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.paragraphSpacingBefore = PARAGRAGH_LEVELS[level]
        paraStyle.paragraphSpacing = PARAGRAGH_LEVELS[level]
        let font = NSFont.boldSystemFont(ofSize: FONT_LEVELS[level])
        return [
            .font: font,
            .paragraphStyle: paraStyle,
            .foregroundColor: NSColor.textColor
        ]
    }
    
    private static func listAttribute() -> [NSAttributedString.Key: Any] {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.firstLineHeadIndent = 5
        paraStyle.paragraphSpacingBefore = 3
        paraStyle.paragraphSpacing = 3
        return [
            .font: NSFont.systemFont(ofSize: FONT_LEVELS[0]),
            .paragraphStyle: paraStyle,
            .foregroundColor: NSColor.textColor
        ]
    }
    
    private static func normalAttribute() -> [NSAttributedString.Key: Any] {
        return [
            .font: NSFont.systemFont(ofSize: FONT_LEVELS[0]),
            .foregroundColor: NSColor.textColor
        ]
    }
    
}
