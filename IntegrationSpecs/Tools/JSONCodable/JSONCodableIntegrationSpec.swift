import Quick
import Moocher
import Capsule
@testable import Utensils

final class JSONCodableIntegrationSpec: QuickSpec {
    override class func spec() {
        describe("JSONCodable") {
            // Note: While these tests are redudant with the Encodable/Decodable ones
            // I used these to test drive my implemenation. I am keeping them here
            // for future documentation reference
            
            describe("Using it") {
                var jsonCodableDictionary: [String: JSONCodable]!
                
                beforeEach {
                    jsonCodableDictionary = GeneratorUtils.jsonCodableDictionary
                }
                
                it("handles nil types properly") {
                    // Note: nil is represented as () or Void
                    
                    let nilValue = jsonCodableDictionary["favorite-cucumber"]?.anyValue
                    
                    guard let nilValue = nilValue as? () else {
                        failSpec()
                        
                        return
                    }
                    
                    expect(nilValue == ()).to.beTruthy()
                }
                
                it("handles strings properly") {
                    let string = jsonCodableDictionary["name"]?.anyValue
                    
                    expect(string as? String).to.equal("some-jsons")
                }
                
                it("handles ints properly") {
                    let int = jsonCodableDictionary["lucky"]?.anyValue
                    
                    expect(int as? Int).to.equal(777)
                }
                
                it("handles doubles properly") {
                    let double = jsonCodableDictionary["almost-an-a+"]?.anyValue
                    
                    expect(double as? Double).to.equal(99.99, within: 0.01)
                }
                
                it("handles bools properly") {
                    let bool = jsonCodableDictionary["loves-tacos"]?.anyValue
                    
                    expect(bool as? Bool).to.beTruthy()
                }
                
                it("handles dictionaries properly") {
                    let burritoDictionary = jsonCodableDictionary["burrito"]?.anyValue as? [String: String]
                    
                    expect(burritoDictionary?["carne"]).to.equal("asada")
                    expect(burritoDictionary?["arroz"]).to.equal("spanish")
                    expect(burritoDictionary?["salsa"]).to.equal("rojo")
                    expect(burritoDictionary?["frijoles"]).to.equal("pinto")
                }
                
                describe("dictionaries") {
                    it("handles values of same type properly") {
                        let burritoDictionary = jsonCodableDictionary["burrito"]?.anyValue as? [String: String]
                        
                        expect(burritoDictionary?["carne"]).to.equal("asada")
                        expect(burritoDictionary?["arroz"]).to.equal("spanish")
                        expect(burritoDictionary?["salsa"]).to.equal("rojo")
                        expect(burritoDictionary?["frijoles"]).to.equal("pinto")
                    }
                    
                    it("handles values of different types properly") {
                        let dogDictionary = jsonCodableDictionary["dog"]?.anyValue as? [String: Any]
                        
                        expect(dogDictionary?["name"] as? String).to.equal("maya")
                        expect(dogDictionary?["age"] as? Int).to.equal(3)
                        expect(dogDictionary?["loves-dog-food"] as? Bool).to.beFalsy()
                        
                        let breedArray = dogDictionary?["breed"] as? [String]
                        
                        expect(breedArray?[0]).to.equal("chihuahua")
                        expect(breedArray?[1]).to.equal("miniature-pinscher")
                    }
                }
                
                describe("arrays") {
                    it("handles values of same type properly") {
                        let array = jsonCodableDictionary["hobbies"]?.anyValue as? [String]
                        
                        expect(array?[0]).to.equal("bjj")
                        expect(array?[1]).to.equal("double-dragon")
                        expect(array?[2]).to.equal("drums")
                    }
                    
                    it("handles values of different types properly") {
                        let anyArray = jsonCodableDictionary["numbers"]?.anyValue as? [Any]
                        
                        expect(anyArray?[0] as? String).to.equal("uno")
                        expect(anyArray?[1] as? Int).to.equal(2)
                        expect(anyArray?[2] as? Double).to.equal(3.5, within: 0.1)
                    }
                }
            }
            
            describe("Encodable") {
                var encodedJSON: Data!
                
                var expectedEncodedJSON: Data!
                
                it("handles nil properly") {
                    let jsonCodableWithNil: [String: JSONCodable] = [
                        "favorite-cucumber": nil
                    ]
                    
                    encodedJSON = try? JSONEncoder().encode(jsonCodableWithNil)
                                        
                    expectedEncodedJSON = "{\"favorite-cucumber\":null}".data(using: .utf8)
                    
                    expect(encodedJSON).to.equal(expectedEncodedJSON)
                }
                
                it("handles strings properly") {
                    let jsonCodableWithString: [String: JSONCodable] = [
                        "name": "some-jsons"
                    ]
                    
                    encodedJSON = try? JSONEncoder().encode(jsonCodableWithString)
                                        
                    expectedEncodedJSON = "{\"name\":\"some-jsons\"}".data(using: .utf8)
                    
                    expect(encodedJSON).to.equal(expectedEncodedJSON)
                }
                
                it("handles ints properly") {
                    let jsonCodableWithInt: [String: JSONCodable] = [
                        "lucky": 777
                    ]
                    
                    encodedJSON = try? JSONEncoder().encode(jsonCodableWithInt)
                                                            
                    expectedEncodedJSON = "{\"lucky\":777}".data(using: .utf8)
                    
                    expect(encodedJSON).to.equal(expectedEncodedJSON)
                }
                
                // Note: It looks like the encoder treats decimal numers that end with .0 as Ints.
                // Ex: 3.0 encodes as a 3 of type Int, instead of a Double
                
                it("handles doubles properly") {
                    let jsonCodableWithDouble: [String: JSONCodable] = [
                        "almost-an-a+": 99.99
                    ]
                    
                    encodedJSON = try? JSONEncoder().encode(jsonCodableWithDouble)
                                                            
                    expectedEncodedJSON = "{\"almost-an-a+\":99.99}".data(using: .utf8)
                    
                    expect(encodedJSON).to.equal(expectedEncodedJSON)
                }
                
                it("handles booleans properly") {
                    let jsonCodableWithBool: [String: JSONCodable] = [
                        "loves-tacos": true
                    ]
                    
                    encodedJSON = try? JSONEncoder().encode(jsonCodableWithBool)
                                                            
                    expectedEncodedJSON = "{\"loves-tacos\":true}".data(using: .utf8)
                    
                    expect(encodedJSON).to.equal(expectedEncodedJSON)
                }
                
                // Note: Since dictionaries can put things in arbitrary order when encoding the JSON, I will
                // use the decoder to check equality which makes these tests duplicate the decoder tests
                // I am keeping those separate for future documentation reference.
                
                describe("dictionaries") {
                    var decodedJSON: [String: JSONCodable]!
                    
                    it("handles values of same type properly") {
                        let jsonCodableWithDictionary: [String: JSONCodable] = [
                            "burrito": [
                                "carne": "asada",
                                "arroz": "spanish",
                                "salsa": "rojo",
                                "frijoles": "pinto"
                            ]
                        ]
                        
                        encodedJSON = try? JSONEncoder().encode(jsonCodableWithDictionary)
                                                                
                        decodedJSON = try? JSONDecoder().decode([String: JSONCodable].self, 
                                                                from: encodedJSON)
                        
                        let burritoDictionary = decodedJSON["burrito"]?.anyValue as? [String: String]
                                                
                        expect(burritoDictionary?["carne"]).to.equal("asada")
                        expect(burritoDictionary?["arroz"]).to.equal("spanish")
                        expect(burritoDictionary?["salsa"]).to.equal("rojo")
                        expect(burritoDictionary?["frijoles"]).to.equal("pinto")
                    }
                    
                    it("handles values of different types properly") {
                        let jsonCodableWithDictionary: [String: JSONCodable] = [
                            "dog": [
                                "name": "maya",
                                "age": 3,
                                "breed": ["chihuahua", "miniature-pinscher"],
                                "loves-dog-food": false
                            ]
                        ]
                        
                        encodedJSON = try? JSONEncoder().encode(jsonCodableWithDictionary)
                                                                                        
                        decodedJSON = try? JSONDecoder().decode([String: JSONCodable].self,
                                                                from: encodedJSON)
                        
                        let dogDictionary = decodedJSON["dog"]?.anyValue as? [String: Any]
                        
                        expect(dogDictionary?["name"] as? String).to.equal("maya")
                        expect(dogDictionary?["age"] as? Int).to.equal(3)
                        expect(dogDictionary?["loves-dog-food"] as? Bool).to.beFalsy()
                        
                        let breedArray = dogDictionary?["breed"] as? [String]
                        
                        expect(breedArray?[0]).to.equal("chihuahua")
                        expect(breedArray?[1]).to.equal("miniature-pinscher")
                    }
                }
                
                describe("arrays") {
                    it("handles values of same type properly") {
                        let jsonCodableWithArray: [String: JSONCodable] = [
                            "hobbies": ["bjj", "double-dragon", "drums"]
                        ]
                        
                        encodedJSON = try? JSONEncoder().encode(jsonCodableWithArray)
                        
                        expectedEncodedJSON = "{\"hobbies\":[\"bjj\",\"double-dragon\",\"drums\"]}".data(using: .utf8)
                                                
                        expect(encodedJSON).to.equal(expectedEncodedJSON)
                    }
                    
                    it("handles values of different types properly") {
                        let jsonCodableWithArray: [String: JSONCodable] = [
                            "numbers": ["uno", 2, 3.5]
                        ]
                        
                        encodedJSON = try? JSONEncoder().encode(jsonCodableWithArray)
                        
                        expectedEncodedJSON = "{\"numbers\":[\"uno\",2,3.5]}".data(using: .utf8)
                                                
                        expect(encodedJSON).to.equal(expectedEncodedJSON)
                    }
                }
            }
            
            describe("Decodable") {
                var jsonCodableDictionaryData: Data!
                
                var decodedJSON: [String: JSONCodable]!
                
                beforeEach {
                    jsonCodableDictionaryData = GeneratorUtils.jsonCodableDictionaryData
                    
                    decodedJSON = try JSONDecoder().decode([String: JSONCodable].self,
                                                           from: jsonCodableDictionaryData)
                }
                
                it("handles nil types properly") {
                    // Note: nil is represented as () or Void or Optional<T>.none
                    // I handle "null" and "<null>" oddities as well because I've seen
                    // those in the api wild
                    
                    let nilValue = decodedJSON["favorite-cucumber"]?.anyValue
                    
                    guard let nilValue = nilValue as? () else {
                        failSpec()
                        
                        return
                    }
                    
                    expect(nilValue == ()).to.beTruthy()

                    let nullValue = decodedJSON["uh-oh"]?.anyValue

                    guard let nullValue = nullValue as? () else {
                        failSpec()

                        return
                    }

                    expect(nullValue == ()).to.beTruthy()
                    
                    let bracketNullValue = decodedJSON["double-uh-oh"]?.anyValue
                    
                    guard let bracketNullValue = bracketNullValue as? () else {
                        failSpec()
                        
                        return
                    }
                    
                    expect(bracketNullValue == ()).to.beTruthy()
                }
                
                it("handles strings properly") {
                    let string = decodedJSON["name"]?.anyValue
                    
                    expect(string as? String).to.equal("some-jsons")
                }
                
                // Note: It looks like the decoder treats decimal numers that end with .0 as Ints.
                // Ex: 3.0 decodes as a 3 of type Int, instead of a Double
                
                it("handles ints properly") {
                    let int = decodedJSON["lucky"]?.anyValue
                    
                    expect(int as? Int).to.equal(777)
                    
                    let shouldNotBeAnIntButIs = decodedJSON["gpa"]?.anyValue
                    
                    expect(shouldNotBeAnIntButIs as? Int).to.equal(4)
                }
                
                it("handles doubles properly") {
                    let double = decodedJSON["almost-an-a+"]?.anyValue
                    
                    expect(double as? Double).to.equal(99.99, within: 0.01)
                }
                
                it("handles bools properly") {
                    let bool = decodedJSON["loves-tacos"]?.anyValue
                    
                    expect(bool as? Bool).to.beTruthy()
                }
                
                describe("dictionaries") {
                    it("handles values of same type properly") {
                        let burritoDictionary = decodedJSON["burrito"]?.anyValue as? [String: String]
                        
                        expect(burritoDictionary?["carne"]).to.equal("asada")
                        expect(burritoDictionary?["arroz"]).to.equal("spanish")
                        expect(burritoDictionary?["salsa"]).to.equal("rojo")
                        expect(burritoDictionary?["frijoles"]).to.equal("pinto")
                    }
                    
                    it("handles values of different types properly") {
                        let dogDictionary = decodedJSON["dog"]?.anyValue as? [String: Any]
                        
                        expect(dogDictionary?["name"] as? String).to.equal("maya")
                        expect(dogDictionary?["age"] as? Int).to.equal(3)
                        expect(dogDictionary?["loves-dog-food"] as? Bool).to.beFalsy()
                        
                        let breedArray = dogDictionary?["breed"] as? [String]
                        
                        expect(breedArray?[0]).to.equal("chihuahua")
                        expect(breedArray?[1]).to.equal("miniature-pinscher")
                    }
                }
                
                describe("arrays") {
                    it("handles values of same type properly") {
                        let array = decodedJSON["hobbies"]?.anyValue as? [String]
                        
                        expect(array?[0]).to.equal("bjj")
                        expect(array?[1]).to.equal("double-dragon")
                        expect(array?[2]).to.equal("drums")
                    }
                    
                    it("handles values of different types properly") {
                        let anyArray = decodedJSON["numbers"]?.anyValue as? [Any]
                        
                        expect(anyArray?[0] as? String).to.equal("uno")
                        expect(anyArray?[1] as? Int).to.equal(2)

                        expect(anyArray?[2] as? Double).to.equal(3.5, within: 0.1)
                    }
                }
            }
            
            // TODO: Fix equatable to deal with the fact that the ExpressibleByDictionaryLiteral
            // takes an AnyHashable which makes the strings different when string comparing even though
            // the values are the same
            
            describe("Equatable") {
                it("is equatable") {
                    let jsonCodable1 = GeneratorUtils.jsonCodableDictionary
                    
                    let jsonCodable2 = GeneratorUtils.jsonCodableDictionary
                    
                    expect(jsonCodable1).to.equal(jsonCodable2)
                    
                    var jsonCodable3 = GeneratorUtils.jsonCodableDictionary
                    
                    jsonCodable3["junk"] = "garbage"
                    
                    expect(jsonCodable1).toNot.equal(jsonCodable3)
                }
            }
        }
    }
}
