import Quick
import Moocher
@testable import Utensils

final class ContentTypeSpec: QuickSpec {
    override class func spec() {
        describe("ContentType") {
            it("has proper raw values") {
                // Text
                
                expect(ContentType.plain.rawValue).to.equal("text/plain")
                expect(ContentType.html.rawValue).to.equal("text/html")
                
                // Application
                
                expect(ContentType.json.rawValue).to.equal("application/json")
                expect(ContentType.octetStream.rawValue).to.equal("application/octet-stream")
                expect(ContentType.xml.rawValue).to.equal("application/xml")
                expect(ContentType.formData.rawValue).to.equal("application/x-www-form-urlencoded")
                expect(ContentType.zip.rawValue).to.equal("application/zip")
                expect(ContentType.tar.rawValue).to.equal("application/x-tar")
                expect(ContentType.gzip.rawValue).to.equal("application/gzip")
                expect(ContentType.javaScript.rawValue).to.equal("application/javascript")
                expect(ContentType.pdf.rawValue).to.equal("application/pdf")
                
                // Image
                
                expect(ContentType.jpeg.rawValue).to.equal("image/jpeg")
                expect(ContentType.jpeg2000.rawValue).to.equal("image/jp2")
                expect(ContentType.png.rawValue).to.equal("image/png")
                expect(ContentType.gif.rawValue).to.equal("image/gif")
                expect(ContentType.bmp.rawValue).to.equal("image/bmp")
                expect(ContentType.tiff.rawValue).to.equal("image/tiff")
                expect(ContentType.webp.rawValue).to.equal("image/webp")
                expect(ContentType.svg.rawValue).to.equal("image/svg+xml")
                expect(ContentType.ico.rawValue).to.equal("image/x-icon")
                expect(ContentType.heif.rawValue).to.equal("image/heif")
                expect(ContentType.avif.rawValue).to.equal("image/avif")
                expect(ContentType.xbm.rawValue).to.equal("image/x-xbitmap")
                expect(ContentType.xpm.rawValue).to.equal("image/x-xpixmap")
                expect(ContentType.icns.rawValue).to.equal("image/icns")
                expect(ContentType.hdr.rawValue).to.equal("image/vnd.radiance")
                
                // Video
                
                expect(ContentType.mp4.rawValue).to.equal("video/mp4")
                expect(ContentType.webm.rawValue).to.equal("video/webm")
                expect(ContentType.ogg.rawValue).to.equal("video/ogg")
                expect(ContentType.quickTime.rawValue).to.equal("video/quicktime")
                expect(ContentType.mkv.rawValue).to.equal("video/x-matroska")
                expect(ContentType.avi.rawValue).to.equal("video/x-msvideo")
            }
            
            describe("headerKey") {
                it("is always 'Content-Type'") {
                    expect(ContentType.json.headerKey).to.equal("Content-Type")
                }
            }
            
            describe("headerValue") {
                it("is the rawValue") {
                    expect(ContentType.json.headerKeyValue).to.equal(ContentType.json.rawValue)
                }
            }
            
            describe("<CaseIterable>)") {
                it("has all required cases") {
                    let expectedCases: [ContentType] = [
                        .plain, .html,
                        .json, .octetStream, .xml, .formData, .zip, .tar, .gzip, .javaScript, .pdf,
                        .jpeg, .jpeg2000, .png, .gif, .bmp, .tiff, .webp, .svg, .ico, .heif, .avif,
                        .xbm, .xpm, .icns, .hdr,
                        .mp4, .webm, .ogg, .quickTime, .mkv, .avi
                    ]
                    
                    expect(ContentType.allCases).to.equal(expectedCases)
                }
            }

            describe("<Equatable") {
                it("is equatable") {
                    expect(ContentType.plain).to.equal(ContentType.plain)
                    expect(ContentType.plain).toNot.equal(ContentType.jpeg)
                }
            }
        }
    }
}
