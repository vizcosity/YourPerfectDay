import UIKit

var str = "Hello, playground"

let stringDate = "2020-03-12"

let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "YYYY-mm-dd"

dateFormatter.date(from: stringDate)
print(stringDate)
