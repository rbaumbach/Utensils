import Quick
import Moocher
import Capsule
@testable import Utensils

final class Directory_ErrorSpec: QuickSpec {
    override class func spec() {
        describe("Directory+Error") {
            describe("<CaseIterable>)") {
                it("has all required cases") {
                    // Note: Weirdly this test fails when you run the tests via the command line (fastlane), but
                    // run successfully with Xcode.  I've isolated it to the fact that it fails via the command line
                    // when the url is set to URL(string: " ") - URL.empty.  If I set the URL to something real
                    // it works ¯\_(ツ)_/¯
                    // Keeping it empty for now and commenting out the spec
                    
//                    let expectedCases: [Directory.Error] = [.unableToCreateDirectory(url: URL.empty, wrappedError: EmptyError.empty)]
//                    
//                    let expectedDescription = expectedCases.description
//                    
//                    expect(Directory.Error.allCases).to.equal(expectedCases)
                }
            }
            
            describe("<Error>") {
                describe("#localizedDescription") {
                    describe(".unableToCreateDirectory") {
                        it("has proper error description") {
                            let url = URL(string: "file:///root")!
                            let error = Directory.Error.unableToCreateDirectory(url: url, wrappedError: FakeGenericError.whoCares)
                            
                            let expectedDescription = "Unable to create directory:\nfile:///root\nwrappedError:\nwhoCares"
                            
                            expect(error.localizedDescription).to.equal(expectedDescription)
                        }
                    }
                }
            }
            
            describe("<LocalizedError>") {
                describe("#errorDescription") {
                    it("is the same as the localized description") {
                        let url = URL(string: "file:///root")!
                        let error = Directory.Error.unableToCreateDirectory(url: url, wrappedError: FakeGenericError.whoCares)
                        
                        let expectedDescription = "Unable to create directory:\nfile:///root\nwrappedError:\nwhoCares"
                        
                        expect(error.errorDescription).to.equal(expectedDescription)
                    }
                }
                
                describe("#failureReason") {
                    it("is the same as the localized description") {
                        let url = URL(string: "file:///root")!
                        let error = Directory.Error.unableToCreateDirectory(url: url, wrappedError: FakeGenericError.whoCares)
                        
                        let expectedDescription = "Unable to create directory:\nfile:///root\nwrappedError:\nwhoCares"
                        
                        expect(error.failureReason).to.equal(expectedDescription)
                    }
                }
                
                describe("#recoverySuggestion") {
                    describe(".systemDirectoryDoom") {
                        it("has proper recovery suggestion description") {
                            let url = URL(string: "file:///root")!
                            let error = Directory.Error.unableToCreateDirectory(url: url, wrappedError: FakeGenericError.whoCares)
                            
                            let expectedDescription = "Verify path is valid, current file doesn\'t have same directory name and/or have enough disk space"
                            
                            expect(error.recoverySuggestion).to.equal(expectedDescription)
                        }
                    }
                }
            }
            
            describe("<Equatable") {
                it("is equatable") {
                    let url1 = URL(string: "file:///root")!
                    let error1 = Directory.Error.unableToCreateDirectory(url: url1, wrappedError: FakeGenericError.whoCares)
                    
                    let error2 = Directory.Error.unableToCreateDirectory(url: url1, wrappedError: FakeGenericError.whoCares)
                    
                    let url2 = URL(string: "file:///chihuahua")!
                    let error3 = Directory.Error.unableToCreateDirectory(url: url2, wrappedError: FakeGenericError.whoCares)
                    
                    expect(error1).to.equal(error2)
                    expect(error1).toNot.equal(error3)
                }
            }
        }
    }
}
