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
                .background(
                    Text("Menu")
                        .font(.title.bold())
                        .foregroundStyle(.gray)
                        .offset(y: 3)
                        .padding()
                )
            Divider()
                .frame(width: UIScreen.main.bounds.width * 2/4)
                .padding(.horizontal)
            
            VStack(alignment: .center){
                Spacer()
                    .frame(height: 20)
                
                HStack{
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
                    )
                    .buttonStyle(NoGrayOutButtonStyle())
                    
                    
                    
                    Image(systemName: globalAudio.audioOn == true ? "speaker.wave.3.fill" : "speaker.slash.fill")
                        .foregroundStyle(.white)
                        .padding()
                        .frame(width: 60, height: 50)
                        .onTapGesture {
                            // Toggle Volume on and off
                            globalAudio.audioOn.toggle()
                            
                            if globalAudio.audioOn == false {
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
                }
                Spacer()
                    .frame(height: 30)
                
                Text("Level Select")
                    .font(.body.bold())
                    .foregroundStyle(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(AppColors.sidebarButton)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.gray)
                                    .offset(y: 3)
                            )
                    )
                    .onTapGesture {
                        //dismiss back to LevelSelectView
                        globalAudio.playSoundEffect(for: "BackBubble", audioPlayer: &audioPlayer)
                        if navPath.count == 2 {
                            navPath.removeLast(1)
                        }
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
    }
    
}

#Preview {
    @Previewable @State var navPath = NavigationPath()
    ZStack {
        Color.red.ignoresSafeArea()
        SideBarView(shouldRestartLevel: .constant(false), navPath: $navPath)
    }
}
