import UIKit
import Combine

final class StringSubscriber: Subscriber {
    
    typealias Input = String
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        print("Receive subscription for `\(subscription)`")
        
        //If you want can to limit the number of requests recieved
        subscription.request(.max(3))
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
        print("Recieve inputed value: \(input)")
        
        /*
         User `.none` quando quiser expecificar o maximo de de eventos
         recebidos (requests) pode ser, case constratio use `.unlimited`,
         que ai ele ignorará a quantidade configurada
         no `receive(subscription: Subscription)`
         */
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("Completed")
        //Dont need to do nothing
    }
}

final class PublisherViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //subscribeWithListPublished()
        subscribeUsingCustomSubscriptionWithPassthroughSubject()
    }
    
    private func subscribeWithListPublished() {
        let subscriber = StringSubscriber()
        let publisher = ["A", "B", "C", "D"].publisher
        publisher.subscribe(subscriber)
    }
    
    private func subscribeUsingCustomSubscriptionWithPassthroughSubject() {
        let subscriber = OtherStringSubscriber()
        
        let subject = PassthroughSubject<String, CustomError>()
        subject.subscribe(subscriber)
        
        let subscription = subject.sink { completion in
            print("Completed with: \(completion)")
        } receiveValue: { recievedValue in
            print("Recieved: \(recievedValue)")
        }

        
        subject.send("A")
        subject.send("B")
        subject.send("C")
        subject.send("D")
        
        subscription.cancel()
        
        subject.send("E")
    }
}

final class OtherStringSubscriber: Subscriber {
    
    func receive(subscription: Subscription) {
        print("Receive subscription for `\(subscription)`")
        
        //If you want can to limit the number of requests recieved
        subscription.request(.max(2))
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
        print("Recieve inputed value: \(input)")
        
        /*
         User `.none` quando quiser expecificar o maximo de de eventos
         recebidos (requests) pode ser, case constratio use `.unlimited`,
         que ai ele ignorará a quantidade configurada
         no `receive(subscription: Subscription)`
         */
        return .max(1)
    }
    
    func receive(completion: Subscribers.Completion<CustomError>) {
        print("Completed")
        //Dont need to do nothing
    }
}

enum CustomError: Error {
    case badRequest
}
