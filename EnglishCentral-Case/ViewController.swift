//
//  ViewController.swift
//  EnglishCentral-Case
//
//  Created by Yasin Akbas on 8.07.2022.
//

import UIKit
import NetworkKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        Task {
            let response = await PlacesAPI().autoSuggest(at: "40.74917,-73.98529", q: "chrysler").onError { error in
                print(error.localizedDescription)
            }.startAsync()
            print(response)
        }
    }


}

