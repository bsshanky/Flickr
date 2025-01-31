//
//  Extensions.swift
//  Flickr
//
//  Created by Shashank  on 1/30/25.
//

import Foundation

extension String {
    
    func toFormattedDate() -> String? {
        let isoFormatter = ISO8601DateFormatter()
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MM/dd/yyyy"
        outputFormatter.locale = Locale(identifier: "en_US")

        if let date = isoFormatter.date(from: self) {
            return outputFormatter.string(from: date)
        }
        return nil
    }

    func extractImageDimensions() -> String? {
        let pattern = #"width=\"(\d+)\" height=\"(\d+)\""# 
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        let range = NSRange(self.startIndex..<self.endIndex, in: self)
        
        if let match = regex.firstMatch(in: self, options: [], range: range),
           let widthRange = Range(match.range(at: 1), in: self),
           let heightRange = Range(match.range(at: 2), in: self) {
            
            let width = self[widthRange]
            let height = self[heightRange]
            
            return "\(width) x \(height)"
        }
        
        return nil
    }
    
    func extractCleanDescription() -> String? {
        let pattern = "<p>(.*?)</p>"
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators) else {
            return nil
        }

        let range = NSRange(self.startIndex..<self.endIndex, in: self)
        let matches = regex.matches(in: self, options: [], range: range)

        if let lastMatch = matches.last, let matchRange = Range(lastMatch.range(at: 1), in: self) {
            return String(self[matchRange]).trimmingCharacters(in: .whitespacesAndNewlines)
        }

        return nil
    }
}
