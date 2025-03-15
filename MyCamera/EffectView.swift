//
//  EffectView.swift
//  MyCamera
//
//  Created by ピットラボ on 2025/03/02.
//

import SwiftUI

//  エフェクト編集画面
struct EffectView: View {
    //  エフェクト編集画面の開閉状態を管理
    @Binding var isShowSheet: Bool
    
    //  撮影した写真
    let captureImage: UIImage
    
    //  表示する写真
    @State var showImage: UIImage?
    
    let filterArray = ["CIPhotoEffectMono",
                       "CIPhotoEffectChrome",
                       "CIPhotoEffectFade",
                       "CIPhotoEffectInstant",
                       "CIPhotoEffectNoir",
                       "CIPhotoEffectProcess",
                       "CIPhotoEffectTonal",
                       "CIPhotoEffetTransfer",
                       "CISepiaTone"
    ]
    
    @State var filterSelectNumber = 0
    
    var body: some View {
        VStack {
            Spacer()
            
            if let showImage {
                Image(uiImage: showImage)
                    .resizable()
                    .scaledToFit()
            }
            
            Spacer()
            
            //  エフェクト適用ボタン
            Button {
                let filterName = filterArray[filterSelectNumber]
                
                filterSelectNumber += 1
                
                if filterSelectNumber == filterArray.count {
                    filterSelectNumber = 0
                }
                
                let rotate = captureImage.imageOrientation
                
                let inputImage = CIImage(image: captureImage)
                
                guard let effectFilter = CIFilter(name: filterName) else {
                    return
                }
                
                effectFilter.setDefaults()
                
                effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
                
                guard let outputImage = effectFilter.outputImage else {
                    return
                }
                
                let ciContext = CIContext(options: nil)
                
                guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else {
                    return
                }
                
                showImage = UIImage(
                    cgImage: cgImage,
                    scale: 1.0,
                    orientation: rotate
                )
            } label: {
                Text("エフェクト")
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundStyle(Color.white)
            }
            .padding()
            
            //  シェア機能
            if let showImage {
                let shareImage = Image(uiImage: showImage)
                ShareLink(item: shareImage, subject: nil, message: nil, preview: SharePreview("Photo", image: shareImage)) {
                    Text("シェア")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundStyle(Color.white)
                }
                .padding()
            }
            
            Button {
                isShowSheet.toggle()
            } label: {
                Text("閉じる")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundStyle(Color.white)
            }
            .padding()
        }
        
        .onAppear {
            showImage = captureImage
        }
    }
}

#Preview {
    EffectView(
        isShowSheet: .constant(true),
        captureImage: UIImage(named: "preview_use")!
    )
}
