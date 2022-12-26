import Combine
import Foundation

public func runTransformations() {
    //MARK: - PURE
    ["A", "B", "C", "D"].publisher.sink { print($0) }
    /*
     RESULT:
     A
     B
     C
     D
     */
    
    //MARK: - COLLECT
    ["A", "B", "C", "D"].publisher.collect().sink { print($0) }
    /*
     RESULT:
     ["A", "B", "C", "D"]
     */
    
    ["A", "B", "C", "D"].publisher.collect(2).sink { print($0) }
    /*
     RESULT:
     ["A", "B"]
     ["C", "D"]
     */
    
    ["A", "B", "C", "D"].publisher.collect(3).sink { print($0) }
    /*
     RESULT:
     ["A", "B", "C"]
     ["D"]
     */
    
    ["A", "B", "C", "D"].publisher.collect(4).sink { print($0) }
    /*
     RESULT:
     ["A", "B", "C", "D"]
     */
    
    //MARK: - MAP
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    [123, 10, 99, 149820]
        .publisher
        .map { formatter.string(from: NSNumber(integerLiteral: $0))! }
        .sink { print($0) }
    /*
     RESULT:
     one hundred twenty-three
     ten
     ninety-nine
     one hundred forty-nine thousand eight hundred twenty
     */
    
    formatter.numberStyle = .spellOut
    formatter.locale = Locale(identifier: "pt-BR")
    [123, 10, 99, 149820]
        .publisher
        .map { formatter.string(from: NSNumber(integerLiteral: $0))! }
        .sink { print($0) }
    /*
     RESULT:
     cento e vinte e três
     dez
     noventa e nove
     cento e quarenta e nove mil oitocentos e vinte
     */
    
    //MARK: - Replace Nil
    ["A", "B", nil, "C", nil, "D"].publisher
        .replaceNil(with: "NONE")
        .sink { print($0) }
    /*
     RESULT:
     Optional("A")
     Optional("B")
     Optional("NONE")
     Optional("C")
     Optional("NONE")
     Optional("D")
     */
    
    
    ["A", "B", nil, "C", nil, "D"].publisher
        .replaceNil(with: "NONE")
        .compactMap { $0 }
        .sink { print($0) }
    /*
     RESULT:
     A
     B
     NONE
     C
     NONE
     D
     */
    
    ["A", "B", nil, "C", nil, "D"].publisher
        .compactMap { $0 }
        .sink { print($0) }
    /*
     RESULT:
     A
     B
     C
     D
     */
    
    //MARK: - Empty
    let empty = Empty<Int, Never>()
    empty
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { print($0) }
        )
    /*
     RESULT:
     receiveCompletion sends: finished
     */
    
    let newEmpty = Empty<Int, Never>()
    newEmpty
        .replaceEmpty(with: 32)
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { print($0) }
        )
    /*
     RESULT:
     receiveCompletion sends:
     32
     finished
     */
    
    //MARK: - Scan
    let publisher = (1...10).publisher
    publisher.scan([]) { storeNumbers, value -> [Int] in
        storeNumbers + [value]
    }.sink {
        print($0)
    }
    /*
     RESULT:
     [1]
     [1, 2]
     [1, 2, 3]
     [1, 2, 3, 4]
     [1, 2, 3, 4, 5]
     [1, 2, 3, 4, 5, 6]
     [1, 2, 3, 4, 5, 6, 7]
     [1, 2, 3, 4, 5, 6, 7, 8]
     [1, 2, 3, 4, 5, 6, 7, 8, 9]
     [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
     */
}
