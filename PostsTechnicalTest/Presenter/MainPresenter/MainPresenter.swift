//
//  Presenter.swift
//  PostsTechnicalTest
//
//  Created by Juan Harrington on 9/08/22.
//

import Foundation
import UIKit

protocol MainPresenter {
    var view: View? { get set }
    
    func handleViewDidLoad()
}


