import MediaPlayer

func getAllSongs(completion: @escaping ( _ : [MPMediaItem]) -> Void) {
    func getItems() {
        let query = MPMediaQuery.songs()
        if let items = query.items {
            print("items.count: \(items.count)")
            for item in items {
                if let assetURL = item.assetURL {
                    print("item url: \(assetURL)")
                }
            }
            let items = items.filter {
                $0.assetURL != nil &&
                ($0.assetURL!.absoluteString.contains(".m4a") ||
                 $0.assetURL!.absoluteString.contains(".mp3") )
            }
            print("items: \(items)")
            completion(items)
        }
    }

    let status = MPMediaLibrary.authorizationStatus()

    if status == .authorized {
        getItems()
    } else if status == .notDetermined {
        MPMediaLibrary.requestAuthorization { (newStatus) in
            if newStatus == .authorized {
                getItems()
            }
        }
    } else {
        // Handle the case where the user denied or restricted access to the media library.
    }
}
