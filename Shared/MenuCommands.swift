//
//  MenuCommands.swift
//  Watchlist (macOS)
//
//  Created by Thura Soe Win on 24/5/21.
//

import SwiftUI

#if os(macOS)
typealias UIImage = NSImage

extension Image {
    init(uiImage: UIImage) {
        self.init(nsImage: uiImage)
    }
}
#endif

struct MenuCommands: Commands {
    var body: some Commands {
        SidebarCommands()
    }
}
