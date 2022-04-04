//
//  UIKit+RequiredProperty.swift
//  RxRequiredPropertyChecker
//
//  Created by xattacker on 2021/8/21.
//  Copyright © 2021 xattacker. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


extension UITextField: RequiredProperty
{
    public var isFilled: Bool
    {
        return (self.text?.count ?? 0) > 0
    }
    
    public var isFilledBinding: Driver<Bool>
    {
        // KVO with text would not effect on key in event directly
        let kvo_observable = self.rx.observe(String.self, "text")
                             .compactMap({ $0?.count ?? 0 > 0 })
        
        let event_observable = self.rx.text.map { $0?.count ?? 0 > 0 }
        
        return Observable.of(kvo_observable, event_observable)
                  .merge()
                  .asDriver(onErrorJustReturn: false)
    }
}


extension UITextView: RequiredProperty
{
    public var isFilled: Bool
    {
        return (self.text?.count ?? 0) > 0
    }
    
    public var isFilledBinding: Driver<Bool>
    {
        return self.rx.text.map { $0?.count ?? 0 > 0 }.asDriver(onErrorJustReturn: false)
    }
}


extension UISwitch: RequiredProperty
{
    public var propertyName: String
    {
        if #available(iOS 14, *)
        {
            return self.title ?? ""
        }
        
        return ""
    }
    
    public var isFilled: Bool
    {
        return self.isOn
    }
    
    public var isFilledBinding: Driver<Bool>
    {
        return self.rx.isOn.asDriver()
    }
}


extension UISegmentedControl: RequiredProperty
{
    public var isFilled: Bool
    {
        return self.selectedSegmentIndex >= 0
    }
    
    public var isFilledBinding: Driver<Bool>
    {
        return self.rx.selectedSegmentIndex.map { $0 >= 0 }.asDriver(onErrorJustReturn: false)
    }
}
