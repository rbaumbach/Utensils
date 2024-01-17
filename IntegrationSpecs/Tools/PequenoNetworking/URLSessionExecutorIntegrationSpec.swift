import Quick
import Moocher
import Capsule
@testable import Utensils

final class URLSessionExecutorIntegrationSpec: QuickSpec {
    override class func spec() {
        describe("PequenoNetworking") {
            var subject: URLSessionExecutor!
            
            var urlRequest: URLRequest!
            
            var testBundle: Bundle!
                        
            beforeEach {
                testBundle = Bundle(for: self)
                                
                subject = URLSessionExecutor()
            }
            
            describe("executing data tasks") {
                beforeEach {
                    var urlComponents = URLComponents(string: "https://httpbin.org")!
                    urlComponents.path = "/get"
                    
                    urlRequest = URLRequest(url: urlComponents.url!)
                }
                
                it("completes with url to downloaded image") {
                    hangOn(for: .seconds(5)) { complete in
                        subject.execute(urlRequest: urlRequest) { result in
                            if case .success(let responseData) = result {
                                let deserializedResponse = try! JSONDecoder().decode(HTTPBin.self,
                                                                                     from: responseData)
                                
                                expect(deserializedResponse.url).to.equal("https://httpbin.org/get")
                            } else {
                                failSpec()
                            }
                                                        
                            complete()
                        }
                    }
                }
            }
            
            describe("executing download tasks") {
                beforeEach {
                    var urlComponents = URLComponents(string: "https://httpbin.org")!
                    urlComponents.path = "/image/jpeg"
                    
                    urlRequest = URLRequest(url: urlComponents.url!)
                }
                
                it("completes with url to downloaded image") {
                    hangOn(for: .seconds(5)) { complete in
                        subject.executeDownload(urlRequest: urlRequest,
                                                customFilename: "animal.jpeg",
                                                directory: Directory(.caches(additionalPath: "session-downloadz/"))) { result in
                            if case .success(let url) = result {
                                guard let data = try? Data(contentsOf: url) else {
                                    failSpec()
                                    
                                    return
                                }
                                
                                expect(data.count).to.beGreaterThan(0)
                            } else { failSpec() }
                            
                            complete()
                        }
                    }
                }
            }
            
            describe("executing upload tasks") {
                var body: Data!
                
                beforeEach {
                    var urlComponents = URLComponents(string: "https://httpbin.org")!
                    urlComponents.path = "/post"
                    
                    urlRequest = URLRequest(url: urlComponents.url!)
                    urlRequest.httpMethod = HTTPMethod.post.rawValue
                    
                    let boundary = "Boundary-\(UUID().uuidString)"
                    
                    urlRequest.setValue("multipart/form-data; boundary=\(boundary)",
                                        forHTTPHeaderField: "Content-Type")
                    
                    
                    let fileURL = testBundle.url(forResource: "file", 
                                                 withExtension: "json")!
                    
                    body = Data()
                    
                    let fileData = try! Data(contentsOf: fileURL)
                    
                    body.append("--\(boundary)\r\n".data(using: .utf8)!)
                    body.append("Content-Disposition: form-data; name=\"file\"; filename=\"text.txt\"\r\n".data(using: .utf8)!)
                    body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
                    body.append(fileData)
                    body.append("\r\n".data(using: .utf8)!)
                    body.append("--\(boundary)--\r\n".data(using: .utf8)!)
                }
                
                it("completes successfully") {
                    hangOn(for: .seconds(5)) { complete in
                        subject.executeUpload(urlRequest: urlRequest, 
                                              data: body) { result in
                            if case .success(let responseData) = result {
                                let deserializedResponse = try! JSONDecoder().decode(HTTPBin.self,
                                                                                     from: responseData)
                                
                                expect(deserializedResponse.url).to.equal("https://httpbin.org/post")
                                expect(deserializedResponse.files!.file).to.contain("Flipper")
                            } else {
                                failSpec()
                            }
                                                        
                            complete()
                        }
                    }
                }
            }
        }
    }
}
