Pod::Spec.new do |s|
  s.name = 'RxRequiredPropertyChecker'
  s.version = '1.0.6'
  s.license = 'MIT'
  s.summary = 'a RxSwift Related component'
  s.homepage = 'https://github.com/xattacker/RxRequiredPropertyChecker'
  s.authors = { 'Xattacker' => 'amigo.xattacker@gmail.com' }
  s.source = { :git => 'https://github.com/xattacker/RxRequiredPropertyChecker.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  s.requires_arc = true
  s.source_files = 'RxRequiredPropertyChecker/Sources/*.swift'
  s.dependency "RxSwift"
  s.dependency "RxCocoa"
end
