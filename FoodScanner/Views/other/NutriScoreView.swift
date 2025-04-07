import SwiftUI

struct NutriScoreView: View {
    let nutriScore: String
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(["A", "B", "C", "D", "E"], id: \.self) { letter in
                Text(letter)
                    .frame(width: 50, height: 50)
                    .background(backgroundColor(for: letter))
                    .foregroundColor(.white)
                    .font(.title.bold())
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: nutriScore.uppercased() == letter ? 3 : 0)
                    )
            }
        }
        .cornerRadius(10)
    }
    
    func backgroundColor(for letter: String) -> Color {
        switch letter {
        case "A": return Color.green
        case "B": return Color(#colorLiteral(red: 0.8, green: 0.9, blue: 0.0, alpha: 1))
        case "C": return Color.yellow
        case "D": return Color.orange
        case "E": return Color.red
        default: return Color.gray
        }
    }
}
