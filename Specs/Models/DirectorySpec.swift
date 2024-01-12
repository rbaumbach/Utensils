import Quick
import Moocher
import Capsule
@testable import Utensils

final class DirectorySpec: QuickSpec {
    override class func spec() {
        describe("Directory") {
            var subject: Directory!
            
            var fakeFileManager: FakeFileManagerUtensils!
            
            beforeEach {
                fakeFileManager = FakeFileManagerUtensils()
            }
            
            it("defaults to the documents directory") {
                subject = Directory(fileManager: fakeFileManager)
                
                let expectedURL = URL(string: "file:///fake-documents-directory/")!
                
                expect(try? subject.url()).to.equal(expectedURL)
                expect(fakeFileManager.capturedSearchPathDirectory).to.equal(.documentDirectory)
            }
            
            describe("when building file URL from directory") {
                var url: URL!
                
                describe("when building /Documents directory URL") {
                    describe("when the file manager cannot get the documents directory URL") {
                        beforeEach {
                            fakeFileManager.shouldUseSimpleStubForSearchPathDirectoryURLS = true
                            
                            subject = Directory(fileManager: fakeFileManager)
                        }
                        
                        // Note: This is a doom error because I think your screwed if you ever see this error, as
                        // it means you don't have access to the app system directories and are doome...
                        
                        it("throws Doom error") {
                            expect {
                                url = try subject.url()
                            }.to.throwError { error in
                                guard let typedError = error as? Doom else {
                                    failSpec()
                                    
                                    return
                                }
                                                                
                                let expectedError = Doom.error("Unable to access system directory: document")
                                
                                expect(typedError).to.equal(expectedError)
                            }
                        }
                    }
                    
                    describe("when the file manager is unable to create the directory") {
                        beforeEach {
                            fakeFileManager.shouldThrowCreateDirectoryError = true
                            
                            subject = Directory(.documents(additionalPath: "abc/123/"),
                                                           fileManager: fakeFileManager)
                        }
                        
                        it("throws unableToCreateDirectory error") {
                            expect {
                                url = try subject.url()
                            }.to.throwError { error in
                                guard let typedError = error as? Directory.Error else {
                                    failSpec()
                                    
                                    return
                                }
                                
                                let expectedURL = URL(string: "file:///fake-documents-directory/abc/123/")!

                                let expectedError = Directory.Error.unableToCreateDirectory(url: expectedURL, wrappedError: FakeGenericError.whoCares)
                                
                                expect(typedError).to.equal(expectedError)
                            }
                        }
                    }
                    
                    describe("when an additional path is given") {
                        beforeEach {
                            subject = Directory(.documents(additionalPath: "abc/123/"),
                                                fileManager: fakeFileManager)
                            
                            url = try? subject.url()
                        }
                        
                        it("builds the correct URL") {
                            expect(fakeFileManager.capturedSearchPathDirectory).to.equal(.documentDirectory)
                            expect(fakeFileManager.capturedSearchPathDomainMask).to.equal(.userDomainMask)
                            expect(fakeFileManager.capturedCreateDirectoryUtensilsURL).to.equal(URL(string: "file:///fake-documents-directory/abc/123/"))
                            
                            expect(url).to.equal(URL(string: "file:///fake-documents-directory/abc/123/")!)
                        }
                    }
                    
                    describe("when NO additional path is given") {
                        beforeEach {
                            subject = Directory(.documents(),
                                                fileManager: fakeFileManager)
                            
                            url = try? subject.url()
                        }
                        
                        it("builds the correct URL") {
                            expect(url).to.equal(URL(string: "file:///fake-documents-directory/")!)
                        }
                    }
                }
                                
                describe("when building /tmp (temporary) directory URL") {
                    // Note: The temp directory is accessed differently than the other system
                    // directories, there isn't a way to check for "doom"
                    
                    describe("when the file manager is unable to create the directory") {
                        beforeEach {
                            fakeFileManager.shouldThrowCreateDirectoryError = true
                            
                            subject = Directory(.temp(additionalPath: "abc/123/"),
                                                fileManager: fakeFileManager)
                        }
                        
                        it("throws unableToCreateDirectory error") {
                            expect {
                                url = try subject.url()
                            }.to.throwError { error in
                                guard let typedError = error as? Directory.Error else {
                                    failSpec()
                                    
                                    return
                                }
                                
                                let expectedURL = URL(string: "file:///fake-temp-directory/data/tmp/abc/123/")!

                                let expectedError = Directory.Error.unableToCreateDirectory(url: expectedURL, wrappedError: FakeGenericError.whoCares)
                                
                                expect(typedError).to.equal(expectedError)
                            }
                        }
                    }
                    
                    describe("when an additional path is given") {
                        beforeEach {
                            subject = Directory(.temp(additionalPath: "abc/123/"),
                                                fileManager: fakeFileManager)
                            
                            url = try? subject.url()
                        }
                        
                        it("builds the correct URL") {
                            let expectedURL = URL(string: "file:///fake-temp-directory/data/tmp/abc/123/")
                            
                            expect(fakeFileManager.capturedCreateDirectoryUtensilsURL).to.equal(expectedURL)
                            
                            expect(url).to.equal(URL(string: "file:///fake-temp-directory/data/tmp/abc/123/")!)
                        }
                    }
                    
                    describe("when NO additional path is given") {
                        beforeEach {
                            subject = Directory(.temp(),
                                                fileManager: fakeFileManager)
                            
                            url = try? subject.url()
                        }
                        
                        it("builds the correct URL") {
                            expect(url).to.equal(URL(string: "file:///fake-temp-directory/data/tmp/")!)
                        }
                    }
                }
                
                describe("when building /Library directory URL") {
                    describe("when the file manager cannot get the library directory URL") {
                        beforeEach {
                            fakeFileManager.shouldUseSimpleStubForSearchPathDirectoryURLS = true
                            
                            subject = Directory(.library(),
                                                fileManager: fakeFileManager)
                        }
                        
                        // Note: This is a doom error because I think your screwed if you ever see this error, as
                        // it means you don't have access to the app system directories and are doome...
                        
                        it("throws systemDirectoryDoom error") {
                            expect {
                                url = try subject.url()
                            }.to.throwError { error in
                                guard let typedError = error as? Doom else {
                                    failSpec()
                                    
                                    return
                                }
                                
                                let expectedError = Doom.error("Unable to access system directory: library")
                                
                                expect(typedError).to.equal(expectedError)
                            }
                        }
                    }
                    
                    describe("when the file manager is unable to create the directory") {
                        beforeEach {
                            fakeFileManager.shouldThrowCreateDirectoryError = true
                            
                            subject = Directory(.library(additionalPath: "abc/123/"),
                                                fileManager: fakeFileManager)
                        }
                        
                        it("throws unableToCreateDirectory error") {
                            expect {
                                url = try subject.url()
                            }.to.throwError { error in
                                guard let typedError = error as? Directory.Error else {
                                    failSpec()
                                    
                                    return
                                }
                                
                                let expectedURL = URL(string: "file:///fake-library-directory/abc/123/")!

                                let expectedError = Directory.Error.unableToCreateDirectory(url: expectedURL, wrappedError: FakeGenericError.whoCares)
                                
                                expect(typedError).to.equal(expectedError)
                            }
                        }
                    }
                    
                    describe("when an additional path is given") {
                        beforeEach {
                            subject = Directory(.library(additionalPath: "abc/123/"),
                                                fileManager: fakeFileManager)
                            
                            url = try? subject.url()
                        }
                        
                        it("builds the correct URL") {
                            expect(fakeFileManager.capturedSearchPathDirectory).to.equal(.libraryDirectory)
                            expect(fakeFileManager.capturedSearchPathDomainMask).to.equal(.userDomainMask)
                            expect(fakeFileManager.capturedCreateDirectoryUtensilsURL).to.equal(URL(string: "file:///fake-library-directory/abc/123/"))
                            
                            expect(url).to.equal(URL(string: "file:///fake-library-directory/abc/123/")!)
                        }
                    }
                    
                    describe("when NO additional path is given") {
                        beforeEach {
                            subject = Directory(.library(),
                                                fileManager: fakeFileManager)
                            
                            url = try? subject.url()
                        }
                        
                        it("builds the correct URL") {
                            expect(url).to.equal(URL(string: "file:///fake-library-directory/")!)
                        }
                    }
                }

                describe("when building /Library/Caches directory URL") {
                    describe("when the file manager cannot get the caches directory URL") {
                        beforeEach {
                            fakeFileManager.shouldUseSimpleStubForSearchPathDirectoryURLS = true
                            
                            subject = Directory(.caches(),
                                                fileManager: fakeFileManager)
                        }
                        
                        // Note: This is a doom error because I think your screwed if you ever see this error, as
                        // it means you don't have access to the app system directories and are doome...
                        
                        it("throws systemDirectoryDoom error") {
                            expect {
                                url = try subject.url()
                            }.to.throwError { error in
                                guard let typedError = error as? Doom else {
                                    failSpec()
                                    
                                    return
                                }
                                
                                let expectedError = Doom.error("Unable to access system directory: caches")
                                
                                expect(typedError).to.equal(expectedError)
                            }
                        }
                    }
                    
                    describe("when the file manager is unable to create the directory") {
                        beforeEach {
                            fakeFileManager.shouldThrowCreateDirectoryError = true
                            
                            subject = Directory(.caches(additionalPath: "abc/123/"),
                                                fileManager: fakeFileManager)
                        }
                        
                        it("throws unableToCreateDirectory error") {
                            expect {
                                url = try subject.url()
                            }.to.throwError { error in
                                guard let typedError = error as? Directory.Error else {
                                    failSpec()
                                    
                                    return
                                }
                                
                                let expectedURL = URL(string: "file:///fake-caches-directory/abc/123/")!

                                let expectedError = Directory.Error.unableToCreateDirectory(url: expectedURL, wrappedError: FakeGenericError.whoCares)
                                
                                expect(typedError).to.equal(expectedError)
                            }
                        }
                    }
                    
                    describe("when an additional path is given") {
                        beforeEach {
                            subject = Directory(.caches(additionalPath: "abc/123/"),
                                                fileManager: fakeFileManager)
                            
                            url = try? subject.url()
                        }
                        
                        it("builds the correct URL") {
                            expect(fakeFileManager.capturedSearchPathDirectory).to.equal(.cachesDirectory)
                            expect(fakeFileManager.capturedSearchPathDomainMask).to.equal(.userDomainMask)
                            expect(fakeFileManager.capturedCreateDirectoryUtensilsURL).to.equal(URL(string: "file:///fake-caches-directory/abc/123/"))
                            
                            expect(url).to.equal(URL(string: "file:///fake-caches-directory/abc/123/")!)
                        }
                    }
                    
                    describe("when NO additional path is given") {
                        beforeEach {
                            subject = Directory(.caches(),
                                                fileManager: fakeFileManager)
                            
                            url = try? subject.url()
                        }
                        
                        it("builds the correct URL") {
                            expect(url).to.equal(URL(string: "file:///fake-caches-directory/")!)
                        }
                    }
                }
                
                describe("when building '/Library/Application Support' directory URL") {
                    describe("when the file manager cannot get the documents directory URL") {
                        beforeEach {
                            fakeFileManager.shouldUseSimpleStubForSearchPathDirectoryURLS = true
                            
                            subject = Directory(.applicationSupport(),
                                                fileManager: fakeFileManager)
                        }
                        
                        // Note: This is a doom error because I think your screwed if you ever see this error, as
                        // it means you don't have access to the app system directories and are doome...
                        
                        it("throws systemDirectoryDoom error") {
                            expect {
                                url = try subject.url()
                            }.to.throwError { error in
                                guard let typedError = error as? Doom else {
                                    failSpec()
                                    
                                    return
                                }
                                
                                let expectedError = Doom.error("Unable to access system directory: application support")
                                
                                expect(typedError).to.equal(expectedError)
                            }
                        }
                    }
                    
                    describe("when the file manager is unable to create the directory") {
                        beforeEach {
                            fakeFileManager.shouldThrowCreateDirectoryError = true
                            
                            subject = Directory(.applicationSupport(additionalPath: "abc/123/"),
                                                fileManager: fakeFileManager)
                        }
                        
                        it("throws unableToCreateDirectory error") {
                            expect {
                                url = try subject.url()
                            }.to.throwError { error in
                                guard let typedError = error as? Directory.Error else {
                                    failSpec()
                                    
                                    return
                                }
                                
                                let expectedURL = URL(string: "file:///fake-application-support-directory/abc/123/")!

                                let expectedError = Directory.Error.unableToCreateDirectory(url: expectedURL, wrappedError: FakeGenericError.whoCares)
                                
                                expect(typedError).to.equal(expectedError)
                            }
                        }
                    }
                    
                    describe("when an additional path is given") {
                        beforeEach {
                            subject = Directory(.applicationSupport(additionalPath: "abc/123/"),
                                                fileManager: fakeFileManager)
                            
                            url = try? subject.url()
                        }
                        
                        it("builds the correct URL") {
                            expect(fakeFileManager.capturedSearchPathDirectory).to.equal(.applicationSupportDirectory)
                            expect(fakeFileManager.capturedSearchPathDomainMask).to.equal(.userDomainMask)
                            expect(fakeFileManager.capturedCreateDirectoryUtensilsURL).to.equal(URL(string: "file:///fake-application-support-directory/abc/123/"))
                            
                            expect(url).to.equal(URL(string: "file:///fake-application-support-directory/abc/123/")!)
                        }
                    }
                    
                    describe("when NO additional path is given") {
                        beforeEach {
                            subject = Directory(.applicationSupport(),
                                                fileManager: fakeFileManager)
                            
                            url = try? subject.url()
                        }
                        
                        it("builds the correct URL") {
                            expect(url).to.equal(URL(string: "file:///fake-application-support-directory/")!)
                        }
                    }
                }
            }
            
            describe("<Equatable>") {
                it("is equtable based on SystemDirectory state only") {
                    let dir1 = Directory()
                    let dir2 = Directory()
                    
                    expect(dir1).to.equal(dir2)
                    
                    let anotherDir = Directory(.temp())
                    
                    expect(dir1).toNot.equal(anotherDir)
                }
            }
        }
    }
}
