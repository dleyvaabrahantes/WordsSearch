import Foundation
import SwiftUI
import MessageUI


struct MailView: UIViewControllerRepresentable {
    
    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    let iOSVersion = UIDevice.current.systemVersion
    let iOSDevice = UIDevice.modelName
    
    let emailTitle = "About WordSearch !!!"
    let toRecipit = ["iosdladev2021@gmail.com"]
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, Error>?
        
        init(isShowing: Binding<Bool>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _isShowing = isShowing
            _result = result
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                isShowing = false
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing,
                           result: $result)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setSubject(emailTitle)
        vc.setMessageBody("\n \n \n Version app \(appVersion!) \n Version iOS \(iOSVersion) \n Dispositivo \(iOSDevice)", isHTML: false)
        vc.setToRecipients(toRecipit)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {
        
    }
}
