//
//  MDParser.swift
//  Touch Memo
//
//  Created by 一折 on 2021/1/16.
//

import Cocoa

struct Rendered {
    let attributes: [[NSAttributedString.Key: Any]]
    let attributedRanges: [NSRange]
}

struct Replaced {
    let string: String
    let range: Range<String.Index>
}

class MDParser: NSObject {
    
    static let headerRegex = "^#{1,3}"
    static let orderRegex = "^[0-9]+\\."
    static let bulletRegex = "^-"
    static let orderListBlockRegex = "(?<=(^|\n))([0-9]+\\..*(\n)?)*(?<=(^|\n))([0-9]+\\..*)+"
    static let specielRegex = "(?<=(^|\n))(#{1,3}|[0-9]+\\.|-)"
    static let paraRegex = "(?<=(^|\n)).*[\n]?"
    
    static func getTitle(content: String) -> String {
        guard let title = RE.regularExpression(validateString: content, inRegex: "^#{1,3} +.*\n?").first else {return ""}
        return RE.replace(validateString: title, withContent: "", inRegex: "^#{1,3} +")
    }
    
    static func renderAll(content: String) -> NSAttributedString {
        let result = NSMutableAttributedString(string: content, attributes: self.normalAttribute())
        let para = RE.regularExpression(validateString: content, inRegex: self.paraRegex)
        var start = 0
        for s in para {
            guard let range = Range(NSRange(location: 0, length: s.utf16.count), in: s)
            else {continue}
            let rendered = self.render(content: s, with: range)
            for i in 0..<rendered.attributes.count {
                let renderedRange = rendered.attributedRanges[i]
                let range = NSRange(location: start+renderedRange.location, length: renderedRange.length)
                result.addAttributes(rendered.attributes[i], range: range)
            }
            start += s.utf16.count
        }
        return result
    }
        
    static func render(content: String, with range: Range<String.Index>) -> Rendered{
        let para = String(content[range])
        var attrs: [[NSAttributedString.Key: Any]] = []
        var attrRanges: [NSRange] = []
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
        attrs.append(attr)
        attrRanges.append(NSRange(range, in: content))
        
        // style
        for (_, styleRange) in RE.regularExpressionRange(validateString: content, inRegex: self.specielRegex){
            attrs.append([
                .foregroundColor: NSColor(deviceRed: 244.0/255, green: 211.0/255.0, blue: 3.0/255.0, alpha: 1.0)
            ])
            attrRanges.append(styleRange)
        }
        
        return Rendered(attributes: attrs, attributedRanges: attrRanges)
    }
    
    static func autoOrder(content: String) -> [Replaced] {
        var result:[Replaced] = []
        for (block, range) in RE.regularExpressionRange(validateString: content, inRegex: self.orderListBlockRegex) {
            let replaced = RE.replace(validateString: block, withContent: "", inRegex: "(?<=(^|\n))[0-9]+")
            var splited = replaced.split(separator: "\n")
            splited = splited.enumerated().map({(i, line) in "\(i+1)"+line})
            let s = splited.joined(separator: "\n")
            guard let subRange = Range(range, in: content) else {continue}
            result.append(Replaced(string: s, range: subRange))
        }
        return result
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
