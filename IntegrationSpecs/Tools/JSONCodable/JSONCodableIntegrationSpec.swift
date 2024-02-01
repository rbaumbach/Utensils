import Quick
import Moocher
import Capsule
@testable import Utensils

final class JSONCodableIntegrationSpec: QuickSpec {
    override class func spec() {
        describe("JSONCodable") {
            describe("Using it") {
                var jsonDictionary: [String: JSONCodable]!
                
                beforeEach {
                    jsonDictionary = GeneratorUtils.jsonDictionary
                }
                
                it("handles nil types properly") {
                    // Note: nil is represented as () or Void
                    
                    let nilValue = jsonDictionary["favorite-cucumber"]?.anyValue
                    
                    guard let nilValue = nilValue as? () else {
                        failSpec()
                        
                        return
                    }
                    
                    expect(nilValue == ()).to.beTruthy()

                    // TODO: Fix implementation to handle "null" and "<null>" strings
                    // that I've seen in the api wild
                    
//                    let nullValue = jsonDictionary["uh-oh"]?.anyValue
//                    
//                    guard let nullValue = nullValue as? () else {
//                        failSpec()
//                        
//                        return
//                    }
//                    
//                    expect(nullValue == ()).to.beTruthy()
                }
                
                it("handles strings properly") {
                    let string = jsonDictionary["name"]?.anyValue
                    
                    expect(string as? String).to.equal("some-jsons")
                }
                
                it("handles ints properly") {
                    let int = jsonDictionary["lucky"]?.anyValue
                    
                    expect(int as? Int).to.equal(777)
                }
                
                it("handles doubles properly") {
                    let double = jsonDictionary["almost-an-a+"]?.anyValue
                    
                    expect(double as? Double).to.equal(99.99, within: 0.01)
                }
                
                it("handles bools properly") {
                    let bool = jsonDictionary["loves-tacos"]?.anyValue
                    
                    expect(bool as? Bool).to.beTruthy()
                }
                
                it("handles dictionaries properly") {
                    let burritoDictionary = jsonDictionary["burrito"]?.anyValue as? [String: String]
                    
                    expect(burritoDictionary?["carne"]).to.equal("asada")
                    expect(burritoDictionary?["arroz"]).to.equal("spanish")
                    expect(burritoDictionary?["salsa"]).to.equal("rojo")
                    expect(burritoDictionary?["frijoles"]).to.equal("pinto")
                }
                
                describe("dictionaries") {
                    it("handles values of same type properly") {
                        let burritoDictionary = jsonDictionary["burrito"]?.anyValue as? [String: String]
                        
                        expect(burritoDictionary?["carne"]).to.equal("asada")
                        expect(burritoDictionary?["arroz"]).to.equal("spanish")
                        expect(burritoDictionary?["salsa"]).to.equal("rojo")
                        expect(burritoDictionary?["frijoles"]).to.equal("pinto")
                    }
                    
                    it("handles values of different types properly") {
                        let dogDictionary = jsonDictionary["dog"]?.anyValue as? [String: Any]
                        
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
                        let array = jsonDictionary["hobbies"]?.anyValue as? [String]
                        
                        expect(array?[0]).to.equal("bjj")
                        expect(array?[1]).to.equal("double-dragon")
                        expect(array?[2]).to.equal("drums")
                    }
                    
                    it("handles values of different types properly") {
                        let anyArray = jsonDictionary["numbers"]?.anyValue as? [Any]
                        
                        expect(anyArray?[0] as? String).to.equal("uno")
                        expect(anyArray?[1] as? Int).to.equal(2)
                        expect(anyArray?[2] as? Double).to.equal(3.0, within: 0.1)
                    }
                }
            }
            
            describe("Encodable") {
                
            }
            
            describe("Decodable") {
                
            }
        }
    }
}
