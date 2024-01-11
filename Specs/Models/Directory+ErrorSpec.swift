import Quick
import Moocher
import Capsule
@testable import Utensils

final class Directory_ErrorSpec: QuickSpec {
    override class func spec() {
        describe("Directory+Error") {
            describe("<CaseIterable>)") {
                it("has all required cases") {
                    let expectedCases: [Directory.Error] = [.systemDirectoryDoom,
                                                            .unableToCreateDirectory((url: URL.empty, wrappedError: EmptyError.empty))]
                    
                    expect(Directory.Error.allCases).to.equal(expectedCases)
                }
            }
            
            describe("<Error>") {
                describe("#localizedDescription") {
                    describe(".systemDirectoryDoom") {
                        it("has proper error description") {
                            let systemDirectoryDoomErrorDescription = Directory.Error.systemDirectoryDoom.localizedDescription
                            let expectedLocalizedDescription = "Unable to retrieve system search path directory"
                            
                            expect(systemDirectoryDoomErrorDescription).to.equal(expectedLocalizedDescription)
                        }
                    }
                    
                    describe(".unableToCreateDirectory") {
                        it("has proper error description") {
                            let tuple = (url: URL(string: "file:///root")!, wrappedError: FakeGenericError.whoCares)
                            
                            let unableToCreateDirectoryDescription = Directory.Error.unableToCreateDirectory(tuple).localizedDescription
                            let expectedLocalizedDescription = "Unable to create directory:\nfile:///root\nwrappedError:\nwhoCares"
                            
                            expect(unableToCreateDirectoryDescription).to.equal(expectedLocalizedDescription)
                        }
                    }
                }
            }
            
            describe("<LocalizedError>") {
                describe("#errorDescription") {
                    it("is the same as the localized description") {
                        let systemDirectoryDoomDescription = Directory.Error.systemDirectoryDoom.errorDescription
                        let expectedDirectoryDoomDescription = "Unable to retrieve system search path directory"
                        
                        expect(systemDirectoryDoomDescription).to.equal(expectedDirectoryDoomDescription)
                        
                        let tuple = (url: URL(string: "file:///root")!, wrappedError: FakeGenericError.whoCares)
                        
                        let unableToCreateDirectoryDescription = Directory.Error.unableToCreateDirectory(tuple).errorDescription
                        let expectedUnableToCreateDirectoryDescription = "Unable to create directory:\nfile:///root\nwrappedError:\nwhoCares"
                        
                        expect(unableToCreateDirectoryDescription).to.equal(expectedUnableToCreateDirectoryDescription)
                    }
                }
                
                describe("#failureReason") {
                    it("is the same as the localized description") {
                        let systemDirectoryDoomDescription = Directory.Error.systemDirectoryDoom.failureReason
                        let expectedDirectoryDoomDescription = "Unable to retrieve system search path directory"
                        
                        expect(systemDirectoryDoomDescription).to.equal(expectedDirectoryDoomDescription)
                        
                        let tuple = (url: URL(string: "file:///root")!, wrappedError: FakeGenericError.whoCares)
                        
                        let unableToCreateDirectoryDescription = Directory.Error.unableToCreateDirectory(tuple).errorDescription
                        let expectedUnableToCreateDirectoryDescription = "Unable to create directory:\nfile:///root\nwrappedError:\nwhoCares"
                        
                        expect(unableToCreateDirectoryDescription).to.equal(expectedUnableToCreateDirectoryDescription)
                    }
                }
                
                describe("#recoverySuggestion") {
                    describe(".systemDirectoryDoom") {
                        it("has proper recovery suggestion description") {
                            let systemDirectoryDoomErrorDescription = Directory.Error.systemDirectoryDoom.recoverySuggestion
                            let expectedLocalizedDescription = "Unable to get system directory.  Something is seriously wrong with your device"
                            
                            expect(systemDirectoryDoomErrorDescription).to.equal(expectedLocalizedDescription)
                        }
                    }
                    
                    describe(".unableToCreateDirectory") {
                        it("has proper recovery suggestion description") {
                            let tuple = (url: URL(string: "file:///root")!, wrappedError: FakeGenericError.whoCares)
                            
                            let unableToCreateDirectoryDescription = Directory.Error.unableToCreateDirectory(tuple).recoverySuggestion
                            let expectedLocalizedDescription = "Verify path is valid, current file doesn't have same directory name and/or have enough disk space"
                            
                            expect(unableToCreateDirectoryDescription).to.equal(expectedLocalizedDescription)
                        }
                    }
                }
            }
            
            describe("<Equatable") {
                it("is equatable") {
                    let systemDoomError = Directory.Error.systemDirectoryDoom
                    
                    expect(systemDoomError).to.equal(Directory.Error.systemDirectoryDoom)
                    
                    let tuple = (url: URL(string: "file:///root")!, wrappedError: FakeGenericError.whoCares)
                    
                    let unableToCreateDirectoryError = Directory.Error.unableToCreateDirectory(tuple)
                    
                    expect(systemDoomError).toNot.equal(unableToCreateDirectoryError)
                }
            }
        }
    }
}
