import Foundation
@testable import Utensils

struct GeneratorUtils {
    static let jsonCodableDictionary: [String: JSONCodable] = [
        "favorite-cucumber": nil,
        "uh-oh": "null",
        "double-uh-oh": "<null>",
        "name": "some-jsons",
        "lucky": 777,
        "gpa": 4.0,
        "almost-an-a+": 99.99,
        "loves-tacos": true,
        "burrito": [
            "carne": "asada",
            "arroz": "spanish",
            "salsa": "rojo",
            "frijoles": "pinto"
        ],
        "dog": [
            "name": "maya",
            "age": 3,
            "breed": ["chihuahua", "miniature-pinscher"],
            "loves-dog-food": false
        ],
        "hobbies": ["bjj", "double-dragon", "drums"],
        "numbers": ["uno", 2, 3.5]
    ]
    
    static let jsonCodableDictionaryString: String = """
    {
        "favorite-cucumber": null,
        "uh-oh": "null",
        "double-uh-oh": "<null>",
        "name": "some-jsons",
        "lucky": 777,
        "gpa": 4.0,
        "almost-an-a+": 99.99,
        "loves-tacos": true,
        "burrito": {
            "carne": "asada",
            "arroz": "spanish",
            "salsa": "rojo",
            "frijoles": "pinto"
        },
        "dog": {
            "name": "maya",
            "age": 3,
            "breed": ["chihuahua", "miniature-pinscher"],
            "loves-dog-food": false
        },
        "hobbies": ["bjj", "double-dragon", "drums"],
        "numbers": ["uno", 2, 3.5]
    }
    """
    
    static let jsonCodableDictionaryData = jsonCodableDictionaryString.data(using: .utf8)!
}
