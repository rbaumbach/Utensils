import Foundation

final class TestValueWrapper<T> {
    var value: T?
    
    init(value: T? = nil) {
        self.value = value
    }
}
