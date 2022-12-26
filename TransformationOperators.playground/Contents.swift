import Combine

//MARK: - Min
(0...3).publisher.min().sink { print($0) }
//0

//MARK: - Max
(0...3).publisher.max().sink { print($0) }
//3

//MARK: - First
["a", "b", "c", "d"].publisher.first().sink { print($0 )} //a

["a", "b", "c", "d"].publisher.first { "but".contains($0) }.sink { print($0) } //b

//MARK: - Last
["a", "b", "c", "d"].publisher.last().sink { print($0 )} //d

//MARK: - Output
(0...10).publisher.output(at: 3).sink { print($0) } //3 (element in third position)

(0...10).publisher.output(in: (2...5)).sink { print($0) }
/*
 2
 3
 4
 5
 */

//MARK: - Count

(0...10).publisher.count().sink { print($0) } //11 (total of performs `send` before completion

let countPublisher = PassthroughSubject<String, Never>()
countPublisher.count().sink { print($0) }

countPublisher.send("a")
countPublisher.send("a")
countPublisher.send("a")
countPublisher.send(completion: .finished)

//3

countPublisher.send("a")
countPublisher.send("a")
//3

countPublisher.send("a")
countPublisher.send(completion: .finished)
//3

//MARK: - Contains
(0...10).publisher.contains(99).sink { print($0) }//False

(0...10).publisher.contains(2).sink { print($0) }//True

//MARK: - AllSatisfy
(0...10).publisher.allSatisfy { $0 <= 10 }.sink { print($0) }//True

(0...12).publisher.allSatisfy { $0 > 10 }.sink { print($0) }//False

//MARK: - Reduce
(0...10).publisher.reduce(0) { accumulate, value in
    print("Accumulate: \(accumulate), value: \(value)")
    return accumulate + value
}.sink {
    print("Total:", $0)
}
/*
 Accumulate: 0, value: 0
 Accumulate: 0, value: 1
 Accumulate: 1, value: 2
 Accumulate: 3, value: 3
 Accumulate: 6, value: 4
 Accumulate: 10, value: 5
 Accumulate: 15, value: 6
 Accumulate: 21, value: 7
 Accumulate: 28, value: 8
 Accumulate: 36, value: 9
 Accumulate: 45, value: 10
 Total: 55
 */
