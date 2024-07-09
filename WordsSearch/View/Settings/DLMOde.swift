//
//  DLMOde.swift
//  Task Pending Minimal
//
//  Created by David on 6/2/24.
//

import SwiftUI

struct DLMOde: View {
    @AppStorage("systemTheme") private var systemTheme: Int = AppareanceMode.allCases.first!.rawValue
    @Binding var colorScheme: ColorScheme?
    @Binding var showAppareance: Bool
    @Binding var appearanceMode: AppareanceMode
    var body: some View {
        ZStack {
        //    Color(showAppareance ? .clear : .gray.opacity(0.3))
            if showAppareance {
                Color.clear
            }else{
                Color.gray.opacity(0.3)
            }
            VStack {
                Spacer()
                ZStack{
                    RoundedRectangle(cornerRadius: 30)
                        .frame(height: 270)
                        .foregroundStyle(Color(uiColor: .systemBackground))
                    VStack(spacing: 20){
                        HStack{
                            Text("Appearance")
                            Spacer()
                            Button {
                                showAppareance.toggle()
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                            }

                        }
                        .bold()
                        .font(.title)
                        .foregroundStyle(.primary)
                        .padding(.horizontal)
                        Divider()
                            .padding(.horizontal,30)
                        HStack(spacing: 40){
                            Button {
                                appearanceMode = .light
                                colorScheme = .light
                                systemTheme = appearanceMode.rawValue
                            } label: {
                                UIButtonAppareance(mode: .light, currentMode: $appearanceMode, Rbg: Color(uiColor: UIColor.systemGray4), Rbgi: Color(uiColor: UIColor.systemGray3), ibg: .white)
                            }
                            .tint(.primary)
                            
                            Button {
                                appearanceMode = .dark
                                colorScheme = .dark
                                systemTheme = appearanceMode.rawValue
                            } label: {
                                UIButtonAppareance(mode: .dark, currentMode: $appearanceMode, Rbg: Color(uiColor: UIColor.systemGray), Rbgi: Color(uiColor: UIColor.systemGray3), ibg: .black)
                            }
                            .tint(.primary)
                            
                            
                            
                            Button {
                                appearanceMode = .system
                                colorScheme = nil
                                systemTheme = appearanceMode.rawValue
                            } label: {
                                ZStack {
                                    UIButtonAppareance(mode: .system, currentMode: $appearanceMode, Rbg: Color(uiColor: UIColor.systemGray), Rbgi: Color(uiColor: UIColor.systemGray3), ibg: .white)
                                    UIButtonAppareance(mode: .system, currentMode: $appearanceMode, Rbg: Color(uiColor: UIColor.systemGray4), Rbgi: Color(uiColor: UIColor.systemGray3), ibg: .black)
                                        .mask {
                                            RoundedRectangle(cornerRadius: 10)
                                                .frame(width: 50, height: 200)
                                                .offset(x: -24)
                                        }
                                }
                            }

                        }
                    }
                }
                .padding(.horizontal,8)
                .preferredColorScheme(colorScheme)
            }
            .offset(y: showAppareance ? 300 : -100)
        }
        .onTapGesture {
            withAnimation {
                showAppareance.toggle()
            }
        }
    }
}

#Preview {
    DLMOde(colorScheme: .constant(.dark), showAppareance: .constant(false), appearanceMode: .constant(.dark))
}

enum AppareanceMode: Int, Identifiable, CaseIterable{
    var id: Self {self}
    case dark, light, system
}

struct UIButtonAppareance: View {
    var mode: AppareanceMode
    @Binding var currentMode: AppareanceMode
    var Rbg: Color
    var Rbgi: Color
    var ibg: Color
    var body: some View {
        VStack(spacing: 20) {
            VStack{
                Circle()
                    .frame(width: 20, height: 20)
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 49, height: 6)
                VStack(spacing: 5){
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 38, height: 6)
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 38, height: 6)
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 38, height: 6)
                }
                .frame(width: 55, height: 50)
                .background(ibg, in: RoundedRectangle(cornerRadius: 5))
            }
            .foregroundStyle(Rbgi)
            .padding(8)
            .overlay(content: {
                if currentMode == mode {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .padding(-3)
                }
            })
        .background(Rbg, in: RoundedRectangle(cornerRadius: 7))
            Text(String(describing: mode).capitalized)
                .foregroundStyle(currentMode == mode ? Color(uiColor: .systemGray6) : .gray)
                .font(.system(size: 15))
                .frame(width: 80, height: 25)
                .background(currentMode == mode ? Color(.buttonBG) : Color(uiColor: .systemGray4), in: RoundedRectangle(cornerRadius: 10))
        }
        .scaleEffect(currentMode == mode ? 1.1 : 0.9)
        .animation(.default, value: currentMode)
    }
}
