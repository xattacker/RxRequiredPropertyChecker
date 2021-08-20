//
//  ViewController.swift
//  RxRequiredPropertyChecker
//
//  Created by tao on 2021/8/20.
//  Copyright © 2018年 xattacker. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class ViewController: UIViewController
{
    @IBOutlet private weak var textFiled: UITextField!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var switchView: UISwitch!
    @IBOutlet private weak var segmentCtrl: UISegmentedControl!
    
    @IBOutlet private weak var isFilledLabel: UILabel!
    
    private let propertyChecker = RxRequiredPropertyChecker()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
 
        self.propertyChecker.add(self.textFiled, self.textView, self.switchView, self.segmentCtrl)
        
        self.propertyChecker.isFilledBinding.map { $0 ? "isAllFilled" : "notAllFilled" }
                             .drive(self.isFilledLabel.rx.text)
                             .disposed(by: self.disposeBag)
        
        self.propertyChecker.isFilledBinding.map { $0 ? UIColor.blue : UIColor.red }
                             .drive(self.isFilledLabel.rx.textColor)
                             .disposed(by: self.disposeBag)
    }
}
