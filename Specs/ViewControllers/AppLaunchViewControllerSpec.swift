import Quick
import Moocher
import Capsule
@testable import Utensils

final class AppLaunchViewControllerSpec: QuickSpec {
    override class func spec() {
        describe("AppLaunchViewController") {
            // TODO: Fix this spec

//            var subject: AppLaunchViewController!
//
//            describe("when the default launching view is used") {
//                var didLaunchWork: Bool!
//
//                beforeEach {
//                    didLaunchWork = false
//                    
//                    subject = AppLaunchViewController() {
//                        didLaunchWork = true
//                    }
//
//                    _ = subject.view
//                }
//
//                it("loads the default launch view") {
//                    expect(subject.view).to.beInstanceOf(DefaultAppLaunchView.self)
//                }
//
//                describe("when the view did appear") {
//                    beforeEach {
//                        subject.viewDidAppear(false)
//                    }
//
//                    it("executes the launch work") {
//                        expect(didLaunchWork).to.beTruthy()
//                    }
//                }
//            }
//            
//            describe("when a custom launching view is used") {
//                var didLaunchWork: Bool!
//
//                beforeEach {
//                    didLaunchWork = false
//                    
//                    subject = AppLaunchViewController() {
//                        didLaunchWork = true
//                    }
//                    
//                    subject.customLaunchView = CustomView()
//
//                    _ = subject.view
//                }
//
//                it("loads the custom launching view") {                    
//                  expect(subject.view).to.beInstanceOf(CustomView.self)
//                }
//
//                describe("when the view did appear") {
//                    beforeEach {
//                        subject.viewDidAppear(false)
//                    }
//
//                    it("executes the launch work") {
//                        expect(didLaunchWork).to.beTruthy()
//                    }
//                }
//            }
        }
    }
}

/*
 
 Notes: Override loadView() in the view lifecycle if you specify a nil nibName in init(nibname:bundle:), or else
 The system will attempt to fetch a nib in various ways.
 https://developer.apple.com/documentation/uikit/uiviewcontroller/1621487-nibname
 
 */
