import UIKit

//Challenge #1
extension String {
    func withPrefix(_ string: String) -> String {
        if self.contains(string) {
            return self
        } else {
            return string + self
        }
    }
}

var testWord = "pet"
testWord.withPrefix("car")


//Challenge #2
extension String {
    func isNumeric() -> Bool {
        
        for letter in self {
            if Double(String(letter)) != nil {
                print(letter)
                return true
            } else {
        continue
        }
    }
        return false
}
}

let testWordWithNumber2 = "T4lor"
testWordWithNumber2.isNumeric()


//Challenge #3
extension String {
    func addLines() -> [String] {
        var result = [String]()
        let components = self.split(separator: "\n")
        for item in components {
            result.append(String(item))
        }
        return result
    }
}

let linesTest = "this\nis\na\ntes4"
linesTest.addLines()

for letter in linesTest {
    print(Double(String(letter)))
}










