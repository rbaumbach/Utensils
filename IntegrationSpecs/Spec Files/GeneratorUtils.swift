import Foundation
@testable import Utensils

struct GeneratorUtils {
    static let jsonDictionary: [String: JSONCodable] = [
        "favorite-cucumber": nil,
        "uh-oh": "null",
        "double-uh-oh": "<null>",
        "name": "some-jsons",
        "lucky": 777,
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
        "numbers": ["uno", 2, 3.0]
    ]
    
    static let jsonDictionaryString: String = """
    {
        "favorite-cucumber": null,
        "uh-oh": "null",
        "double-uh-oh": "<null>",
        "name": "some-jsons",
        "lucky": 777,
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
            "breed": ["chihuahua": "miniature-pinscher"],
            "loves-dog-food": false
        },
        "hobbies": ["bjj", "double-dragon", "drums"],
        "numbers": ["uno", 2, 3.0]
    }
    """
}
