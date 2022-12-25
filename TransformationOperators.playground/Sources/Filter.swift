import Combine
import Foundation

public func filters() {
    //MARK: - Filter
    func isPar(_ number: Int) -> Bool { number % 2 == 0 }
    let publisherNumbers = (0...20)
        .publisher
        .filter(isPar)
        .sink { print($0) }
    /*
     RESULT:
     0
     2
     4
     6
     8
     10
     12
     14
     16
     18
     20
     */
    
    
    //MARK: - Remove duplicates
    ["A", "A", "B", "C", "C", "C", "C", "C"]
        .publisher
        .removeDuplicates()
        .sink { print($0) }
    
    /*
     RESULT:
     A
     B
     C
     */
    
    let words = "apple apple fruit apple mango watermelon apple mango mango apple"
    let wordsPublisher = words.components(separatedBy: " ").publisher
    wordsPublisher.sink { print($0, terminator: ", ") }
    
    /*RESULTS:
     apple, apple, fruit, apple, mango, watermelon, apple, mango, mango, apple,
     */
    
    print()
    
    wordsPublisher.removeDuplicates().sink { print($0, terminator: ", ") }
    /*RESULTS:
     apple, fruit, apple, mango, watermelon, apple, mango, apple,
     */
    
    /*
     ONLY REMOVE CONSECULTIVE SAME VALUE SENDED
     */
    
    //MARK: - Compact MAP
    
    let stringsPublisher = ["2.1", "a", "b", "123", "3.34"]
        .publisher
        .compactMap(Float.init)
        .sink { print($0) }
    /*RESULTS:
     ONLY NON NIL AND HAS BEEN UNWRAPPED
     2.1
     123.0
     3.34
     */
    
    //MARK: - Ignore Output
    (0...10).publisher
        .ignoreOutput()
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { print($0) }
        )
    /*RESULTS:
     NO WILL EXECUTE `receiveValue` for any value published, only preforms
     the `receiveCompletion` once at the final
     
     finished
     */
    
    //MARK: - First
    (0...12)
        .publisher
        .first()
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { print($0) }
        )
    /*RESULTS:
     0
     finished
     */
    
    (1...12)
        .publisher
        .first { $0 % 2 == 0 }
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { print($0) }
        )
    /*RESULTS:
     2
     finished
     */
    
    //MARK: - LAST
    (0...13)
        .publisher
        .last()
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { print($0) }
        )
    /*RESULTS:
     13
     finished
     */
    
    (1...12)
        .publisher
        .last { $0 % 3 == 0 }
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { print($0) }
        )
    /*RESULTS:
     12
     finished
     */
    
    //MARK: - DROP
    (1...10)
        .publisher
        .dropFirst(3) //Ignore the 3 firts emitions
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { print($0) }
        )
    /*RESULTS:
     4
     5
     6
     7
     8
     9
     10
     finished
     */
    
    
    (1...10)
        .publisher
        .drop(while: { $0 % 3 != 0 })
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { print($0) }
        )
    /*RESULTS:
     3
     4
     5
     6
     7
     8
     9
     10
     finished
     */
    
    let isReady = PassthroughSubject<Void, Never>()
    let number = PassthroughSubject<Int, Never>()
    
    number
        .drop(untilOutputFrom: isReady)
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { print($0) }
        )
    
    (0...20).forEach { n in
        number.send(n)
        
        if n == 3 {
            isReady.send()
        }
    }
    /*RESULTS:
     4
     5
     6
     7
     8
     9
     10
     11
     12
     13
     14
     15
     16
     17
     18
     19
     20
     */
    
    //MARK: - Prefix
    let ns = (1...10).publisher
    
    ns.prefix(5).sink( receiveCompletion: { print($0) }, receiveValue: { print($0) })
    /*RESULTS:
     1
     2
     3
     4
     finished
     */
    
    ns.prefix(while: { $0 < 2 }).sink( receiveCompletion: { print($0) }, receiveValue: { print($0) })
    /*RESULTS:
     1
     finished
     */
    
    ns.prefix(while: { $0 > 5 }).sink( receiveCompletion: { print($0) }, receiveValue: { print($0) })
    /*RESULTS:
     finished
     */
    
    //MARK: - CHALLENGE
    (1...100).publisher
        .dropFirst(50)
        .prefix(20)
        .filter { $0 % 2 == 0 }
        .sink { print($0) }
    /*
     RESULT:
     52
     54
     56
     58
     60
     62
     64
     66
     68
     70
     */
    
}
