import SwiftUI

struct QuoteView: View {
    @State private var quote: String = ""

    private let quotes = [
        "You miss 100% of the shots you dont take",
        "Small stps every day!",
        "Youre doing great!",
        "Stay consistent!",
        "Quokka believes in you!",
        "Progress, not perfection!"
    ]
    
    var body: some View {
        Text(quotes.randomElement() ?? "")
            .padding()
    }

}
