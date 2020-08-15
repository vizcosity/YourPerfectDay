import UIKit

var str = "Hello, playground"

let stringDate = "2020-03-12"

let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "YYYY-mm-dd"

dateFormatter.date(from: stringDate)
print(stringDate)

let values = [1, 5, 3, 7, 9, 23, 31, 4]

// If the first should come before second, then return true, otherwise, return false.
print(values.sorted(by: { (first, second) -> Bool in
    return first < second
}))
