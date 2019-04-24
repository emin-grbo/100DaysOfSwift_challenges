import UIKit

// Challenge #1
extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
            //self?.transform = CGAffineTransform(rotationAngle: 50.0)
            //self?.backgroundColor = .blue
        }
    }
}
// Testing challenge #1 in app.



// Challenge #2
extension Int {
    func times(doTheThing: ()-> Void) {
        if self > 0 {
        for _ in 1...self where self > 0 {
            doTheThing()
        }
        }
    }
}
// Testing challenge 2
6.times {
    print("Testing")
}



// Challenge #3
extension Array where Element: Comparable {
    mutating func removeFirstOccurenceOf(item: Element) {
        if let index = self.firstIndex(of: item){
            self.remove(at: index)
        }
    }
}
// Testing challenge #3
var testArray = ["element1", "element2", "element3"]
testArray.removeFirstOccurenceOf(item: "element2")
print(testArray)
