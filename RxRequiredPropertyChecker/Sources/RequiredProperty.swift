//
//  RequiredProperty.swift
//  RxRequiredPropertyChecker
//
//  Created by xattacker on 2021/8/21.
//  Copyright © 2021 xattacker. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


public protocol RequiredProperty: AnyObject
{
    var propertyName: String { get }
    var isFilled: Bool { get }
    var isFilledBinding: Driver<Bool> { get }
    var isRequired: Bool { get }
}

extension RequiredProperty
{
    public var propertyName: String
    {
        return ""
    }
    
    public var isRequired: Bool
    {
        return true
    }
}


extension Array where Element == AnyObject
{
    func getRequiredProperties() -> [RequiredProperty]
    {
        return self.filter { $0 is RequiredProperty }.map { $0 as! RequiredProperty }
    }
}
