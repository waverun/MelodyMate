//
//  ContentView.swift
//  MelodyMate
//
//  Created by shay moreno on 23/05/2023.
//

import SwiftUI
import CoreData
import MediaPlayer

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var song: MPMediaItem? = nil
    @State private var songs: [MPMediaItem] = []
    @State private var updateView: Bool = false

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        VStack {
            Button(action: {
                getAllSongs() { items in
//                    let items = items.filter { $0.assetURL != nil }
                    songs = items
                    song = songs[1]
                    print("song: \(song?.title!) \(song?.artist)")
                    updateView.toggle() // manually trigger a view update
                }
            }) {
                Text("Get All Songs")
            }
        }
        NavigationView {
            List {
                ForEach(songs.indices, id: \.self) { index in
                    let song = songs[index]
                    NavigationLink(destination:
                        Group {
                            if let url = song.assetURL {
                                AudioPlayerView(
                                    url: .constant(url),
                                    image: song.artwork?.image(at: CGSize(width: 200, height: 200)), //.flatMap {
                                    date: .constant(song.releaseDate?.description ?? ""),
                                    isLive: .constant(false),
                                    title: song.title ?? "",
                                    artist: song.artist ?? ""
                                )
                            } else {
                                Text("No song selected.")
                            }
                        }
                    ) {
                        Text(song.title ?? "Unknown Title")
                    }
                }
                //                ForEach(songs) { song in
                //                    NavigationLink(value: song?.title) {
                //                        if let song = song, let url = song.assetURL {
                //                            AudioPlayerView(
                //                                url: .constant(url),
                //                                image: song.artwork?.image(at: CGSize(width: 200, height: 200)), //.flatMap {
                //                                date: .constant(song.releaseDate?.description ?? ""),
                //                                isLive: .constant(false),
                //                                title: song.title ?? "",
                //                                artist: song.artist ?? ""
                //                            )
                //                        } else {
                //                            Text("No song selected.")
                //                        }
                //                        //                    NavigationLink {
                //                        ////                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                //                        //                    } label: {
                //                        ////                        Text(item.timestamp!, formatter: itemFormatter)
                //                        //                    }
                //                    }
                //                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
            if updateView, let song = song, let _ = song.assetURL {
                // ...
            } else {
                // ...
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
