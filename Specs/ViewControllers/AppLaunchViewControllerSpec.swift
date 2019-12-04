import Quick
import Nimble
import Capsule
@testable import Utensils

class AppLaunchViewControllerSpec: QuickSpec {
    override func spec() {
        describe("AppLaunchViewController") {
            var subject: AppLaunchViewController!
            
            describe("when the default launching view is used") {
                var didLaunchWork: Bool!

                beforeEach {
                    didLaunchWork = false
                    
                    subject = AppLaunchViewController() {
                        didLaunchWork = true
                    }

                    _ = subject.view
                }

                it("loads the default launch view") {
                    expect(subject.view).to(beAnInstanceOf(DefaultAppLaunchView.self))
                }

                describe("when the view did appear") {
                    beforeEach {
                        _ = subject.viewDidAppear(false)
                    }

                    it("executes the launch work") {
                        expect(didLaunchWork).to(beTruthy())
                    }
                }
            }
            
            describe("when a custom launching view is used") {
                var didLaunchWork: Bool!

                beforeEach {
                    didLaunchWork = false
                    
                    subject = AppLaunchViewController() {
                        didLaunchWork = true
                    }
                    
                    subject.customLaunchView = CustomView()

                    _ = subject.view
                }

                it("loads the custom launching view") {
                    expect(subject.view).to(beAnInstanceOf(CustomView.self))
                }

                describe("when the view did appear") {
                    beforeEach {
                        _ = subject.viewDidAppear(false)
                    }

                    it("executes the launch work") {
                        expect(didLaunchWork).to(beTruthy())
                    }
                }
            }
        }
    }
}

/*
 
 Notes: Override loadView() in the view lifecycle if you specify a nil nibName in init(nibname:bundle:), or else
 The system will attempt to fetch a nib in various ways.
 https://developer.apple.com/documentation/uikit/uiviewcontroller/1621487-nibname
 
 */
