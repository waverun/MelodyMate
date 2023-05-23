import MediaPlayer

func getAllSongs() {
    let status = MPMediaLibrary.authorizationStatus()

    if status == .authorized {
        let query = MPMediaQuery.songs()
        let items = query.items
        print("items: \(items!)")
        // Now you can handle the array of MPMediaItem objects.
    } else if status == .notDetermined {
        MPMediaLibrary.requestAuthorization { (newStatus) in
            if newStatus == .authorized {
                let query = MPMediaQuery.songs()
                let items = query.items
                print("items: \(items!)")
                // Now you can handle the array of MPMediaItem objects.
            }
        }
    } else {
        // Handle the case where the user denied or restricted access to the media library.
    }
}
