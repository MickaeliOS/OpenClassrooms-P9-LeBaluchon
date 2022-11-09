//
//  TraductionVC.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 09/11/2022.
//

import UIKit

class TraductionVC: UIViewController {

    @IBOutlet weak var sourceTextView: UITextView!
    @IBOutlet weak var translatedTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        sourceTextView.resignFirstResponder()
    }
    
    @IBAction func translateButton(_ sender: Any) {
        TraductionService.shared.getTraduction(source: "fr", target: "en", text: sourceTextView.text) { success, translatedText, error in
            if error != nil {
                //self.presentAlert(with: error!.localizedDescription)
                return
            }
            
            guard let translatedText = translatedText, success == true else {
                return
            }
            
            self.translatedTextView.text = "\(translatedText)"
        }
    }
}

extension TraductionVC: UITextViewDelegate {
    // To Do : Investiguer car cette méthode, quand on presse la touche retour, ferme le clavier
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        sourceTextView.resignFirstResponder()
        return true
    }
}
