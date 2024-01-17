import Foundation

struct DolphinData: Codable, Equatable {
    var data: [Dolphin]
}

struct Dolphin: Codable, Equatable {
    var name: String
    var favoriteToy: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case favoriteToy = "favorite-toy"
    }
}

struct Quote: Codable {
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case content = "q"
    }
}

struct HTTPBin: Codable {
    let files: File?
    let url: String
}

struct File: Codable {
    let file: String?
}
