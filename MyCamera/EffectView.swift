//
//  EffectView.swift
//  MyCamera
//
//  Created by 藤川賢也 on 2023/07/06.
//

import SwiftUI

struct EffectView: View {
    //エフェクト編集画面（sheet）の開閉状態を管理
    @Binding var isShowSheet: Bool
    //撮影した写真
    let captureImage: UIImage
    //表示する写真
    @State var showImage: UIImage?
    
    var body: some View {
        //縦方向にレイアウト
        VStack{
            //スペース追加
            Spacer()
            if let showImage{
                //表示する写真がある場合は画面に表示
                Image (uiImage: showImage)
                    .resizable()
                    .scaledToFit()
            }//if
            Spacer()
            Button{
                //ボタンをタップした時のアクション
            }label: {
                Text("エフェクト")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }//エフェクトここまで
            .padding()
            
            //showImageをアンラップする
            if let showImage{
                //captureImageから共有する画像を生成する
                let shareImage = Image(uiImage: showImage)
                //共有シート
                ShareLink(item: shareImage,subject: nil, message: nil,preview: SharePreview("photo",image: shareImage)){
                    Text("シェア")
                        .frame(maxWidth:.infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                }//shareLInk
                .padding()
            }//アンラップここまで
            
            //「閉じる」ボタン
            Button{
            }label: {
                Text("閉じる")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                
            }
            .padding()
        }//VStack
        //写真が表示されるときに実行される
        .onAppear{
            //撮影した写真を表示する写真に設定)
            showImage = captureImage
        }
    }
    
    struct EffectView_Previews: PreviewProvider {
        static var previews: some View {
            EffectView(isShowSheet: .constant(true), captureImage: UIImage(named:"preview_use")!)
        }
    }
}
