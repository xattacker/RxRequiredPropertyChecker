# RxRequiredPropertyChecker
a RxSwift Related component, help checking property has been filled


https://user-images.githubusercontent.com/33754378/131239984-9138ccfd-5525-4584-8b8c-712079140315.mp4


# Installation

### Cocoapods
RxRequiredPropertyChecker can be added to your project using CocoaPods 0.36 or later by adding the following line to your Podfile:
```
pod 'RxSwift'
pod 'RxCocoa'
pod 'RxRequiredPropertyChecker'
```

### Swift Package Manager
To add RxRequiredPropertyChecker to a [Swift Package Manager](https://swift.org/package-manager/) based project, add:

```swift
.package(url: "https://github.com/xattacker/RxRequiredPropertyChecker.git", .upToNextMajor(from: "1.0.11")),
.package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.2.0")),
```
to your `Package.swift` files `dependencies` array.


### How to use:
``` 
// make the component implement protocol RequiredProperty
extension UITextField: RequiredProperty
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


// then add the component instance into RxRequiredPropertyChecker
let textField: UITextField

let checker = RxRequiredPropertyChecker()
checker.add(textField)

// bind checker with other
checker.rx.isFilled.drive(self.button.rx.isEnable)
		   .disposed(by: self.disposeBag)
``` 
