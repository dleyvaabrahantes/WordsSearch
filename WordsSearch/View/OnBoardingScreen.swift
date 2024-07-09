//
//  OnBoardingScreen.swift
//  FoodRecipesHealthy
//
//  Created by David on 6/26/23.
//

import SwiftUI
import Lottie

struct OnBoardingScreen: View {
    
    @State var onBoardingItems: [OnboardingItem] = [
        .init(title: LocalizedStringKey("title1"), subtitle: LocalizedStringKey("description1"), lottieView: .init(name: "world", bundle: .main)),
        .init(title: LocalizedStringKey("title2"), subtitle: LocalizedStringKey("description2"), lottieView: .init(name: "swipe", bundle: .main)),
        .init(title: LocalizedStringKey("title3"), subtitle: LocalizedStringKey("description3"), lottieView: .init(name: "list", bundle: .main))
        
    ]
    @AppStorage("currentPage") var currentIndex = 0
    @State var showAlert: Bool = false
    @State var selectTerms: alertTerm?
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.5)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
            GeometryReader {
                let size = $0.size
                
                HStack(spacing: 0){
                    ForEach($onBoardingItems){ $item in
                        let isLastItem = currentIndex == onBoardingItems.count - 1
                        VStack {
                            HStack{
                                Button(LocalizedStringKey("back")){
                                    if currentIndex > 0 {
                                        currentIndex -= 1
                                        onBoardingItems[currentIndex].lottieView.currentProgress = 0
                                       playAnimation()
                                    }
                                }
                                .opacity(currentIndex > 0 ? 1 : 0)
                                Spacer(minLength: 0)
                                Button(LocalizedStringKey("skip")){
                                    currentIndex = onBoardingItems.count - 1
                                    playAnimation()
                                }
                                .opacity(isLastItem ? 0 : 1)
                            }
                            .tint(.blue)
                            
                        VStack(spacing: 15){
                            let offset = -CGFloat(currentIndex) * size.width
                            ResizableLottieView(onBoardingItem: $item)
                                .frame(height: size.width)
                                .onAppear{
                                    if currentIndex == indexOf(item){
                                        item.lottieView.play(toProgress: 0.9)
                                    }
                                }
                                .offset(x: offset)
                                .animation(.easeInOut(duration: 0.5), value: currentIndex)
                            Text(item.title)
                                .font(.title.bold())
                                .offset(x: offset)
                                .animation(.easeInOut(duration: 0.5).delay(0.1), value: currentIndex)
                            Text(item.subtitle)
                                .font(.system(size: 15))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 15)
                                .foregroundColor(.gray)
                                .offset(x: offset)
                                .animation(.easeInOut(duration: 0.5).delay(0.2), value: currentIndex)
                        }
                            Spacer(minLength: 0)
                            VStack(spacing: 15) {
                                Text(isLastItem ? LocalizedStringKey("done") : LocalizedStringKey("next"))
                                    .foregroundColor(.white)
                                    .padding(.vertical,isLastItem ? 13:  12)
                                    .frame(maxWidth: .infinity)
                                    .background {
                                        Capsule()
                                            .fill(.blue)
                                    }
                                    .padding(.horizontal,isLastItem ? 30 : 100)
                                    .onTapGesture {
                                        if currentIndex < onBoardingItems.count - 1 {
                                            let currentProgres = onBoardingItems[currentIndex].lottieView.currentProgress
                                            onBoardingItems[currentIndex].lottieView.currentProgress = (currentProgres == 0 ? 0.9 : currentProgres)
                                            currentIndex += 1
                                            onBoardingItems[currentIndex].lottieView.currentProgress = 0
                                            playAnimation()
                                            
                                        }else {
                                            currentIndex += 1
                                        }
                                    }
                                
    //                            HStack{
    //                                Button {
    //                                    selectTerms = alertTerm(title: "Términos", text: "El uso del sitio es bajo la exclusiva responsabilidad del usuario. Se autoriza al Usuario a visualizar y descargar los materiales contenidos en el sitio solamente para su uso personal y no para un uso comercial. Para mas información sobre término https://www.gob.mx/terminos")
    //                                    showAlert.toggle()
    //
    //                                } label: {
    //                                    Text("Terminos")
    //                                }
    //
    //                                Button {
    //                                    selectTerms = alertTerm(title: "Política privacidad", text: "La búsqueda de tu CURP, se puede realizar a través de la Clave Única de Registro de Población (CURP), en caso de conocerla, o proporcionando ciertos datos personales, con la finalidad de buscar, generar, validar y obtener el CURP. Esta app no almacena en ningun servidor ningun tipo de información, solo realiza consulta y muestra dicha información.")
    //                                    showAlert.toggle()
    //                                } label: {
    //                                    Text("Política privacidad")
    //                                }
    //                            }
    //                            .font(.caption2)
                                
                            }
                        }
                        .animation(.easeOut, value: isLastItem)
                        .padding(15)
                        .frame(width: size.width, height: size.height)
                    }
                }
                .frame(width: size.width * CGFloat(onBoardingItems.count), alignment: .leading)
            }
            .alert(selectTerms?.title ?? "", isPresented: $showAlert, actions: {
                // actions
            }, message: {
                Text(selectTerms?.text ?? "")
        })
        }
    }
    
    
    func indexOf(_ item: OnboardingItem)-> Int {
        if let index = onBoardingItems.firstIndex(of: item){
            return index
        }
        return 0
    }
    
    func playAnimation(){
        if currentIndex == onBoardingItems.count - 1 {
            onBoardingItems[currentIndex].lottieView.play(toProgress: 0.9)
        }else {
            onBoardingItems[currentIndex].lottieView.play(toProgress: 0.9)
        }
    }
    
}

struct OnBoardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingScreen()
    }
}

struct ResizableLottieView: UIViewRepresentable {
    @Binding var onBoardingItem: OnboardingItem
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        setupLottieView(view)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    func setupLottieView(_ to: UIView) {
        let lottieView = onBoardingItem.lottieView
        lottieView.backgroundColor = .clear
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        let constraint = [
            lottieView.widthAnchor.constraint(equalTo: to.widthAnchor),
            lottieView.heightAnchor.constraint(equalTo: to.heightAnchor)
        ]
        to.addSubview(lottieView)
        to.addConstraints(constraint)
    }
}

struct alertTerm: Identifiable{
    var id: String{title}
    var title: String
    var text: String
}

struct OnboardingItem: Identifiable, Equatable {
    var id: UUID = .init()
    var title: LocalizedStringKey
    var subtitle: LocalizedStringKey
    var lottieView: LottieAnimationView = .init()
}
