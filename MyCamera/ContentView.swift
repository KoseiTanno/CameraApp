//
//  ContentView.swift
//  MyCamera
//
//  Created by ピットラボ on 2025/03/01.
//

import SwiftUI
import PhotosUI

//  選択画面
struct ContentView: View {
    //  撮影した写真を格納する変数
    @State var captureImage: UIImage? = nil
    
    //  撮影画面の開閉状態を管理
    @State var isShowSheet = false
    @State var photoPickerSelectedImage: PhotosPickerItem? = nil
    
    var body: some View {
        VStack {
            Spacer()
            
            Button {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    print("カメラは利用できます")
                    captureImage = nil
                    isShowSheet.toggle()
                } else {
                    print("カメラは利用できません")
                }
            } label: {
                Text("カメラを起動する")
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundStyle(Color.white)
            }
            
            .padding()
            
            .sheet(isPresented: $isShowSheet) {
                //  撮影した写真がある時
                if let captureImage {
                    EffectView(isShowSheet: $isShowSheet, captureImage: captureImage)
                } else {
                    ImagePickerView(isShowSheet: $isShowSheet, captureImage: $captureImage)
                }
            }
            
            PhotosPicker(selection: $photoPickerSelectedImage, matching: .images, preferredItemEncoding: .automatic, photoLibrary: .shared()) {
                Text("フォトライブラリーから選択する")
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .frame(height: 50)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .padding()
            }
            
            //  選択した写真情報をもとに写真を取り出す
            .onChange(of: photoPickerSelectedImage, initial: true, { oldValue, newValue in
                //  選択した写真がある場合
                if let newValue {
                    Task {
                        if let data = try? await newValue.loadTransferable(type: Data.self) {
                            captureImage = UIImage(data: data)
                        }
                }
            }})
            
        }
        
        .onChange(of: captureImage, initial: true, { oldValue, newValue in
            if let _ = newValue {
                isShowSheet.toggle()
        }})
    }
}

#Preview {
    ContentView()
}
