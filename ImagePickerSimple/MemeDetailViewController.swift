//
//  MemeDetailViewController.swift
//  ImagePickerSimple
//
//  Created by J B on 5/24/17.
//  Copyright © 2017 J B. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var selectedMeme: Meme!
    
    @IBOutlet weak var imagePickerView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePickerView.image = selectedMeme.memedImage
    }


}
