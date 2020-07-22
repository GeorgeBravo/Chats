import UIKit

final class ItemWithPhoto: UICollectionViewCell {
    
    public var block: (() -> Int)?
    
    lazy var imageView: UIImageView = {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFill
        $0.maskToBounds = true
        return $0
    }(UIImageView())
    
    lazy var unselectedCircle: UIView = {
        $0.backgroundColor = .clear
        $0.borderWidth = 2
        $0.borderColor = .white
        $0.maskToBounds = false
        return $0
    }(UIView())
    
    lazy var selectedCircle: UIView = {
        $0.backgroundColor = .clear
        $0.borderWidth = 2
        $0.borderColor = .white
        $0.maskToBounds = false
        return $0
    }(UIView())
    
    lazy var selectedPoint: UILabel = {
        $0.textColor = UIColor.white
        $0.textAlignment = .center
        $0.backgroundColor = UIColor(hex: 0x007AFF)
        return $0
    }(UILabel())
    
    lazy var videoImageVIew: UIImageView = {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFill
        $0.maskToBounds = true
        $0.image = UIImage(named: "videoAsset")
        $0.isHidden = true
        return $0
    }(UIImageView())
    
    lazy var videoDurationLabel: UILabel = {
        $0.textColor = UIColor.white
        $0.textAlignment = .center
        $0.backgroundColor = UIColor.clear
        return $0
    }(UILabel())
    
    
    fileprivate let inset: CGFloat = 6
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override var isSelected: Bool {
          didSet {
              selectionDidChange(from: oldValue)
          }
      }

      func selectionDidChange(from oldValue: Bool) {
          guard isSelected != oldValue else { return }
          unselectedCircle.isHidden = isSelected
          selectedPoint.isHidden = !isSelected
          selectedCircle.isHidden = !isSelected
      }
    
    public func setup() {
        backgroundColor = .clear
        
        let unselected: UIView = UIView()
        unselected.addSubview(imageView)
        unselected.addSubview(unselectedCircle)
        unselected.addSubview(selectedCircle)
        unselected.addSubview(selectedPoint)
        backgroundView = unselected
        
        selectedCircle.isHidden = true
        selectedPoint.isHidden = true
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.frame
        imageView.cornerRadius = 12
        updateAppearance(forCircle: unselectedCircle)
        updateAppearance(forCircle: selectedCircle)
        updateAppearance(forPoint: selectedPoint)
        imageView.addSubview(videoImageVIew) {
                   $0.leading == imageView.leadingAnchor + 10
                   $0.bottom == imageView.bottomAnchor - 5
                          $0.width == 25
                          $0.height == 15
                      }
        imageView.addSubview(videoDurationLabel) {
            $0.trailing == imageView.trailingAnchor - 10
            $0.bottom == imageView.bottomAnchor - 5
            $0.height == 15
        }
    }
    
    func updateAppearance(forCircle view: UIView) {
        view.frame.size = CGSize(width: 28, height: 28)
        view.frame.origin.x = imageView.bounds.width - unselectedCircle.bounds.width - inset
        view.frame.origin.y = inset
        view.circleCorner = true
        view.shadowColor = UIColor.black.withAlphaComponent(0.4)
        view.shadowOffset = .zero
        view.shadowRadius = 4
        view.shadowOpacity = 0.2
        view.shadowPath = UIBezierPath(roundedRect: unselectedCircle.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: unselectedCircle.bounds.width / 2, height: unselectedCircle.bounds.width / 2)).cgPath
        view.shadowShouldRasterize = true
        view.shadowRasterizationScale = UIScreen.main.scale
    }
    
    func updateAppearance(forPoint view: UIView) {
        view.frame.size = CGSize(width: unselectedCircle.width - (unselectedCircle.borderWidth ?? 0) * 2, height: unselectedCircle.height - (unselectedCircle.borderWidth ?? 0) * 2)
        view.center = selectedCircle.center
        view.circleCorner = true
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        UIView.animate(withDuration: 0.3) {

         self.layoutIfNeeded()
        }
    }
}
