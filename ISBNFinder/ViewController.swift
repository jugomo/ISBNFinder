//
//  ViewController.swift
//  ISBNFinder
//
//  Created by Julio on 3/12/15.
//  Copyright © 2015 Julio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    let urlBase = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
    
    @IBOutlet weak var isbnInput: UITextField!
    @IBOutlet weak var bookOutput: UITextView!
    
    
    @IBAction func search(sender: AnyObject) {
        view.endEditing(true)
        bookOutput.text = ""
        
        if isbnInput.text != "" {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            asincrona(isbnInput.text!)
        } else {
            bookOutput.text = "Por favor, ingrese un ISBN válido."
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        search(textField)
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isbnInput.delegate = self
    }

    func sincrona(isbn: String) {
        let url = NSURL(string: urlBase + isbn)
        let data = NSData(contentsOfURL: url!)
        let response = NSString(data: data!, encoding: NSUTF8StringEncoding)
        print("SINCRONA: " + (response! as String))
        verRespuesta(response)
    }
    
    func asincrona(isbn: String) {
        let url = NSURL(string: urlBase + isbn)
        let session = NSURLSession.sharedSession()
        let handler = {
            (datos: NSData?, resp: NSURLResponse?, error: NSError?) -> Void in
            
            let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
            print("ASINCRONA: " + (texto! as String))
            
            dispatch_async(dispatch_get_main_queue()) {
                self.verRespuesta(texto)
            }
        }
        
        let dt = session.dataTaskWithURL(url!, completionHandler: handler)
        dt.resume()
    }
    
    func verRespuesta(respuesta: NSString?) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        if respuesta != nil && respuesta != "{}" {
            bookOutput.text = respuesta! as String
        } else {
            bookOutput.text = "Se ha producido un error al realizar su petición."
        }
    }
}

