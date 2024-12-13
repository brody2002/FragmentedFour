//
//  SideBarView.swift
//  FragmentedFour
//
//  Created by Brody on 11/27/24.
//

import SwiftUI
import AVFoundation


struct SideBarView: View {
    @Binding var shouldRestartLevel: Bool
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var globalAudio: GlobalAudioSettings
    @State private var audioPlayer: AVAudioPlayer?
    @Binding var navPath: NavigationPath
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
                .frame(height: 60)
            Text("Menu")
                .font(.title.bold())
                .foregroundStyle(.white)
                .padding()
                .fontDesign(.rounded)
                .background(
                    Text("Menu")
                        .font(.title.bold())
                        .foregroundStyle(.gray)
                        .fontDesign(.rounded)
                        .offset(y: 3)
                        .padding()
                )
            Divider()
                .frame(width: UIScreen.main.bounds.width * 2/4)
                .padding(.horizontal)
            
            VStack(alignment: .center){
                Spacer()
                    .frame(height: 20)
                
                Text("Audio")
                    .foregroundStyle(.white)
                    .font(.title3.bold())
                    .fontDesign(.rounded)
                    .background (
                        Text("Audio")
                            .foregroundStyle(.gray)
                            .font(.title3.bold())
                            .fontDesign(.rounded)
                            .offset(y:2.3)
                    )
                
                Spacer().frame(height:10)
                        
                HStack{
                    
                    Image(systemName: globalAudio.backgroundAudioOn == true ? "speaker.wave.3.fill" : "speaker.slash.fill")
                        .foregroundStyle(.white)
                        .padding()
                        .frame(width: 60, height: 50)
                        .onTapGesture {
                            // Toggle Volume on and off
                            globalAudio.backgroundAudioOn.toggle()
                            
                            if globalAudio.backgroundAudioOn == false {
                                globalAudio.setVolume(forAll: 0.0)
                            } else { globalAudio.setVolume(forAll: 1.0) }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(AppColors.sidebarButton)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.gray)
                                        .offset(y: 3)
                                )
                        )
                    
                        Spacer().frame(width:10)
                    
                    ZStack{
                        if globalAudio.soundEffectAudioOn {
                            Image(systemName: "hand.tap.fill")
                                .foregroundStyle(.white)
                                .padding()
                                .frame(width: 60, height: 50)
                        } else {
                            handTapOffView(isBackgroundView: false, isHomeScreen: false)
                                .padding()
                                .frame(width: 60, height: 50)
                        }
                    }
                    .onTapGesture {
                        globalAudio.soundEffectAudioOn.toggle()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(AppColors.sidebarButton)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.gray)
                                    .offset(y: 3)
                            )
                    )
                    
                }
               
                
                Spacer().frame(height: 20)
                
                Text("Home")
                    .foregroundStyle(.white)
                    .font(.title3.bold())
                    .fontDesign(.rounded)
                    .background (
                        Text("Home")
                            .foregroundStyle(.gray)
                            .font(.title3.bold())
                            .fontDesign(.rounded)
                            .offset(y:2.3)
                    )
                Spacer().frame(height: 10)
                Button(action:{
                    globalAudio.playSoundEffect(for: "BackBubble", audioPlayer: &audioPlayer)
                    if navPath.count == 2 {
                        navPath.removeLast(2)
                    } else {
                        dismiss()
                    }
                }, label:{
                    Image(systemName: "house")
                        .foregroundStyle(.white)
                        .padding()
                        .frame(width: 60, height: 50)
                        
                })
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColors.sidebarButton)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray)
                                .offset(y: 3)
                        )
                        .frame(width: 130, height: 50)
                )
                .buttonStyle(NoGrayOutButtonStyle())
                
                
                Spacer()
                    .frame(height: 20)
                
                VStack{
                    Text("Level Select")
                        .foregroundStyle(.white)
                        .font(.title3.bold())
                        .fontDesign(.rounded)
                        .background (
                            Text("Level Select")
                                .foregroundStyle(.gray)
                                .font(.title3.bold())
                                .fontDesign(.rounded)
                                .offset(y:2.3)
                        )
                    Spacer()
                        .frame(height: 10)
                    
                    Button(action:{
                        //dismiss back to LevelSelectView
                        globalAudio.playSoundEffect(for: "BackBubble", audioPlayer: &audioPlayer)
                        if navPath.count == 2 {
                            navPath.removeLast(1)
                        }
                    }, label:{
                        Image(systemName: "light.panel")
                            .foregroundStyle(.white)
                            .padding()
                            .frame(width: 60, height: 50)
                            
                    })
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(AppColors.sidebarButton)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.gray)
                                    .offset(y: 3)
                            )
                            .frame(width: 130, height: 50)
                    )
                    .buttonStyle(NoGrayOutButtonStyle())
                        
                }
                .opacity(navPath.count == 2 ? 1.0 : 0.0)
                
                
                
                Spacer()
                    .frame(minHeight: 300)
                
                Button(action: {
                    shouldRestartLevel.toggle()
                    globalAudio.playSoundEffect(for: "BackBubble", audioPlayer: &audioPlayer)
                    
                }, label:{
                    Text("Restart")
                        .font(.body.bold())
                        .foregroundStyle(.white)
                        .padding()
                        
                })
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColors.sidebarButton)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray)
                                .offset(y: 3)
                        )
                )
                .buttonStyle(NoGrayOutButtonStyle())
                Spacer()
                    .frame(minHeight: 70, maxHeight: 90 )
                 
            }
            Spacer()
        }
        .background(AppColors.coreBlue)
        .cornerRadius(10)
        .edgesIgnoringSafeArea(.all)
        .frame(width: UIScreen.main.bounds.width * 0.5)
    }
    
}

#Preview {
    @Previewable @StateObject var globalAudio = GlobalAudioSettings()
    @Previewable @State var navPath = NavigationPath()
    ZStack {
        Color.red.ignoresSafeArea()
        SideBarView(shouldRestartLevel: .constant(false), navPath: $navPath)
            .environmentObject(globalAudio)
    }
}
