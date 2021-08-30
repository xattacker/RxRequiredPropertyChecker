//
//  RxRequiredPropertyChecker.swift
//  RxRequiredPropertyChecker
//
//  Created by xattacker on 2021/8/20.
//  Copyright © 2021 xattacker. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


public final class RxRequiredPropertyChecker: ReactiveCompatible
{
    public var count: Int
    {
        return self.properties.count
    }
    
    public var isEmpty: Bool
    {
        return self.properties.isEmpty
    }
    
    public var isFilled: Bool
    {
        if !self.properties.isEmpty,
           let _ = self.properties.first(where: { $0.isRequired && !$0.isFilled })
        {
            return false
        }
        
        return true
    }
    
    public var nofilledNames: [String]
    {
        return self.properties.filter { !$0.isFilled }.map { $0.name }
    }
    
    private var properties = [RequiredProperty]()
    private var disposeBag = DisposeBag()
    fileprivate let isFilledSubject = BehaviorSubject(value: true)
    
    public init()
    {
    }
    
    public func add(_ properties: RequiredProperty...)
    {
        for p in properties
        {
            self.properties.append(p)
            
            p.isFilledBinding.drive(
                                onNext: {
                                    [weak self]
                                    (filled: Bool) in
                                    self?.isFilledSubject.onNext(self?.isFilled ?? false)
                                }).disposed(by: self.disposeBag)
        }
    }
    
    public func add(_ array: [RequiredProperty])
    {
        for p in array
        {
            self.add(p)
        }
    }
    
    public func remove(_ property: RequiredProperty) -> Bool
    {
        var result = false
        if let index = self.properties.firstIndex(where:{ $0 === property })
        {
            self.properties.remove(at: index)
            result = true
        }
        
        return result
    }
    
    public func clear()
    {
        self.properties.removeAll()
        self.isFilledSubject.onNext(self.isFilled)
        self.disposeBag = DisposeBag()
    }
}


extension Reactive where Base: RxRequiredPropertyChecker
{
    public var isFilled: Driver<Bool>
    {
        return self.base.isFilledSubject.asObservable()
                        // fixed for iOS 12: done button could not chnage the background right now on iOS 12
                        .delaySubscription(.milliseconds(100), scheduler: MainScheduler.instance)
                        .asDriver(onErrorJustReturn: false)
    }
}
