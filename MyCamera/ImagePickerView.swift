//
//  ImagePickerView.swift
//  MyCamera
//
//  Created by ピットラボ on 2025/03/01.
//

import SwiftUI

// 撮影画面
struct ImagePickerView: UIViewControllerRepresentable {
    //  撮影画面の開閉状態を管理
    @Binding var isShowSheet: Bool
    
    //  撮影した写真を格納する変数
    @Binding var captureImage: UIImage?
    
    //  コントローラのdelegateを管理
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true) {
                if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    self.parent.captureImage = originalImage
                }
            }
            parent.isShowSheet.toggle()
        }
        
        //  キャンセルボタン押下時
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isShowSheet.toggle()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let myImagePickerController = UIImagePickerController()
        
        myImagePickerController.sourceType = .camera
        
        myImagePickerController.delegate = context.coordinator
        
        return myImagePickerController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
}
