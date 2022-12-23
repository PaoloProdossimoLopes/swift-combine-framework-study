import UIKit

final class NotificationCenterViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //notifyWithObserver()
        //notifyWithPublisher()
        //notifyWithPublisherCanceledBeforeToEmit()
        notifyWithPublisherCanceledBeforeToEmitAndDoneFunction()
    }
    
    func notifyWithObserver() {
        //Set notification with observer
        let notification = Notification.Name("any_custom_notification")
        let center = NotificationCenter.default
        let observer = center.addObserver(forName: notification, object: nil, queue: nil) { notification in
            print("Recieve a notificaiton equal to \(notification)")
        }
        
        //Emit
        center.post(name: notification, object: nil)
        
        //Remove observer
        center.removeObserver(observer)
    }
    
    func notifyWithPublisher() {
        //Create a publisher for a notification
        let notification = Notification.Name("any_custom_notification")
        let center = NotificationCenter.default
        let publisher = center.publisher(for: notification)
        
        //Subscribe into publisher data
        let subscription = publisher.sink { notification in
            print("Recieve notification equalt o `\(notification)`")
        }
        
        //Emit event to siscribeds
        center.post(name: notification, object: nil)
        
        //Cancel subscrition (if you dont cancel subsvription you will receieved new events in the future)
        subscription.cancel()
    }
    
    func notifyWithPublisherCanceledBeforeToEmit() {
        //Create a publisher for a notification
        let notification = Notification.Name("any_custom_notification")
        let center = NotificationCenter.default
        let publisher = center.publisher(for: notification)
        
        //Subscribe into publisher data
        let subscription = publisher.sink { notification in
            print("Recieve notification equalt o `\(notification)`")
        }
        
        //Cancel subscrition (if you dont cancel subsvription you will receieved new events in the future)
        subscription.cancel()
        
        //Emit event to siscribeds
        center.post(name: notification, object: nil)
        
        //In this case the subscription before to emit, its result in no received values into subcription
    }
    
    func notifyWithPublisherCanceledBeforeToEmitAndDoneFunction() {
        //Create a publisher for a notification
        let notification = Notification.Name("any_custom_notification")
        let center = NotificationCenter.default
        let publisher = center.publisher(for: notification)
        
        //Subscribe into publisher data
        let subscription = publisher
            .handleEvents(receiveCancel: {
                print("canceled")
            })
            .sink { notification in
            print("Recieve notification equalt o `\(notification)`")
        }
        
        //Emit event to siscribeds
        center.post(name: notification, object: nil)
        
    }
}
