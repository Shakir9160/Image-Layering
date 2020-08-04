//
//  ViewController.swift
//  Image Layering
//
//  Created by Shakir Shaikh on 21/07/20.
//  Copyright © 2020 Shakir Shaikh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var imagePicker = UIImagePickerController()
    var imgArr: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    var colorCodeArr: [String] = ["FF0000", "FF1493", "FFA500", "800080", "008000", "FFFF00", "0000FF", "808080", "800000", "000000"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 10.0
        self.imageCollectionView.isHidden = true
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgView
    }
    
    @IBAction func addImageBtnTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // To handle image
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imgView.image = image
            self.imageCollectionView.isHidden = false
            
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imgView.image = image
            self.imageCollectionView.isHidden = false
            
        } else {
            print("Something went wrong in image")
        }
        self.dismiss(animated: true, completion:nil)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.imageCollectionView.frame.size.width - 60)/3, height: 115)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.imageCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        cell.colorImgView.image = UIImage(named: self.imgArr[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = self.imgView.image?.blendWithColorAndRect(blendMode: .color, color: UIColor(hexString: self.colorCodeArr[indexPath.item]), rect: CGRect(x: self.imgView.frame.origin.x, y: self.imgView.frame.origin.y, width: self.imgView.frame.size.width, height: self.imgView.frame.size.height))
        
        self.imgView.image = image
    }
}

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var colorImgView: UIImageView!
}
