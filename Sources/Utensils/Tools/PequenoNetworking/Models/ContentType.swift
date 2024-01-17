//MIT License
//
//Copyright (c) 2020-2024 Ryan Baumbach <github@ryan.codes>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

import Foundation

public enum ContentType: String, CaseIterable, Equatable {
    // MARK: - Text
    
    case plain = "text/plain"
    case html  = "text/html"
    
    // MARK: - Application
    
    case json        = "application/json"
    case octetStream = "application/octet-stream"
    case xml         = "application/xml"
    case formData    = "application/x-www-form-urlencoded"
    case zip         = "application/zip"
    case tar         = "application/x-tar"
    case gzip        = "application/gzip"
    case javaScript  = "application/javascript"
    case pdf         = "application/pdf"
    
    // MARK: - Image
    
    case jpeg     = "image/jpeg"
    case jpeg2000 = "image/jp2"
    case png      = "image/png"
    case gif      = "image/gif"
    case bmp      = "image/bmp"
    case tiff     = "image/tiff"
    case webp     = "image/webp"
    case svg      = "image/svg+xml"
    case ico      = "image/x-icon"
    case heif     = "image/heif"
    case avif     = "image/avif"
    case xbm      = "image/x-xbitmap"
    case xpm      = "image/x-xpixmap"
    case icns     = "image/icns"
    case hdr      = "image/vnd.radiance"
    
    // MARK: - Video
    
    case mp4       = "video/mp4"
    case webm      = "video/webm"
    case ogg       = "video/ogg"
    case quickTime = "video/quicktime"
    case mkv       = "video/x-matroska"
    case avi       = "video/x-msvideo"
    
    var headerKey: String {
        return "Content-Type"
    }
    
    var headerKeyValue: String {
        return self.rawValue
    }
}
