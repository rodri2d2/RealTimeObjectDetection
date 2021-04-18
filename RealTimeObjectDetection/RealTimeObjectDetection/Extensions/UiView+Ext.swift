//
//  UiView+Ext.swift
//  RealTimeObjectDetection
//
//  Created by Rodrigo  Candido on 18/4/21.
//

import UIKit

/*
 This extension implements custom functionalities to UIView Class
 */
extension UIView {
    
    /**
     PIN a view to its super - Use this function to pin a view when this ocupies the entire Screen space of its super
     - Parameter superView: Its main or super container view to be pinned in
     
     ## Example
     
     Being at some ViewController or a Class that has a implementation of UIView, send this view property as parameter
     ~~~
     class ViewController: UIViewController {
         override func viewDidLoad() {
         super.viewDidLoad()
            tableView.pin(to: self.view)
         }
     }
     ~~~
     
     - Author: Rodrigo Candido
     - Version: v1.0
     
     */
    func pin(to superView: UIView){
        
        if let _ = superview {
            translatesAutoresizingMaskIntoConstraints                                  = false
            topAnchor.constraint      (equalTo:      superview!.topAnchor  ).isActive  = true
            leadingAnchor.constraint  (equalTo:  superview!.leadingAnchor  ).isActive  = true
            trailingAnchor.constraint (equalTo: superview!.trailingAnchor  ).isActive  = true
            bottomAnchor.constraint   (equalTo:   superview!.bottomAnchor  ).isActive  = true
        }
    }
    
    /// Constraint a View by Top, Bottom, Leading and Trailing anchor
    /// - Parameters:
    ///   - superView: as type UIVIEW
    ///   - withTop: as type CGFloat
    ///   - botton: as type CGFloat and will be converto to Negative
    ///   - leading: as type CGFloat
    ///   - trailing:  as type CGFloat and will be converto to Negative
    func constraintFourPoints(on superView: UIView, withTop: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat){
        
        if let _ = superview {
            translatesAutoresizingMaskIntoConstraints                                  = false
            topAnchor.constraint      (equalTo:      superview!.topAnchor, constant: withTop  ).isActive  = true
            leadingAnchor.constraint  (equalTo:  superview!.leadingAnchor, constant: leading  ).isActive  = true
            trailingAnchor.constraint (equalTo: superview!.trailingAnchor, constant: -trailing  ).isActive  = true
            bottomAnchor.constraint   (equalTo:   superview!.bottomAnchor, constant: -bottom  ).isActive  = true
        }
        
    }
    
    
    /// Constraint a View by Top with safe are, normal Leading and Trailing anchor
    /// - Parameters:
    ///   - superView:  as type UIVIEW
    ///   - withTop: as type CGFloat
    ///   - leading: as type CGFloat
    ///   - trailing: as type CGFloat and will be converto to Negative
    func minimumSafetyConstraintTop(on superView: UIView, withTop: CGFloat, leading: CGFloat, trailing: CGFloat){
        if let _ = superview {
            translatesAutoresizingMaskIntoConstraints                                  = false
            topAnchor.constraint      (equalTo:      superview!.safeAreaLayoutGuide.topAnchor, constant: withTop  ).isActive  = true
            leadingAnchor.constraint  (equalTo:  superview!.leadingAnchor, constant: leading  ).isActive  = true
            trailingAnchor.constraint (equalTo: superview!.trailingAnchor, constant: -trailing  ).isActive  = true
        }
    }
    
    
    /// Constraint a View by Bottom with safe are, normal Leading and Trailing anchor
    /// - Parameters:
    ///   - superView:  as type UIVIEW
    ///   - withTop: as type CGFloat
    ///   - leading: as type CGFloat
    ///   - trailing: as type CGFloat and will be converto to Negative
    func minimumSafetyConstraintBottom(on superView: UIView, withBottom: CGFloat, leading: CGFloat, trailing: CGFloat){
        if let _ = superview {
            translatesAutoresizingMaskIntoConstraints                                  = false
            bottomAnchor.constraint   (equalTo:      superview!.safeAreaLayoutGuide.bottomAnchor, constant: -withBottom).isActive  = true
            leadingAnchor.constraint  (equalTo:  superview!.leadingAnchor, constant: leading  ).isActive  = true
            trailingAnchor.constraint (equalTo: superview!.trailingAnchor, constant: -trailing  ).isActive  = true
        }
    }
}

