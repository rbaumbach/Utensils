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

//    {
//        "q": "Lack of emotion causes lack of progress and lack of motivation.",
//        "a": "Tony Robbins",
//        "i": "https://zenquotes.io/img/tony-robbins.jpg",
//        "c": "63",
//        "h": "<blockquote>&ldquo;Lack of emotion causes lack of progress and lack of motivation.&rdquo; &mdash; <footer>Tony Robbins</footer></blockquote>"
//    }
