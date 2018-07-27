//
//  NewEntryViewController.swift
//  Travelogue
//
//  Created by Jacob Sokora on 7/19/18.
//  Copyright © 2018 Jacob Sokora. All rights reserved.
//

import UIKit

class EntriesDetailViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var contentView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    
    var trip: Trip!
    var entry: Entry?
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let viewForDoneButtonOnKeyboard = UIToolbar()
        viewForDoneButtonOnKeyboard.sizeToFit()
        let spaceBar = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btnDoneOnKeyboard = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneBtnFromKeyboardClicked))
        viewForDoneButtonOnKeyboard.items = [spaceBar, btnDoneOnKeyboard]
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        dateField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(self.pickDate), for: .valueChanged)
        dateField.text = dateFormatter.string(from: Date())
        
        titleField.inputAccessoryView = viewForDoneButtonOnKeyboard
        dateField.inputAccessoryView = viewForDoneButtonOnKeyboard
        contentView.inputAccessoryView = viewForDoneButtonOnKeyboard
        
        contentView.delegate = self
        
        if let entry = entry {
            titleField.text = entry.title
            dateField.text = dateFormatter.string(from: entry.date)
            contentView.text = entry.content
            if let image = entry.image {
                imageView.image = image
            }
        } else {
            contentView.text = "Add details"
            contentView.textColor = UIColor.lightGray
        }
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        libraryButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary) || UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func takePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
               presentPhotoPicker(for: .camera)
        }
    }
    
    @IBAction func pickPhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            presentPhotoPicker(for: .photoLibrary)
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            presentPhotoPicker(for: .savedPhotosAlbum)
        }
    }
    
    func presentPhotoPicker(for sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc func doneBtnFromKeyboardClicked() {
        self.view.endEditing(true)
    }
    
    @objc func pickDate() {
        if let datePicker = dateField.inputView as? UIDatePicker {
            dateField.text = dateFormatter.string(from: datePicker.date)
        }
    }
    
    @IBAction func save(_ sender: Any) {
        if entry == nil {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            entry = Entry(entity: Entry.entity(), insertInto: context)
        }
        guard let entry = entry else {
            return
        }
        
        guard let title = titleField.text, let date = dateFormatter.date(from: dateField.text ?? ""),
            let content = contentView.text else {
                let alert = UIAlertController(title: "Invalid Entry", message: "Please check that all fields are filled out", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
        }
        entry.title = title
        entry.date = date
        entry.content = content
        entry.image = imageView.image
        entry.trip = trip
        trip.addToEntries(entry)
        do {
            try entry.managedObjectContext?.save()
        } catch {
            print("Failed to save entry: \(error.localizedDescription)")
        }
        dismiss(animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension EntriesDetailViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        for piece in info {
            if piece.value is UIImage {
                imageView.image = piece.value as? UIImage
                picker.dismiss(animated: true)
            }
        }
    }
}

extension EntriesDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add details"
            textView.textColor = UIColor.lightGray
        }
    }
}

extension EntriesDetailViewController: UINavigationControllerDelegate {}
