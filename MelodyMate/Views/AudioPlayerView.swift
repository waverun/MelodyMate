import SwiftUI
import AVFoundation

var gAudioPlayerView: AudioPlayerView?

struct AudioPlayerView: View {

    @State private var currentProgress: Double = 0

    //    let skipIntervals = [15, 30, 60, 120, 240, 480]

    @ObservedObject var audioPlayer: AudioPlayer

    @StateObject private var routeChangeHandler = RouteChangeHandler()

    @Binding private var audioUrl: URL
    private var imageSrc: UIImage?
    @Binding private var heading: String
    @Binding private var isLive: Bool

    private var title, artist: String

    @State private var albumArt: UIImage?
    @State private var isCurrentlyPlaying = false

    let onAppearAction: (() -> Void)?

    init(url: Binding<URL>, image: UIImage?, date: Binding<String>, isLive: Binding<Bool>, title: String, artist: String, onAppearAction: (() -> Void)? = nil) {
        self.audioPlayer = AudioPlayer(isLive: isLive.wrappedValue, albumArt: image, title: title, artist: artist)
        _audioUrl = url
        self.imageSrc = image
        _heading = date
        _isLive = isLive
        self.title = title
        self.artist = artist
        self.onAppearAction = onAppearAction
        gAudioPlayerView = self
    }

    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack {
                    VStack {
                        Spacer()
                            .frame(height: 50) // Adjust the height value as needed
                        Text(title)
                            .font(.system(size: 24)) // Adjust the size value as needed
                            .bold()
                            .multilineTextAlignment(.center)
                        Text(artist)
                            .font(.system(size: 24)) // Adjust the size value as needed
                            .bold()
                            .multilineTextAlignment(.center)
                        if let albumArt = albumArt {
                            Image(uiImage: albumArt)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 120)
                        } else {
                            // show a placeholder image when there's no artwork
                            Image(systemName: "music.note")
                                .resizable()
                                .frame(width: 120, height: 120)
                        }
                        HStack {
                            VStack {
                                HStack {
                                    Button(action: {
                                        audioPlayer.rewind(by: 15)
                                    }) {
                                        Image(systemName: "gobackward.15")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 40, height: 40)
                                    }
                                    .foregroundColor(.pink)

                                    Text("\(audioPlayer.currentProgressString)")
                                        .frame(width: 70, alignment: .leading)
                                        .foregroundColor(.primary)

                                    Button(action: {
                                        audioPlayer.isPlaying ? audioPlayer.pause() : audioPlayer.play(url: audioUrl)
                                    }) {
                                        Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                    }
                                    .foregroundColor(.pink)

                                    Text("\(audioPlayer.totalDurationString)")
                                        .frame(width: 70, alignment: .trailing)
                                        .foregroundColor(.primary)

                                    Button(action: {
                                        audioPlayer.forward(by: 15)
                                    }) {
                                        Image(systemName: "goforward.15")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 40, height: 40)
                                    }
                                    .foregroundColor(.pink)
                                }
                            }
                        }
                        Slider(value: $currentProgress,
                               in: 0...$audioPlayer.totalDurationString.wrappedValue.timeStringToDouble(),
                               onEditingChanged: { isEditing in
                            print("slider: \(isEditing)")
                            if isEditing {
                                audioPlayer.shouldUpdateTotalDuration = false
                                isCurrentlyPlaying = audioPlayer.isPlaying
                                audioPlayer.pause()
                            } else {
                                audioPlayer.seekToNewTime(currentProgress.toCMTime())
                                if isCurrentlyPlaying {
                                    audioPlayer.play()
                                }
                            }
                        })
                        .padding(.horizontal)
                        .accentColor(.pink)
                        .onChange(of: currentProgress) {newValue in
                            audioPlayer.setCurrentProgressString(time: newValue)
                        }
                        .onChange(of: audioPlayer.currentProgressString.timeStringToDouble()) { newValue in
                            currentProgress = newValue
                        }
                    }
                    .background(Color.purple.opacity(0.2))
                    .cornerRadius(15)
                    .padding(.horizontal)

