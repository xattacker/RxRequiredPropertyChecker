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
    private class WeakPropertyBox
    {
        fileprivate weak var property: RequiredProperty!
        fileprivate var disposable: Disposable?
        
        init(property: RequiredProperty)
        {
            self.property = property
        }
    }

    public var count: Int
    {
        return self.properties.count
    }
    
    public subscript(index: Int) -> RequiredProperty?
    {
        return self.properties[index].property
    }
    
    public var isEmpty: Bool
    {
        return self.properties.isEmpty
    }
    
    public var isFilled: Bool
    {
        if !self.properties.isEmpty,
           let _ = self.properties.first(where: { $0.property != nil && $0.property.isRequired && !$0.property.isFilled })
        {
            return false
        }
        
        return true
    }
    
    public var nonFilledPropertyNames: [String]
    {
        return self.properties.filter { $0.property.isRequired && !$0.property.isFilled }.map { $0.property.propertyName }
    }
    
    private var properties = [WeakPropertyBox]()
    private var disposeBag = DisposeBag()
    fileprivate let isFilledSubject = BehaviorSubject(value: true)
    
    public init()
    {
    }
    
    public func add(_ properties: RequiredProperty...)
    {
        for p in properties
        {
            self.driveProperty(p)
        }
    }
    
    public func add(_ properties: [RequiredProperty])
    {
        for p in properties
        {
            self.driveProperty(p)
        }
    }
    
    public func remove(_ properties: RequiredProperty...) -> Bool
    {
        var result = false
        
        for p in properties
        {
            if self.disposeProperty(p)
            {
                result = true
            }
        }
        
        if result
        {
            self.isFilledSubject.onNext(self.isFilled)
        }
        
        return result
    }
    
    public func remove(_ properties: [RequiredProperty]) -> Bool
    {
        var result = false
        
        for p in properties
        {
            if self.disposeProperty(p)
            {
                result = true
            }
        }
        
        if result
        {
            self.isFilledSubject.onNext(self.isFilled)
        }
        
        return result
    }
    
    public func clear()
    {
        self.properties.removeAll()
        self.disposeBag = DisposeBag()
        self.isFilledSubject.onNext(self.isFilled)
    }
    
    public func fetch(_ fetch: (_ proerty: RequiredProperty) -> Void)
    {
        var deinited = [Int]()
        
        for (i, p) in self.properties.enumerated()
        {
            if let property = p.property
            {
                fetch(property)
            }
            else
            {
                deinited.append(i)
            }
        }
        
        if !deinited.isEmpty
        {
            deinited.reverse() // remove index from large to small
            deinited.forEach {
                [weak self]
                i in
                self?.properties.remove(at: i)
            }
        }
    }
}


extension RxRequiredPropertyChecker
{
    private func driveProperty(_ property: RequiredProperty)
    {
        let box = WeakPropertyBox(property: property)
        self.properties.append(box)
        
        let disposable = property.isFilledBinding.drive(
                            onNext: {
                                [weak self]
                                (filled: Bool) in
                                self?.isFilledSubject.onNext(self?.isFilled ?? false)
                            })
        disposable.disposed(by: self.disposeBag)
        
        box.disposable = disposable
    }
    
    private func disposeProperty(_ property: RequiredProperty) -> Bool
    {
        var result = false
        
        if let index = self.properties.firstIndex(where:{ $0.property === property })
        {
            let existed = self.properties[index]
            existed.disposable?.dispose()
            self.properties.remove(at: index)
            result = true
        }
        
        return result
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
