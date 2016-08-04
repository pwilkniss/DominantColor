//
//  ViewController.swift
//  Dominant Color iOS
//
//  Created by Jamal E. Kharrat on 12/22/14.
//  Copyright (c) 2014 Indragie Karunaratne. All rights reserved.
//

import UIKit
import DominantColor

class ViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var boxes: [UIView]!
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage!

    // MARK: IBActions
    
    @IBAction func selectTapped(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func runBenchmarkTapped(_ sender: AnyObject) {
        if let image = image {
            let nValues: [Int] = [100, 1000, 2000, 5000, 10000, 100000, 500000]
            let CGImage = image.cgImage
            for n in nValues {
                let ns = dispatch_benchmark(5) {
                    _ = dominantColorsInImage(CGImage!, maxSampledPixels: n)
                    return
                }
                print("n = \(n) averaged \(ns/1000000) ms")
            }
        }
    }
    
    // MARK: ImagePicker Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        if let imageSelected = image {
            self.image = imageSelected
            imageView.image = imageSelected
            
            let colors = imageSelected.dominantColors(500000)
            for box in boxes {
                box.backgroundColor = UIColor.clear()
            }
            for i in 0..<min(colors.count, boxes.count) {
                boxes[i].backgroundColor = colors[i]
            }
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil);
    }
}
