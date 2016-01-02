//
//  DetailViewController.swift
//  hierarchicalISBN
//
//  Created by Alberto De Avila Hernandez on 1/1/16.
//  Copyright © 2016 Alberto De Avila Hernandez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var frontImage: UIImageView!
    var detailItem: Book?
    
    /**
     * Method to show the book data
     */
    func configureView() {
        titleLabel.title = detailItem!.name
        bookNameLabel.text = detailItem!.name
        authorsLabel.text = detailItem!.authors
        if(detailItem?.image != nil){
            frontImage.image = detailItem!.image
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

