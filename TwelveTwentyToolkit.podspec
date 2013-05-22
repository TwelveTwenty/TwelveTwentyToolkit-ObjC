Pod::Spec.new do |s|
  s.name         = 'TwelveTwentyToolkit'
  s.version      = '0.1.3'
  s.summary      = 'The Twelve Twenty Toolkit of reusable Objective-C classes.'
  s.homepage     = 'http://twelvetwenty.nl'
  s.license      = 'MIT'
  s.author       = { 'Eric-Paul Lecluse' => 'epologee@gmail.com', 'Jankees van Woezik' => 'jankeesvw@gmail.com' }
  s.source       = { :git => 'https://github.com/TwelveTwenty/TwelveTwentyToolkit-ObjC.git', :tag => '0.1.3' }
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  s.requires_arc = true
  
  s.subspec 'Core' do |c|
    c.source_files = 'TwelveTwentyToolkit/TwelveTwentyToolkit.h'
  end
  
  s.subspec 'Foundation' do |fn|
    fn.dependency 'TwelveTwentyToolkit/Core'
    fn.source_files = 'TwelveTwentyToolkit/Foundation/**/*.{h,m}'
  end

  s.subspec 'Foundation-iOS' do |fn|
    fn.ios.dependency 'TwelveTwentyToolkit/Foundation'
    fn.ios.source_files = 'TwelveTwentyToolkit/Foundation-iOS/**/*.{h,m}'
  end

  s.subspec 'Logging' do |lg|
    lg.dependency 'TwelveTwentyToolkit/Foundation'
    lg.source_files = 'TwelveTwentyToolkit/Logging/**/*.{h,m}'
  end
  
  s.subspec 'CoreGraphics' do |cg|
    cg.ios.frameworks = 'UIKit','QuartzCore'
    cg.ios.dependency 'TwelveTwentyToolkit/Foundation'
    cg.ios.source_files = 'TwelveTwentyToolkit/CoreGraphics/*.{h,m}'
  end
  
  s.subspec 'CoreData' do |cd|
    cd.frameworks = 'CoreData'
    cd.dependency 'TwelveTwentyToolkit/Foundation'
    cd.source_files = 'TwelveTwentyToolkit/CoreData/*.{h,m}'
  end

  s.subspec 'CoreData-iOS' do |cd|
    cd.ios.frameworks = 'CoreData'
    cd.ios.dependency 'TwelveTwentyToolkit/Foundation'
    cd.ios.dependency 'TwelveTwentyToolkit/CoreData'
    cd.ios.source_files = 'TwelveTwentyToolkit/CoreData-iOS/*.{h,m}'
  end
  
  s.subspec 'Persistence' do |ps|
    ps.ios.frameworks = 'CoreData'
    ps.ios.dependency 'TwelveTwentyToolkit/CoreData'
    ps.ios.source_files = 'TwelveTwentyToolkit/Persistence/*.{h,m}'
  end
  
  s.subspec 'AddressBook' do |ab|
    ab.ios.frameworks = 'AddressBook'
    ab.ios.dependency 'TwelveTwentyToolkit/CoreData'
    ab.ios.source_files = 'TwelveTwentyToolkit/AddressBook/**/*.{h,m}'
  end
  
  s.subspec 'DependencyInjection' do |di|
    di.dependency 'TwelveTwentyToolkit/Logging'
    di.source_files = 'TwelveTwentyToolkit/DependencyInjection/**/*.{h,m}'
  end
  
  s.subspec 'OperationCenter' do |di|
    di.dependency 'TwelveTwentyToolkit/DependencyInjection'
    di.source_files = 'TwelveTwentyToolkit/OperationCenter/**/*.{h,m}'
  end
  
  s.subspec 'Tables' do |tb|
    tb.ios.dependency 'TwelveTwentyToolkit/Logging'
    tb.ios.source_files = 'TwelveTwentyToolkit/Tables/**/*.{h,m}'
  end
  
  s.subspec 'Layout' do |lo|
    lo.ios.dependency 'TwelveTwentyToolkit/Logging'
    lo.ios.source_files = 'TwelveTwentyToolkit/Layout/**/*.{h,m}'
  end

  s.subspec 'CoreAnimation' do |ca|
    ca.ios.dependency 'TwelveTwentyToolkit/Logging'
    ca.ios.source_files = 'TwelveTwentyToolkit/CoreAnimation/**/*.{h,m}'
  end
end