//    var body: some View {
//        GeometryReader { geometry in
//            HStack {
//                Spacer()
//                VStack {
//                    VStack {
//                        Spacer()
//                            .frame(height: 50) // Adjust the height value as needed
//                        Text(title)
//                            .font(.system(size: 24)) // Adjust the size value as needed
//                            .bold()
//                            .multilineTextAlignment(.center)
//                        Text(artist)
//                            .font(.system(size: 24)) // Adjust the size value as needed
//                            .bold()
//                            .multilineTextAlignment(.center)
//                        if let albumArt = albumArt {
//                            Image(uiImage: albumArt)
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 120, height: 120)
//                            } else {
//                                // show a placeholder image when there's no artwork
//                                Image(systemName: "music.note")
//                                    .resizable()
//                                    .frame(width: 120, height: 120)
//                            }
//                        HStack {
//                            VStack {
//                                HStack {
//                                    Button(action: {
//                                        audioPlayer.rewind(by: 15)
//                                    }) {
//                                        Image(systemName: "gobackward.15")
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(width: 40, height: 40)
//                                    }
//
//                                    Text("\(audioPlayer.currentProgressString)")
//                                        .frame(width: 70, alignment: .leading)
//                                        .foregroundColor(.primary)
//
//                                    Button(action: {
//                                        audioPlayer.isPlaying ? audioPlayer.pause() : audioPlayer.play(url: audioUrl)
//                                    }) {
//                                        Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(width: 50, height: 50)
//                                    }
//
//                                    Text("\(audioPlayer.totalDurationString)")
//                                        .frame(width: 70, alignment: .trailing)
//                                        .foregroundColor(.primary)
//
//                                    Button(action: {
//                                        audioPlayer.forward(by: 15)
//                                    }) {
//                                        Image(systemName: "goforward.15")
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(width: 40, height: 40)
//                                    }
//                                }
//                            }
//                        }
//                        Slider(value: $currentProgress,
//                               in: 0...$audioPlayer.totalDurationString.wrappedValue.timeStringToDouble(),
//                               onEditingChanged: { isEditing in
//                            print("slider: \(isEditing)")
//                            if isEditing {
//                                audioPlayer.shouldUpdateTotalDuration = false
//                                isCurrentlyPlaying = audioPlayer.isPlaying
//                                audioPlayer.pause()
//                            } else {
//                                audioPlayer.seekToNewTime(currentProgress.toCMTime())
//                                if isCurrentlyPlaying {
//                                    audioPlayer.play()
//                                }
//                                //                                audioPlayer.shouldUpdateTotalDuration = true
//                            }
//                        })
//                        .padding(.horizontal)
//                        .onChange(of: currentProgress) {newValue in
//                            audioPlayer.setCurrentProgressString(time: newValue)
//                        }
//                        .onChange(of: audioPlayer.currentProgressString.timeStringToDouble()) { newValue in
//                            currentProgress = newValue
//                        }
//                    }
                    let availableSpace = geometry.size.height - geometry.safeAreaInsets.bottom - geometry.size.width / 2
                    Spacer()
                        .frame(height: availableSpace / 4)

                    Button(action: {
                        selectAudioOutput()
                    }) {
                        Image(systemName: "airplayaudio")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                    }
                    .padding()
                    .background(Color.pink)
                    .foregroundColor(.primary)
                    .cornerRadius(8)

                    Spacer()
                }
                Spacer()
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear {
            albumArt = imageSrc
            if let action = onAppearAction {
                action()
            }
        }
        .onDisappear {
            gAudioPlayerView = nil
            audioPlayer.pause()
            audioPlayer.removePlayer()
        }
        .environment(\.layoutDirection, .leftToRight)
    }
}
