//
//  AmbiguousViewRule.swift
//  IBLinterKit
//
//  Created by Yuta Saito on 2018/09/26.
//

import IBDecodable

extension Rules {

    public struct AmbiguousViewRule: Rule {

        public static var identifier: String = "ambiguous"

        public init(context: Context) {}

        public func validate(xib: XibFile) -> [Violation] {
            guard let views = xib.document.views else { return [] }
            return views.flatMap { validate(for: $0.view, file: xib) }
        }

        public func validate(storyboard: StoryboardFile) -> [Violation] {
            guard let scenes = storyboard.document.scenes else { return [] }
            let views = scenes.compactMap { $0.viewController?.viewController.rootView }
            return views.flatMap { validate(for: $0, file: storyboard) }
        }

        private func validate<T: InterfaceBuilderFile>(for view: ViewProtocol, file: T) -> [Violation] {
            let violation: [Violation] = {
                if view.isAmbiguous ?? false {
                    let message = "\(view.customClass ?? view.elementClass) (\(view.id)) has ambiguous constraints"
                    return [Violation(pathString: file.pathString, message: message, level: .error)]
                } else {
                    return []
                }
            }()
            return violation + (view.subviews?.flatMap { validate(for: $0.view, file: file) } ?? [])
        }
    }
}
