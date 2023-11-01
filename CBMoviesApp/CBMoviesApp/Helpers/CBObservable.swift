//
//  CBObservable.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 22/07/23.
//

import Foundation

protocol CCBindingProtocol {
    associatedtype ValueType
    associatedtype Listener
    
    var value: ValueType? { get set }
    
    /**
     It call back to the binding properties `closure` when `dynamic datas` are changed.
     
     - Parameters:
        - listener: Listener closure function with associated-type.
     - Note: `Optional function parameter is @escaping by default`
     */
    func bind(_ listener: ((ValueType?) -> Void)?)
    
    /**
     It call back to the binding properties `closure` suddenly and when `dynamic datas` are changed.
     
     - Parameters:
        - listener: Listener closure function with associated-type.
     - Note: `Optional function parameter is @escaping by default`
     */
    func bindAndFire(_ listener: ((ValueType?) -> Void)?)
}

class CCObservable<Value>: CCBindingProtocol {
    typealias ValueType = Value
    typealias Listener = (ValueType?) -> Void
    
    var listener: Listener?
    
    var value: Value? {
        didSet {
            listener?(value)
        }
    }
 
    // MARK: - Init methods
    
    init(_ value: Value? = nil) {
        self.value = value
    }
    
    // MARK: - Custom methods
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
}
