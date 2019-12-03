import Quick
import Nimble
import Capsule
@testable import Utensils

func whateverFunction(onLaunch: @escaping AppLaunchViewController.OnLaunchHandler) {
    print("FECES")
}

class AppLaunchViewControllerSpec: QuickSpec {
    override func spec() {
        describe("AppLaunchViewController") {
            var subject: AppLaunchViewController!
            
            var fakeDelegate: FakeAppLaunchViewControllerDelegate!

            beforeEach {
                fakeDelegate = FakeAppLaunchViewControllerDelegate()
            }
            
            describe("when the default storyboard is used (delegate version)") {
                beforeEach {
                    subject = AppLaunchViewController(delegate: fakeDelegate)

                    _ = subject.view
                }

                it("loads properly") {
                    expect(subject).toNot(beNil())
                }

                describe("when the view did appear") {
                    beforeEach {
                        subject.viewDidAppear(false)
                    }

                    it("calls the delegates 'didStartLaunching' method") {
                        expect(fakeDelegate.capturedDidStartLaunchingCompletionHandler).toNot(beNil())
                    }

                    describe("when the delegate calls the completionHandler of ''didStartLaunching'") {
                        beforeEach {
                            fakeDelegate.capturedDidStartLaunchingCompletionHandler?()
                        }

                        it("calls the delegates 'didFinishLaunching' method'") {
                            expect(fakeDelegate.didFinishLaunchingCalled).to(beTruthy())
                        }
                    }
                }
            }

            describe("when the default storyboard is used (handler version)") {
                var onLaunchFunction: AppLaunchViewController.OnLaunchHandler!
                var onCompletionFunction: (() -> Void)!

                var didCallOnLaunchFuntion: Bool!
                var didCallOnCompletionFunction: Bool!

                beforeEach {
                    didCallOnLaunchFuntion = false

                    onLaunchFunction = { completionHandler in
                        didCallOnLaunchFuntion = true

                        completionHandler()
                    }

                    didCallOnCompletionFunction = false

                    onCompletionFunction = {
                        didCallOnCompletionFunction = true
                    }

                    subject = AppLaunchViewController(onLaunch: onLaunchFunction,
                                                      onCompletion: onCompletionFunction)

                    _ = subject.view
                }

                it("loads properly") {
                    expect(subject).toNot(beNil())
                }

                describe("when the view did appear") {
                    beforeEach {
                        _ = subject.viewDidAppear(false)
                    }

                    it("calls the onLaunch function") {
                        expect(didCallOnLaunchFuntion).to(beTruthy())
                    }

                    describe("when onLaunch function calls onLaunch function") {
                        it("calls the onCompletion function") {
                            expect(didCallOnCompletionFunction).to(beTruthy())
                        }
                    }
                }
            }

            describe("when a custom storyboard name is used (delegate version)") {
                beforeEach {
                    subject = AppLaunchViewController(delegate: fakeDelegate)
                    
                    _ = subject.view
                }
                
                it("loads properly") {
                    expect(subject).toNot(beNil())
                }
                
                describe("when the view did appear") {
                    beforeEach {
                        subject.viewDidAppear(false)
                    }
                    
                    it("calls the delegates 'didStartLaunching' method") {
                        expect(fakeDelegate.capturedDidStartLaunchingCompletionHandler).toNot(beNil())
                    }
                    
                    describe("when the delegate calls the completionHandler of ''didStartLaunching'") {
                        beforeEach {
                            fakeDelegate.capturedDidStartLaunchingCompletionHandler?()
                        }
                        
                        it("calls the delegates 'didFinishLaunching' method'") {
                            expect(fakeDelegate.didFinishLaunchingCalled).to(beTruthy())
                        }
                    }
                }
            }
            
            describe("when a custom storyboard name is used (handler version)") {
                var onLaunchFunction: AppLaunchViewController.OnLaunchHandler!
                var onCompletionFunction: (() -> Void)!
                
                var didCallOnLaunchFuntion: Bool!
                var didCallOnCompletionFunction: Bool!
                                
                beforeEach {
                    didCallOnLaunchFuntion = false
                    
                    onLaunchFunction = { completionHandler in
                        didCallOnLaunchFuntion = true

                        completionHandler()
                    }
                    
                    didCallOnCompletionFunction = false
                    
                    onCompletionFunction = {
                        didCallOnCompletionFunction = true
                    }
                    
                    subject = AppLaunchViewController(onLaunch: onLaunchFunction,
                                                      onCompletion: onCompletionFunction)

                    _ = subject.view
                }
                
                it("loads properly") {
                    expect(subject).toNot(beNil())
                }
                
                describe("when the view did appear") {
                    beforeEach {
                        _ = subject.viewDidAppear(false)
                    }
                    
                    it("calls the onLaunch function") {
                        expect(didCallOnLaunchFuntion).to(beTruthy())
                    }
                    
                    describe("when onLaunch function calls onLaunch function") {
                        it("calls the onCompletion function") {
                            expect(didCallOnCompletionFunction).to(beTruthy())
                        }
                    }
                }
            }
        }
    }
}
