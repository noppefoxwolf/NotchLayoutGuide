//
//  NotchLayoutGuide.swift
//  NotchLayoutGuide
//
//  Created by Tomoya Hirano on 2018/11/09.
//

import UIKit

public extension UIWindow {
  private struct AssociatedKeys {
    static var notchLayoutGuide = "NotchLayoutGuide"
  }
  
  public var notchLayoutGuide: NotchLayoutGuide {
    get {
      if let obj = objc_getAssociatedObject(self, &AssociatedKeys.notchLayoutGuide) as? NotchLayoutGuide {
        return obj
      }
      let new = NotchLayoutGuide()
      addLayoutGuide(new)
      new.setup()
      objc_setAssociatedObject(self, &AssociatedKeys.notchLayoutGuide, new as Any, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      return new
    }
  }
}

public class NotchLayoutGuide: UILayoutGuide {
  internal func setup() {
    update()
    NotificationCenter.default.addObserver(self, selector: #selector(didRotate), name: .UIDeviceOrientationDidChange, object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc private func didRotate(_ sender: NotificationCenter) {
    update()
  }
  
  private func update() {
    guard let window = owningView else { return }
    constraint(of: .top)?.isActive = false
    constraint(of: .bottom)?.isActive = false
    constraint(of: .left)?.isActive = false
    constraint(of: .right)?.isActive = false
    constraint(of: .centerX)?.isActive = false
    constraint(of: .centerY)?.isActive = false
    constraint(of: .width)?.isActive = false
    constraint(of: .height)?.isActive = false
    
    switch UIDevice.current.orientation {
    case .portrait:
      NSLayoutConstraint.activate([
        topAnchor.constraint(equalTo: window.topAnchor),
        centerXAnchor.constraint(equalTo: window.centerXAnchor),
        widthAnchor.constraint(equalToConstant: 230),
        heightAnchor.constraint(equalToConstant: 30),
      ])
    case .portraitUpsideDown:
      NSLayoutConstraint.activate([
        bottomAnchor.constraint(equalTo: window.bottomAnchor),
        centerXAnchor.constraint(equalTo: window.centerXAnchor),
        widthAnchor.constraint(equalToConstant: 230),
        heightAnchor.constraint(equalToConstant: 30),
      ])
    case .landscapeLeft:
      NSLayoutConstraint.activate([
        leftAnchor.constraint(equalTo: window.leftAnchor),
        centerYAnchor.constraint(equalTo: window.centerYAnchor),
        widthAnchor.constraint(equalToConstant: 30),
        heightAnchor.constraint(equalToConstant: 230),
      ])
    case .landscapeRight:
      NSLayoutConstraint.activate([
        rightAnchor.constraint(equalTo: window.rightAnchor),
        centerYAnchor.constraint(equalTo: window.centerYAnchor),
        widthAnchor.constraint(equalToConstant: 30),
        heightAnchor.constraint(equalToConstant: 230),
      ])
    default: break
    }
  }
}


extension UILayoutGuide {
  internal var heightConstraint: NSLayoutConstraint? {
    return constraint(of: .height)
  }
  
  internal var widthConstraint: NSLayoutConstraint? {
    return constraint(of: .width)
  }
  
  internal var topConstraint: NSLayoutConstraint? {
    return constraint(of: .top)
  }
  
  internal var leftConstraint: NSLayoutConstraint? {
    return constraint(of: .left)
  }
  
  fileprivate func constraint(of attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
    guard let target = owningView else { return nil }
    for c in target.constraints {
      if let fi = c.firstItem as? UILayoutGuide, fi == self && c.firstAttribute == attribute {
        return c
      }
    }
    return nil
  }
}
