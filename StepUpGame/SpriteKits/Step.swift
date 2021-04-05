import Foundation
import SpriteKit

class Step: SKSpriteNode {
    init(name: String) {
        let texture = SKTexture(imageNamed: name)
        super.init(texture: texture, color: .clear, size: CGSize(width: 75, height: 75))
        zPosition = 3.0
        isUserInteractionEnabled = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
