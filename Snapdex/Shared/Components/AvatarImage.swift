import SwiftUI

struct AvatarImage: View {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
    }
    
    var imageName: String {
        switch id {
            case 0: "Avatar01"
            case 1: "Avatar02"
            case 2: "Avatar03"
            case 3: "Avatar04"
            case 4: "Avatar05"
            case 5: "Avatar06"
            case 6: "Avatar07"
            case 7: "Avatar08"
            case 8: "Avatar09"
            default: "Avatar10"
        }
    }
}
