//
//  Meme.swift
//  MemeMe
//
//  Created by Emmanuel Okwara on 05/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let memedImage: UIImage
}

class MemesManager {
    static let shared = MemesManager()
    private init() {}
    
    var memes = [Meme]()
    
    func add(meme: Meme) {
        memes.insert(meme, at: 0)
    }
    
    func delete(meme: Meme) {
        let currentMemeIndex = memes.firstIndex { $0.memedImage == meme.memedImage }
        memes.remove(at: currentMemeIndex!)
    }
    
    func getAllMemes() -> [Meme] {
        return memes
    }
}
