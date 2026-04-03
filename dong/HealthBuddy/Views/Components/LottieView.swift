import SwiftUI

#if canImport(Lottie)
import Lottie

struct LottieView: UIViewRepresentable {
    var name: String
    var loopMode: LottieLoopMode = .loop
    var animationSpeed: CGFloat = 1.0
    
    func makeUIView(context: Context) -> LottieAnimationView {
        let view = LottieAnimationView(name: name, bundle: .main)
        view.loopMode = loopMode
        view.animationSpeed = animationSpeed
        view.contentMode = .scaleAspectFit
        view.play()
        return view
    }
    
    func updateUIView(_ uiView: LottieAnimationView, context: Context) {}
}
#endif

/// 如果没有 Lottie 库时的 Mock 占位视图，用于开发调试
struct MockLottieView: View {
    var name: String
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            Text("🐻")
                .font(.system(size: 80))
                .scaleEffect(isAnimating ? 1.1 : 0.9)
                .rotationEffect(.degrees(isAnimating ? 5 : -5))
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }
            Text("(Lottie: \(name))")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}
