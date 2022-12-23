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
        let subscriber = StringSubscriber()
        let publisher = ["A", "B", "C", "D"].publisher
        publisher.subscribe(subscriber)
    }
}
