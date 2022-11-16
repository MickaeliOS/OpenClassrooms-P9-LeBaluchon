//
//  TraductionVC.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 09/11/2022.
//

import UIKit

class TraductionVC: UIViewController {

    @IBOutlet weak var sourceFlag: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var exchangeButton: UIButton!
    @IBOutlet weak var destinationFlag: UIImageView!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var sourceTextView: UITextView!
    @IBOutlet weak var translatedTextView: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
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
    
    private func setupInterface() {
        // Source & Destination text view
        sourceTextView.text = "Texte à traduire"
        sourceTextView.textColor = .lightGray
        translatedTextView.text = "Résultat traduction"
        translatedTextView.textColor = .lightGray
        
        // Translate button
        translateButton.layer.cornerRadius = 20
    }
}

extension TraductionVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Texte à traduire"
            textView.textColor = UIColor.lightGray
        }
    }
}
