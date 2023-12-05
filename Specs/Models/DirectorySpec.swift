import Quick
import Moocher
import Capsule
@testable import Utensils

final class DirectorySpec: QuickSpec {
    override func spec() {
        describe("Directory") {
            var subject: Directory!
            
            var fakeFileManager: FakeFileManager!
            
            beforeEach {
                fakeFileManager = FakeFileManager()
            }
            
            it("defaults to the documents directory") {
                subject = Directory(fileManager: fakeFileManager)
                
                let expectedURL = URL(string: "file:///fake-documents-directory")!
                
                expect(subject.url()).to.equal(expectedURL)
                expect(fakeFileManager.capturedSearchPathDirectory).to.equal(.documentDirectory)
            }
            
            describe("when building file URL from directory and filename") {
                var url: URL!
                
                describe("when building /Documents directory URL") {
                    describe("when an additional path is given") {
                        describe("when the additional path directory in documents doesn't exist") {
                            beforeEach {
                                subject = Directory(.documents(additionalPath: "abc/123/"),
                                                    fileManager: fakeFileManager)
                                
                                url = subject.url()
                            }
                            
                            it("creates the the additional path directory in documents") {
                                expect(fakeFileManager.capturedFileExistsPath).to.equal("/fake-documents-directory/abc/123")
                                expect(fakeFileManager.capturedCreateDirectoryURL).to.equal(URL(string: "file:///fake-documents-directory/abc/123"))
                                expect(fakeFileManager.capturedCreateDirectoryCreateIntermediates).to.beTruthy()
                                expect(fakeFileManager.capturedCreateDirectoryAttributes).to.beNil()
                                
                                expect(url).to.equal(URL(string: "file:///fake-documents-directory/abc/123")!)
                            }
                        }
                        
                        describe("when the additional path directory in documents exists") {
                            beforeEach {
                                fakeFileManager.stubbedFileExistsPath = true
                                
                                subject = Directory(.documents(additionalPath: "abc/123/"),
                                                    fileManager: fakeFileManager)
                                
                                url = subject.url()
                            }
                            
                            it("builds the correct URL") {
                                expect(url).to.equal(URL(string: "file:///fake-documents-directory/abc/123")!)
                            }
                        }
                    }
                    
                    describe("when NO additional path is given") {
                        beforeEach {
                            subject = Directory(.documents(),
                                                fileManager: fakeFileManager)
                            
                            url = subject.url()
                        }
                        
                        it("builds the correct URL") {
                            expect(url).to.equal(URL(string: "file:///fake-documents-directory")!)
                        }
                    }
                }
                
                describe("when building /tmp directory URL") {
                    describe("when an additional path is given") {
                        describe("when the additional path directory in tmp doesn't exist") {
                            beforeEach {
                                subject = Directory(.temp(additionalPath: "abc/123/"), fileManager: fakeFileManager)
                                
                                url = subject.url()
                            }
                            
                            it("creates the the additional path directory in temp") {
                                expect(fakeFileManager.capturedFileExistsPath).to.equal("/fake-temp-directory/abc/123")
                                expect(fakeFileManager.capturedCreateDirectoryURL).to.equal(URL(string: "file:///fake-temp-directory/abc/123"))
                                expect(fakeFileManager.capturedCreateDirectoryCreateIntermediates).to.beTruthy()
                                expect(fakeFileManager.capturedCreateDirectoryAttributes).to.beNil()
                                
                                expect(url).to.equal(URL(string: "file:///fake-temp-directory/abc/123")!)
                            }
                        }
                        
                        describe("when the additional path directory in tmp exists") {
                            beforeEach {
                                fakeFileManager.stubbedFileExistsPath = true
                                
                                subject = Directory(.temp(additionalPath: "abc/123/"), fileManager: fakeFileManager)
                                
                                url = subject.url()
                            }
                            
                            it("builds the correct URL") {
                                expect(url).to.equal(URL(string: "file:///fake-temp-directory/abc/123")!)
                            }
                        }
                    }
                    
                    describe("when NO additional path is given") {
                        beforeEach {
                            subject = Directory(.temp(), fileManager: fakeFileManager)
                            
                            url = subject.url()
                        }
                        
                        it("builds the correct URL") {
                            expect(url).to.equal(URL(string: "file:///fake-temp-directory")!)
                        }
                    }
                }
                
                describe("when building /Library directory URL") {
                    describe("when an additional path is given") {
                        describe("when the additional path directory in library doesn't exist") {
                            beforeEach {
                                subject = Directory(.library(additionalPath: "abc/123/"), fileManager: fakeFileManager)
                                
                                url = subject.url()
                            }
                            
                            it("creates the the additional path directory in library") {
                                expect(fakeFileManager.capturedFileExistsPath).to.equal("/fake-library-directory/abc/123")
                                expect(fakeFileManager.capturedCreateDirectoryURL).to.equal(URL(string: "file:///fake-library-directory/abc/123"))
                                expect(fakeFileManager.capturedCreateDirectoryCreateIntermediates).to.beTruthy()
                                expect(fakeFileManager.capturedCreateDirectoryAttributes).to.beNil()
                                
                                expect(url).to.equal(URL(string: "file:///fake-library-directory/abc/123")!)
                            }
                        }
                        
                        describe("when the additional path directory in library exists") {
                            beforeEach {
                                fakeFileManager.stubbedFileExistsPath = true
                                
                                subject = Directory(.library(additionalPath: "abc/123/"), fileManager: fakeFileManager)
                                
                                url = subject.url()
                            }
                            
                            it("builds the correct URL") {
                                expect(url).to.equal(URL(string: "file:///fake-library-directory/abc/123")!)
                            }
                        }
                    }
                    
                    describe("when NO additional path is given") {
                        beforeEach {
                            subject = Directory(.library(), fileManager: fakeFileManager)
                            
                            url = subject.url()
                        }
                        
                        it("builds the correct URL") {
                            expect(url).to.equal(URL(string: "file:///fake-library-directory")!)
                        }
                    }
                }
                
                describe("when building /Library/Caches directory URL") {
                    describe("when an additional path is given") {
                        describe("when the additional path directory in documents doesn't exist") {
                            beforeEach {
                                subject = Directory(.caches(additionalPath: "abc/123/"), fileManager: fakeFileManager)
                                
                                url = subject.url()
                            }
                            
                            it("creates the the additional path directory in caches") {
                                expect(fakeFileManager.capturedFileExistsPath).to.equal("/fake-caches-directory/abc/123")
                                expect(fakeFileManager.capturedCreateDirectoryURL).to.equal(URL(string: "file:///fake-caches-directory/abc/123"))
                                expect(fakeFileManager.capturedCreateDirectoryCreateIntermediates).to.beTruthy()
                                expect(fakeFileManager.capturedCreateDirectoryAttributes).to.beNil()
                                
                                expect(url).to.equal(URL(string: "file:///fake-caches-directory/abc/123")!)
                            }
                        }
                        
                        describe("when the additional path directory in caches exists") {
                            beforeEach {
                                fakeFileManager.stubbedFileExistsPath = true
                                
                                subject = Directory(.caches(additionalPath: "abc/123/"), fileManager: fakeFileManager)
                                
                                url = subject.url()
                            }
                            
                            it("builds the correct URL") {
                                expect(url).to.equal(URL(string: "file:///fake-caches-directory/abc/123")!)
                            }
                        }
                    }
                    
                    describe("when NO additional path is given") {
                        beforeEach {
                            subject = Directory(.caches(), fileManager: fakeFileManager)
                            
                            url = subject.url()
                        }
                        
                        it("builds the correct URL") {
                            expect(url).to.equal(URL(string: "file:///fake-caches-directory")!)
                        }
                    }
                }
                
                describe("when building '/Library/Application Support' directory URL") {
                    describe("when an additional path is given") {
                        describe("when the additional path directory in application support doesn't exist") {
                            beforeEach {
                                subject = Directory(.applicationSupport(additionalPath: "abc/123/"), fileManager: fakeFileManager)
                                
                                url = subject.url()
                            }
                            
                            it("creates the application support directory") {
                                expect(fakeFileManager.capturedFileExistsPath).to.equal("/fake-application-support-directory/abc/123")
                                expect(fakeFileManager.capturedCreateDirectoryURL).to.equal(URL(string: "file:///fake-application-support-directory/abc/123"))
                                expect(fakeFileManager.capturedCreateDirectoryCreateIntermediates).to.beTruthy()
                                expect(fakeFileManager.capturedCreateDirectoryAttributes).to.beNil()
                                
                                expect(url).to.equal(URL(string: "file:///fake-application-support-directory/abc/123")!)
                            }
                        }
                        
                        describe("when the additional path directory in application support exists") {
                            beforeEach {
                                fakeFileManager.stubbedFileExistsPath = true
                                
                                subject = Directory(.applicationSupport(additionalPath: "abc/123/"), fileManager: fakeFileManager)
                                
                                url = subject.url()
                            }
                            
                            it("builds the correct URL") {
                                expect(fakeFileManager.capturedFileExistsPath).to.equal("/fake-application-support-directory/abc/123")
                                
                                expect(url).to.equal(URL(string: "file:///fake-application-support-directory/abc/123")!)
                            }
                        }
                    }
                    
                    describe("when NO additional path is given") {
                        describe("when the application support directory doesn't exist") {
                            beforeEach {
                                subject = Directory(.applicationSupport(), fileManager: fakeFileManager)
                                                               
                                url = subject.url()
                            }
                            
                            it("creates the application support directory") {
                                expect(fakeFileManager.capturedFileExistsPath).to.equal("/fake-application-support-directory")
                                expect(fakeFileManager.capturedCreateDirectoryURL).to.equal(URL(string: "file:///fake-application-support-directory"))
                                expect(fakeFileManager.capturedCreateDirectoryCreateIntermediates).to.beTruthy()
                                expect(fakeFileManager.capturedCreateDirectoryAttributes).to.beNil()
                                
                                expect(url).to.equal(URL(string: "file:///fake-application-support-directory")!)
                            }
                        }
                        
                        describe("when the application support directory exists") {
                            beforeEach {
                                fakeFileManager.stubbedFileExistsPath = true
                                
                                subject = Directory(.applicationSupport(), fileManager: fakeFileManager)
                                                               
                                url = subject.url()
                            }
                            
                            it("builds the correct URL") {
                                expect(fakeFileManager.capturedFileExistsPath).to.equal("/fake-application-support-directory")
                                
                                expect(url).to.equal(URL(string: "file:///fake-application-support-directory")!)
                            }
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
