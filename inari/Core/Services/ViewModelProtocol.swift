//
//  ViewModelProtocol.swift
//  inari
//
//  Created by Claude on 31.01.26.
//

import Foundation
import Observation

/// Base protocol for all ViewModels
@MainActor
protocol ViewModel: AnyObject, Observable {
    associatedtype State
    var state: State { get set }
}
