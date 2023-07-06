//
//  ContentView.swift
//  MyCamera
//
//  Created by 藤川賢也 on 2023/05/01.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    //撮影した写真を保存する状態変数
    @State var captureImage:UIImage? = nil
    //撮影画面（sheet)の開閉状態を管理
    @State var isShowSheet = false
    //フォトライブラリーで選択した写真を管理
    @State var photoPickerSelectedImage: PhotosPickerItem? = nil
    
    var body: some View {
        VStack {
            //スペース追加
            Spacer()
            //撮影した写真がある時
            if let captureImage{
                //撮影写真を表示
                Image(uiImage: captureImage)
                //リサイズ
                    .resizable()
                //アスペクト比(縦横比)を維持して画面に収める
                    .scaledToFit()
            }
            Spacer()
            //「カメラを起動する」ボタン
            Button{
                //カメラが利用可能かチェック
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    print("カメラは使用できます")
                    //カメラが使えるなら、isShowSheetをtrue
                    isShowSheet.toggle()
                }else{
                    print("カメラは使用できません")
                }
                //ボタンをタップした時のアクション
            }label: {
                Text("カメラを起動する")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                //文字列をセンタリング指定
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }//カメラを起動するボタンここまで
            //上下左右に余白を追加
            .padding()
            //sheetを表示
            //isPresentedで指定した状態変数がtrueの時実行
            .sheet(isPresented: $isShowSheet){
                //UIImagePickerCntroller(写真撮影）を表示
                ImagePickerView(isShowSheet: $isShowSheet, captureImage: $captureImage)
            }
            
            //フォトライブラリーから選択する
            PhotosPicker(selection: $photoPickerSelectedImage, matching: .images,preferredItemEncoding: .automatic, photoLibrary:.shared()){
                Text("フォトライブラリーから選択する")
                    .frame(maxWidth:.infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .padding()
            }//PhotosPickerここまで
            //選択した写真をもとに写真を取り出す
            .onChange(of: photoPickerSelectedImage){ photosPickerItem in
                //選択した写真がある時
                if let photosPickerItem{
                    //Data型で写真を取り出す
                    photosPickerItem.loadTransferable(type: Data.self) { result in switch result{
                    case.success(let data):
                        //写真がある時
                        if let data{
                            //写真をcaptureImageに保存
                            captureImage = UIImage(data: data)
                        }
                    case.failure:
                        return
                    }
                        
                    }
                }
            }//onChangeここまで
            //captureImageをアンラップする
            if let captureImage{
               //captureImageから共有する画面を生成する
               let shareImage = Image(uiImage: captureImage)
                //共有シート
                ShareLink(item: shareImage, subject: nil, message: nil,
                          preview: SharePreview("photo",image: shareImage)) {
                    Text("SNSに投稿する")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .padding()
                } //shareLinkここまで
            }//アンラップここまで
            
        }//VStackここまで
    }//boddyここまで
}//ContentViewここまで

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
