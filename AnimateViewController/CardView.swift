import UIKit
@IBDesignable
class CardView: UIView {
    @IBInspectable var corner_Radius: CGFloat = 2
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    override func layoutSubviews() {
        layer.cornerRadius = corner_Radius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: corner_Radius)
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        
        
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
}
