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
                            }.to.throwError { (error: Doom) in
                                let expectedError = Doom.error("Unable to access system directory: document")
                                
                                expect(error).to.equal(expectedError)
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
                            }.to.throwError { (error: Directory.Error) in
                                let expectedURL = URL(string: "file:///fake-documents-directory/abc/123/")!

                                let expectedError = Directory.Error.unableToCreateDirectory(url: expectedURL, wrappedError: FakeGenericError.whoCares)
                                
                                expect(error).to.equal(expectedError)
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
                            }.to.throwError { (error: Directory.Error) in
                                let expectedURL = URL(string: "file:///fake-temp-directory/data/tmp/abc/123/")!

                                let expectedError = Directory.Error.unableToCreateDirectory(url: expectedURL, wrappedError: FakeGenericError.whoCares)
                                
                                expect(error).to.equal(expectedError)
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
                            }.to.throwError { (error: Doom) in
                                let expectedError = Doom.error("Unable to access system directory: library")
                                
                                expect(error).to.equal(expectedError)
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
                            }.to.throwError { (error: Directory.Error) in
                                let expectedURL = URL(string: "file:///fake-library-directory/abc/123/")!

                                let expectedError = Directory.Error.unableToCreateDirectory(url: expectedURL, wrappedError: FakeGenericError.whoCares)
                                
                                expect(error).to.equal(expectedError)
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
                            }.to.throwError { (error: Doom) in
                                let expectedError = Doom.error("Unable to access system directory: caches")
                                
                                expect(error).to.equal(expectedError)
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
                            }.to.throwError { (error: Directory.Error) in
                                let expectedURL = URL(string: "file:///fake-caches-directory/abc/123/")!

                                let expectedError = Directory.Error.unableToCreateDirectory(url: expectedURL, wrappedError: FakeGenericError.whoCares)
                                
                                expect(error).to.equal(expectedError)
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
                            }.to.throwError { (error: Doom) in
                                let expectedError = Doom.error("Unable to access system directory: application support")
                                
                                expect(error).to.equal(expectedError)
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
                            }.to.throwError { (error: Directory.Error) in
                                let expectedURL = URL(string: "file:///fake-application-support-directory/abc/123/")!

                                let expectedError = Directory.Error.unableToCreateDirectory(url: expectedURL, wrappedError: FakeGenericError.whoCares)
                                
                                expect(error).to.equal(expectedError)
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
                
                // Note: This is a bare minimum set of functionality to sanitize the additionalPath
                // Additional functionality will be added on an "as needed" basis going foward
                
                describe("additional path sanitization") {
                    it("is sanitized by making it all lowercase") {
                        subject = Directory(.applicationSupport(additionalPath: "FiLez/"),
                                            fileManager: fakeFileManager)
                        
                        url = try? subject.url()

                        expect(url).to.equal(URL(string: "file:///fake-application-support-directory/filez/")!)
                    }
                    
                    it("is sanitized by removing the beginning and ending whitespace") {
                        subject = Directory(.applicationSupport(additionalPath: "  \t\n FiLez  \n\t"),
                                            fileManager: fakeFileManager)
                        
                        url = try? subject.url()

                        expect(url).to.equal(URL(string: "file:///fake-application-support-directory/filez/")!)
                    }
                    
                    it("is sanitized by removing a prefixed forward slash '/'") {
                        subject = Directory(.applicationSupport(additionalPath: "/filez/"),
                                            fileManager: fakeFileManager)
                        
                        url = try? subject.url()

                        expect(url).to.equal(URL(string: "file:///fake-application-support-directory/filez/")!)
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
