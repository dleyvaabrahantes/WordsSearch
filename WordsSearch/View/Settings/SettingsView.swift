//
//  SettingsView.swift
//  AppointmentDay
//
//  Created by David on 10/13/22.
//

import SwiftUI
import CoreData
import MessageUI

struct SettingsView: View {
    @StateObject var storeVM = StoreVM()
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State var showAlert = false
    @State var showPayment = false
    @State var showShare = false
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    @State var colorScheme: ColorScheme? = nil
    @State var showAppareance: Bool = true
    
    @Environment(\.requestReview) var requestReview
    
    @AppStorage("systemTheme") private var systemTheme: Int = AppareanceMode.allCases.first!.rawValue
    @State var appearanceMode: AppareanceMode = .system
    
    init(){
        _appearanceMode = State(initialValue: AppareanceMode(rawValue: systemTheme) ?? .system)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    Section {
                                        
                        HStack {
                            Image(systemName: "star")
                            Button(action: {
                                requestReview()
                            }, label: {
                                Text(LocalizedStringKey("rate"))
                            })
                           // Link(LocalizedStringKey("rate"), destination: URL(string: "https://apps.apple.com/us/app/smart-list-shopping-tasks/id6503365608")!)
                        }
                      //      .foregroundColor(Color("AboutLetter"))
    //
                        HStack {
                            Image(systemName: "square.and.arrow.up.fill")
                            Button {
                                showShare.toggle()
                            } label: {
                                Text(LocalizedStringKey("share"))
                        }
                        }
                        HStack {
                            Image(systemName: "envelope.fill")
                            Button {
                                if MFMailComposeViewController.canSendMail() {
                                    self.isShowingMailView.toggle()
                                }
                                else {
                                    print("No se puede enviar mail")
                                }
                            } label: {
                                Text(LocalizedStringKey("comments"))
                                    
                        }
                        }
                    }header: {
                        
                        Text(LocalizedStringKey("commentsheader"))
                    } footer: {
                        
                        Text(LocalizedStringKey("opinion"))
                    }
                    Section {
                        HStack {
                            Image(systemName: "globe")
                            Link("Twitter", destination: URL(string: "https://twitter.com/Davidle33516682")!)
                        }
                            
                        HStack {
                            Image(systemName: "globe")
                            Link("Facebook", destination: URL(string: "https://www.facebook.com/david.leyvaabrahantes")!)
                        }
                            
                        HStack {
                            Image(systemName: "globe")
                            Link("Linkedin", destination: URL(string: "http://linkedin.com/in/dla-iosdev")!)
                        }
                            
                        
                    }header: {
                        
                        Text(LocalizedStringKey("follow"))
                    } footer: {
                        
                        Text(LocalizedStringKey("social"))
                    }
                    Section {
                        Button {
                            showPayment.toggle()
                        } label: {
                            Text(LocalizedStringKey("manage"))
                                
                        }
                    }header: {
                        
                        Text(LocalizedStringKey("subscription"))
                    }
                    Section {
                        HStack {
                            Image(systemName: "paintbrush.fill")
                            Button {
                                showAppareance.toggle()
                            } label: {
                                Text(LocalizedStringKey("style"))
                        }
                        }
                        
                        HStack {
                            Image(systemName: "bell")
                            Button {
                             openNotificationSettings()
                            } label: {
                                Text(LocalizedStringKey("notifications"))
                        }
                        }
                    }header: {
                        Text(LocalizedStringKey("general"))
                    }
    //                Section {
    //                    Button {
    //                        showPayment.toggle()
    //                    } label: {
    //                        Text(LocalizedStringKey("subscription"))
    //                            .foregroundColor(Color("AboutLetter"))
    //                    }
    //
    //                }header: {
    //
    //                    Text(LocalizedStringKey("subscriptionTitle"))
    //                }
                    Section {
                        HStack {
                            Image(systemName: "list.bullet")
                            Link(LocalizedStringKey("terms"), destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                        }
                            
                        HStack {
                            Image(systemName: "shield")
                            Link(LocalizedStringKey("privacy"), destination: URL(string: "https://dlatechsolutions.com/privacy.html")!)
                        }
                           
                    
                        HStack {
                            Image(systemName: "info.circle.fill")
                            Text("Version: \(appVersion ?? "")")
                        }
                            
                    
                    }
                    
    //                .sheet(isPresented: $showPayment, content: {
    //                    PaymentWall()
    //                        .environmentObject(iapModel)
    //                })
    //                .foregroundColor(.black)
    //                .navigationTitle("settings")
                }
                .alert(LocalizedStringKey("terms"), isPresented: $showAlert, actions: {
                    // actions
                }, message: {
                    Text(LocalizedStringKey("message"))
                })
                .sheet(isPresented: $isShowingMailView) {
                    MailView(isShowing: self.$isShowingMailView, result: self.$result)
                }
                .sheet(isPresented: $showShare) {
                    ShareView(showShareView: $showShare)
                }
                .foregroundStyle(.primary)
                .sheet(isPresented: $showPayment, content: {
                    GoPremium()
                        .environmentObject(storeVM)
//                    PaywallView()
//                        .environmentObject(storeVM)
                })
            .navigationTitle(LocalizedStringKey("settings"))
                DLMOde(colorScheme: $colorScheme, showAppareance: $showAppareance, appearanceMode: $appearanceMode)
                    .ignoresSafeArea()
            }
        }
    }
    
    private func openNotificationSettings() {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
