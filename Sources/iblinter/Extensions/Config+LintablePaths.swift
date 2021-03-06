//
//  Config+LintablePaths.swift
//  IBLinter
//
//  Created by Yuta Saito on 2018/10/16.
//

import IBLinterKit
import Foundation

extension Config {
    func lintablePaths(workDirectory: URL, fileExtension: String) -> [URL] {
        let paths = glob(pattern: "\(workDirectory.path)/**/*.\(fileExtension)")
        let excluded = self.excluded.flatMap { glob(pattern: workDirectory.appendingPathComponent("\($0)/**/*.\(fileExtension)").path) }.map { $0.absoluteString }
        let included = self.included.flatMap { glob(pattern: workDirectory.appendingPathComponent("\($0)/**/*.\(fileExtension)").path) }.map { $0.absoluteString }
        let lintablePaths = paths.filter {
            if excluded.contains($0.absoluteString) {
                return included.contains($0.absoluteString)
            }
            return true
        }
        return lintablePaths
    }
}
