import Combine
import Foundation

//MARK: - Prepend
let numbersPublishers = (0...10).publisher
let otherPublisher = (500...510).publisher

numbersPublishers
    .prepend(31)
    .prepend(12, 32)
    .prepend([92, 55])
    .prepend(otherPublisher)
    .sink { print($0) }
/*
 RESULT:
 500
 501
 502
 503
 504
 505
 506
 507
 508
 509
 510
 92
 55
 12
 32
 31
 0
 1
 2
 3
 4
 5
 6
 7
 8
 9
 10
 */

//MARK: - Append
let nPublishers = (0...10).publisher
let oPublisher = (500...510).publisher

nPublishers
    .append(31)
    .append(12, 32)
    .append([92, 55])
    .append(oPublisher)
    .sink { print($0) }
/*
 RESULT:
 0
 1
 2
 3
 4
 5
 6
 7
 8
 9
 10
 31
 12
 32
 92
 55
 500
 501
 502
 503
 504
 505
 506
 507
 508
 509
 510
 */

//MARK: - SwitchToLatest
let p1 = PassthroughSubject<String, Never>()
let p2 = PassthroughSubject<String, Never>()
let publishers = PassthroughSubject<PassthroughSubject<String, Never>, Never>()

publishers.switchToLatest().sink { print($0) }

p1.send("Publisher 1 - Value 1")

publishers.send(p1)
p1.send("Publisher 1 - Value 2")
p1.send("Publisher 1 - Value 3")

p2.send("Publisher 2 - Value 1")

publishers.send(p2)
p2.send("Publisher 2 - Value 2")
p2.send("Publisher 2 - Value 3")
/*
 RESULT:
 Publisher 1 - Value 2
 Publisher 1 - Value 3
 Publisher 2 - Value 2
 Publisher 2 - Value 3
 */

let images = ["Houston", "Denver", "Seatle"]
let pub = PassthroughSubject<Void, Never>()
var index = 0

func getName() -> AnyPublisher<String, Never> {
    Future { promise in
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            promise(.success(images[index]))
        }
    }
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
}

let subscription = pub.map { _ in getName() }
    .switchToLatest()
    .sink { print($0) }


pub.send()

DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
    index += 1
    pub.send()
}

DispatchQueue.global().asyncAfter(deadline: .now() + 7) {
    index += 1
    pub.send()
}

//MARK: - Merge
let pubs1 = PassthroughSubject<Int, Never>()
let pubs2 = PassthroughSubject<Int, Never>()

pubs1.merge(with: pubs2).sink { print($0) }

pubs1.send(1)
pubs1.send(2)

pubs2.send(3)
pubs2.send(4)

pubs1.send(1)
/*
 RESULT:
 1
 2
 3
 4
 1
 */

//MARK: - Zip + Combine
let o1 = PassthroughSubject<Int, Never>()
let o2 = PassthroughSubject<String, Never>()

o1.combineLatest(o2).sink { o1Recieved, o2Recieved in
    print("COMBINE: O1: \(o1Recieved) | O2: \(o2Recieved)")
}

o1.zip(o2).sink { o1Recieved, o2Recieved in
    print("ZIP: O1: \(o1Recieved) | O2: \(o2Recieved)")
}

o1.send(1)
o1.send(2)
o2.send("01")
o2.send("02")
o2.send("03")
o2.send("04")
o1.send(3)

/*
 ZIP: O1: 1 | O2: 01
 COMBINE: O1: 2 | O2: 01
 ZIP: O1: 2 | O2: 02
 COMBINE: O1: 2 | O2: 02
 COMBINE: O1: 2 | O2: 03
 COMBINE: O1: 2 | O2: 04
 COMBINE: O1: 3 | O2: 04
 ZIP: O1: 3 | O2: 03
 */
