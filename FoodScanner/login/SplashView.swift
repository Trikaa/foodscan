import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            AuthGateView()
        } else {
            VStack {
                Spacer()
                
                Image(systemName: "leaf.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.green)
                
                Text("foodscanner".localized)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Spacer()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
