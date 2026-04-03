import SwiftUI
import PhotosUI

struct CalorieRecognitionView: View {
    @ObservedObject var buddy: Buddy
    @EnvironmentObject private var calorieManager: CalorieManager
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(12)
                    .padding()
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "photo.on.rectangle")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("请选择一张食物照片")
                        .foregroundColor(.secondary)
                }
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding()
            }
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Label("从相册选择", systemImage: "photo.fill")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .onChange(of: selectedItem) { oldValue, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImage = image
                        calorieManager.processImage(image)
                    }
                }
            }
            
            if calorieManager.isProcessing {
                ProgressView("正在识别食物中...")
                    .padding()
            } else if !calorieManager.recognitionResults.isEmpty {
                List(calorieManager.recognitionResults) { result in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(result.name)
                                .font(.headline)
                            Text("\(Int(result.calories)) 大卡")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Button("喂食") {
                            buddy.consumeFood(calories: result.calories)
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.orange)
                    }
                }
                .listStyle(.plain)
            }
            
            Spacer()
        }
        .navigationTitle("拍照识别卡路里")
        .navigationBarTitleDisplayMode(.inline)
    }
}
