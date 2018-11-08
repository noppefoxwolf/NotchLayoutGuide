//
//  ViewController.swift
//  NotchLayoutGuide
//
//  Created by noppefoxwolf on 11/09/2018.
//  Copyright (c) 2018 noppefoxwolf. All rights reserved.
//

import UIKit
import NotchLayoutGuide

class ViewController: UIViewController {
  private let button = UIButton(frame: .zero)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    button.backgroundColor = UIColor.red.withAlphaComponent(0.5)
    button.setTitle("Notch!!", for: .normal)
    
    guard let window = UIApplication.shared.keyWindow else { return }
    
    button.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(button)
    NSLayoutConstraint.activate([
      button.topAnchor.constraint(equalTo: window.notchLayoutGuide.bottomAnchor),
      button.centerXAnchor.constraint(equalTo: window.notchLayoutGuide.centerXAnchor),
      button.widthAnchor.constraint(equalToConstant: 100),
      button.heightAnchor.constraint(equalToConstant: 44),
    ])
  }
}

