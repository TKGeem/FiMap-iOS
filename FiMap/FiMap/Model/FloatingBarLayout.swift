//
//  FloatingBarLayout.swift
//  FiMap
//
//  Created by AmamiYou on 2018/10/22.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import UIKit

class FloatingBarLayout: FloatingPanelLayout {

    public var supportedPositions: [FloatingPanelPosition] {
        return [.full, .half, .tip]
    }

    public var initialPosition: FloatingPanelPosition {
        return .half
    }

    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 10
        case .half: return 200
        case .tip: return 0 //130 // Visible + ToolView
        }
    }

    public func prepareLayout(surfaceView: UIView, in view: UIView) -> [NSLayoutConstraint] {
        return [
            surfaceView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0.0),
            surfaceView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0.0),
        ]
    }

    var backdropAlpha: CGFloat = 0.0
}

class FloatingBarBehavior: FloatingPanelBehavior {
    var velocityThreshold: CGFloat {
        return 15
    }

    func interactionAnimator(to targetPosition: FloatingPanelPosition, with velocity: CGVector) -> UIViewPropertyAnimator {
        let damping = self.damping(with: velocity)
        let springTiming = UISpringTimingParameters(dampingRatio: damping,
                                                    initialVelocity: velocity)
        let duration = getDuration(with: velocity)
        return UIViewPropertyAnimator(duration: duration, timingParameters: springTiming)
    }

    private func getDuration(with velocity: CGVector) -> TimeInterval {
        let dy = abs(velocity.dy)
        switch dy {
        case ..<1.0:
            return 0.5
        case 1.0..<velocityThreshold:
            let a = ((dy - 1.0) / (velocityThreshold - 1.0))
            return TimeInterval(0.5 - (0.25 * a))
        case velocityThreshold...:
            return 0.25
        default:
            fatalError()
        }
    }

    private func damping(with velocity: CGVector) -> CGFloat {
        switch velocity.dy {
        case ...(-velocityThreshold):
            return 0.7
        case velocityThreshold...:
            return 0.7
        default:
            return 1.0
        }
    }
}
