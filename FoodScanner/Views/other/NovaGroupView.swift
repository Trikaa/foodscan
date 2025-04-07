import SwiftUI

struct NovaGroupView: View {
    let novaGroup: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(1...4, id: \.self) { number in
                Text("\(number)")
                    .frame(width: 50, height: 50)
                    .background(backgroundColor(for: number))
                    .foregroundColor(.white)
                    .font(.title.bold())
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: novaGroup == number ? 3 : 0)
                    )
            }
        }
        .cornerRadius(10)
    }
    
    func backgroundColor(for number: Int) -> Color {
        switch number {
        case 1: return Color.green
        case 2: return Color.yellow
        case 3: return Color.orange
        case 4: return Color.red
        default: return Color.gray
        }
    }
}
