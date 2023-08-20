//
//  UIView+Ext.swift
//  SearchMovieApp
//
//  Created by Alpay Calalli on 19.08.23.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
}
