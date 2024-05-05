//
//  Validator.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/05.
//
// 参考 
// https://qiita.com/tyatya_maruko/items/1fe8996660e85aae7c0d
// https://dev.to/dongri/-493c

import Foundation

class Validator {
    private func validate(str: String, pattern: String) -> [NSTextCheckingResult] {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
        return regex.matches(in: str, range: NSRange(location: 0, length: str.count))
    }
    
    func isEmail(_ email: String) -> Bool {
        // 前後のスペースと改行を削除
        let target = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let pattern = "^[\\w\\.\\-_]+@[\\w\\.\\-_]+\\.[a-zA-Z]+$"
        let matches = validate(str: target, pattern: pattern)
        return matches.count > 0
    }
    
    func isPassword(_ password: String) -> Bool {
        // 前後のスペースと改行を削除
        let target = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 大文字小文字英数字組み合わせ、特殊文字禁止、長さは8-10
        let pattern = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,10}$"
        let matches = validate(str: target, pattern: pattern)
        return matches.count > 0
    }
}
