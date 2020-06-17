import UIKit
import Foundation
import CoreFoundation
import CoreText
import CoreGraphics

public enum LabelStrokePosition : Int {
    case outside
    case center
    case inside
}

public struct LabelFadeTruncatingMode : OptionSet {
    public let rawValue: Int
    public init(rawValue:Int) { self.rawValue = rawValue}
    
    static let none = LabelFadeTruncatingMode(rawValue: 0)
    static let tail = LabelFadeTruncatingMode(rawValue: 1 << 0)
    static let head = LabelFadeTruncatingMode(rawValue: 1 << 1)
    static let headAndTail : LabelFadeTruncatingMode = [.tail, .head]
}

open
class StrokeLabel: UILabel {
    
    // MARK: - Accessors and Mutators
    
    open var letterSpacing: CGFloat     = 0.0
   	open var lineSpacing: CGFloat       = 0.0
    
    private var _shadowBlur: CGFloat    = 10.2
    open var shadowBlur: CGFloat {
        get {
            return _shadowBlur
        }
        set {
            _shadowBlur = CGFloat(fmaxf(Float(newValue), 0.0))
        }
    }
    
    open var innerShadowBlur: CGFloat = 3.0
    open var innerShadowOffset: CGSize = CGSize(width: 0.0, height: 2.0)
    open var innerShadowColor: UIColor = UIColor.Button.titleText
    
    open var strokeSize: CGFloat = 0.0
    open var strokeColor: UIColor = .white
    open var strokePosition: LabelStrokePosition  = LabelStrokePosition.outside

    var gradientColors : [UIColor] = []
    
    open var fadeTruncatingMode: LabelFadeTruncatingMode  = LabelFadeTruncatingMode.none
    
    private var _textInsets : UIEdgeInsets  = UIEdgeInsets.zero
    open var textInsets : UIEdgeInsets {
        get {
            return _textInsets
        }
        set {
            if _textInsets != newValue {
                _textInsets = newValue
                self.setNeedsDisplay()
            }
        }
    }
    
    open var isAutomaticallyAdjustTextInsets: Bool = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.setDefaults()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setDefaults()
    }
    
    fileprivate func setDefaults() {
        self.clipsToBounds = false
        self.isAutomaticallyAdjustTextInsets = true
    }
    
    fileprivate func hasGradient() -> Bool {
        return self.gradientColors.count > 1
    }
    
    fileprivate func hasFadeTruncating() -> Bool {
        return self.fadeTruncatingMode != LabelFadeTruncatingMode.none
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.intrinsicContentSize
    }
    
    override open var intrinsicContentSize: CGSize {
        get {
            if self.text == nil || (self.text == "") {
                return CGSize.zero
            }
            let textRect = self.frameRef(from: CGSize(width: CGFloat(self.preferredMaxLayoutWidth), height: CGFloat.greatestFiniteMagnitude)).CGRect
            let newWidth = textRect.width + self.textInsets.left + self.textInsets.right
            let newHeight = textRect.height + self.textInsets.top + self.textInsets.bottom
            return CGSize(width: CGFloat(ceilf(Float(newWidth))), height: CGFloat(ceilf(Float(newHeight))))
        }
    }
    
    fileprivate func strokeSizeDependentOnStrokePosition() -> CGFloat {
        switch self.strokePosition {
        case .center:
            return self.strokeSize
        default:
            // Stroke width times 2, because CG draws a centered stroke. We cut the rest into halves.
            return self.strokeSize * 2.0
        }
    }

    func drawStroke(_ rect: CGRect, context: CGContext) {
        var alphaMask: CGImage? = nil
        
        let frameRef: CTFrame
        if strokePosition == .outside {
            var frame = self.bounds.size
            frame.width += strokeSizeDependentOnStrokePosition()
            frame.height += strokeSizeDependentOnStrokePosition()
            frameRef = self.frameRef(from: frame).CTFrame
        }
        else {
            let cframe = self.frameRef(from: self.bounds.size)
            frameRef = cframe.CTFrame
        }
        
        // -------
        // Step 2: Prepare mask.
        // -------
        context.saveGState()
        // Draw alpha mask.
        context.setTextDrawingMode(.fill)
        UIColor.white.setFill()
        CTFrameDraw(frameRef, context)
        // Save alpha mask.
        alphaMask = context.makeImage()
        // Clear the content.
        context.clear(rect)
        context.restoreGState()
        
        context.saveGState()
        context.setTextDrawingMode(.stroke)
        var image: CGImage? = nil
        if self.strokePosition == .outside {
            // Create an image from the text.
            image = context.makeImage()
        }
        else if self.strokePosition == .inside {
            // Clip the current context to alpha mask.
            context.clip(to: rect, mask: alphaMask!)
        }

        if self.strokePosition == .outside {
            var frame = rect
            frame.size.width += strokeSizeDependentOnStrokePosition()
            frame.size.height += strokeSizeDependentOnStrokePosition()
            // Draw stroke.
            let strokeImage = self.strokeImage(with: frame, frameRef: frameRef, strokeSize: self.strokeSizeDependentOnStrokePosition(), stroke: self.strokeColor)
            context.draw(strokeImage, in: rect)
            // Draw the saved image over half of the stroke.
            context.draw(image!, in: rect)
        }
        else {
            // Draw stroke.
            let strokeImage = self.strokeImage(with: rect, frameRef: frameRef, strokeSize: self.strokeSizeDependentOnStrokePosition(), stroke: self.strokeColor)
            context.draw(strokeImage, in: rect)
        }
        // Clean up.
        context.restoreGState()

    }
    
    func drawShadow(_ rect: CGRect, context: CGContext) {
        // -------
        // Step 7: Draw shadow.
        // -------

        context.saveGState()
        // Create an image from the text.
        let image = context.makeImage()
        // Clear the content.
        context.clear(rect)
        // Set shadow attributes.
        context.setShadow(offset: self.innerShadowOffset, blur: self.innerShadowBlur, color: self.innerShadowColor.cgColor)
        // Draw the saved image, which throws off a shadow.
        context.draw(image!, in: rect)
        // Clean up.
        context.restoreGState()

    }
    
    open override func draw(_ rect: CGRect) {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        
        context.translateBy(x: 0.0, y: rect.height)
        context.scaleBy(x: 1.0, y: -1.0)
        drawStroke(rect, context: context)
        
        context.translateBy(x: 0.0, y: rect.height)
        context.scaleBy(x: 1.0, y: -1.0)
        super.drawText(in: rect)

        context.translateBy(x: 0.0, y: rect.height)
        context.scaleBy(x: 1.0, y: -1.0)
        //drawShadow(rect, context: context)

        layer.shadowColor = UIColor.Base.darkBlue.cgColor
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.masksToBounds = false

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        image.draw(in: rect)
    }
    
    fileprivate func frameRef(from size: CGSize) -> (CTFrame: CTFrame, CGRect: CGRect) {
        // Set up font.
        var alignment = CTTextAlignment(self.textAlignment)
        var lineBreakMode = CTLineBreakModeFromUILineBreakMode(self.lineBreakMode)
        var lineSpacing = self.lineSpacing
        let paragraphStyleettings: [CTParagraphStyleSetting] = [
			CTParagraphStyleSetting(spec: .alignment, valueSize: MemoryLayout.size(ofValue: alignment), value: &alignment),
            CTParagraphStyleSetting(spec: .lineBreakMode, valueSize: MemoryLayout.size(ofValue: lineBreakMode), value: &lineBreakMode),
            CTParagraphStyleSetting(spec: .lineSpacingAdjustment, valueSize: MemoryLayout.size(ofValue: lineSpacing), value: &lineSpacing)
            ]
        
        let paragraphStyleRef = CTParagraphStyleCreate(paragraphStyleettings, paragraphStyleettings.count)
        let kernRef = CFNumberCreate(kCFAllocatorDefault, .cgFloatType, &letterSpacing)
        // Set up attributed string.
        
        let attributedStringRef: CFAttributedString
        var literalAttr: [AnyHashable: Any] = [:]
        if let attributedString = self.attributedText {
            let attr = attributedString.attributes(at: 0, effectiveRange: nil)
            if let font = attr[.font] as? UIFont {
                let fontRef = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
                literalAttr[kCTFontAttributeName] = fontRef
            }
            literalAttr[kCTForegroundColorAttributeName] = (attr[.foregroundColor] as? UIColor)?.cgColor
            literalAttr[kCTKernAttributeName] = kernRef
            literalAttr[kCTParagraphStyleAttributeName] = paragraphStyleRef
            if let rawValue = attr[.underlineStyle] as? Int {
                let underlineStyle = NSUnderlineStyle(rawValue: rawValue)
                switch underlineStyle {
                case .single:
                    literalAttr[kCTUnderlineStyleAttributeName] = CTUnderlineStyle.single.rawValue as CFNumber
                case .double:
                    literalAttr[kCTUnderlineStyleAttributeName] = CTUnderlineStyle.double.rawValue as CFNumber
                case .thick:
                    literalAttr[kCTUnderlineStyleAttributeName] = CTUnderlineStyle.thick.rawValue as CFNumber
                case .patternDash:
                    literalAttr[kCTUnderlineStyleAttributeName] = CTUnderlineStyleModifiers.patternDash.rawValue as CFNumber
                case .patternDot:
                    literalAttr[kCTUnderlineStyleAttributeName] = CTUnderlineStyleModifiers.patternDot.rawValue as CFNumber
                case .patternDashDot:
                    literalAttr[kCTUnderlineStyleAttributeName] = CTUnderlineStyleModifiers.patternDashDot.rawValue as CFNumber
                case .patternDashDotDot:
                    literalAttr[kCTUnderlineStyleAttributeName] = CTUnderlineStyleModifiers.patternDashDotDot.rawValue as CFNumber
                default:
                    break
                }
            }
            literalAttr[kCTUnderlineColorAttributeName] = (attr[.underlineColor] as? UIColor)?.cgColor
        }
        else {
            let fontRef = CTFontCreateWithName(self.font.fontName as CFString, self.font.pointSize, nil)
            literalAttr[kCTFontAttributeName] = fontRef
            literalAttr[kCTForegroundColorAttributeName] = self.textColor.cgColor
            literalAttr[kCTKernAttributeName] = kernRef
            literalAttr[kCTParagraphStyleAttributeName] = paragraphStyleRef
        }
        
        let attributes: NSDictionary = NSDictionary(dictionary: literalAttr)
        let stringRef = self.text! as CFString
        attributedStringRef = CFAttributedStringCreate(kCFAllocatorDefault, stringRef, attributes as CFDictionary)
        
        // Set up frame.
        let framesetterRef = CTFramesetterCreateWithAttributedString(attributedStringRef)
        if self.isAutomaticallyAdjustTextInsets {
            self.textInsets = self.fittingTextInsets()
        }
        
        let contentRect = self.contentRect(from: size, with: self.textInsets)
        let textRect = self.textRect(fromContentRect: contentRect, framesetterRef: framesetterRef)
        let pathRef = CGMutablePath()
        pathRef.addRect(textRect, transform: .identity)
        let frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, self.text!.count), pathRef, nil)
        
        return (frameRef, textRect)
    }
    
    fileprivate func contentRect(from size: CGSize, with insets: UIEdgeInsets) -> CGRect {
        var contentRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        // Apply insets.
        contentRect.origin.x += insets.left
        contentRect.origin.y += insets.top
        contentRect.size.width -= insets.left + insets.right
        contentRect.size.height -= insets.top + insets.bottom
        return contentRect
    }
    
    fileprivate func textRect(fromContentRect contentRect: CGRect, framesetterRef: CTFramesetter) -> CGRect {
        var suggestedTextRectSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetterRef, CFRangeMake(0, self.text!.count), nil, contentRect.size, nil)
        if suggestedTextRectSize.equalTo(CGSize.zero) {
            suggestedTextRectSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetterRef, CFRangeMake(0, self.text!.count), nil, CGSize(width: CGFloat(CGFloat.greatestFiniteMagnitude), height: CGFloat(CGFloat.greatestFiniteMagnitude)), nil)
        }
        var textRect = CGRect(x: 0, y: 0, width: CGFloat(ceilf(Float(suggestedTextRectSize.width))), height: CGFloat(ceilf(Float(suggestedTextRectSize.height))))
        // Horizontal alignment.
        switch self.textAlignment {
        case .center:
            textRect.origin.x = CGFloat(floorf(Float(contentRect.minX + (contentRect.width - textRect.width) / 2.0)))
        case .right:
            textRect.origin.x = CGFloat(floorf(Float(contentRect.minX + contentRect.width - textRect.width)))
        default:
            textRect.origin.x = CGFloat(floorf(Float(contentRect.minX)))
        }
        
        // Vertical alignment. Top and bottom are upside down, because of inverted drawing.
        switch self.contentMode {
        case .top, .topLeft, .topRight:
            textRect.origin.y = CGFloat(floorf(Float(contentRect.minY + contentRect.height - textRect.height)))
        case .bottom, .bottomLeft, .bottomRight:
            textRect.origin.y = CGFloat(floorf(Float(contentRect.minY)))
        default:
           textRect.origin.y = CGFloat(floorf(Float(contentRect.minY) + floorf(Float((contentRect.height - textRect.height)) / 2.0)))
        }
        
        return textRect
    }
    
    fileprivate func fittingTextInsets() -> UIEdgeInsets {

        var edgeInsets = UIEdgeInsets.zero

        switch self.strokePosition {
        case .outside:
            edgeInsets = UIEdgeInsets(top: self.strokeSize, left: self.strokeSize, bottom: self.strokeSize, right: self.strokeSize)
        case .inside:
            edgeInsets = UIEdgeInsets(top: self.strokeSize / 2.0, left: self.strokeSize / 2.0, bottom: self.strokeSize / 2.0, right: self.strokeSize / 2.0)
        default:
            break
        }
        return edgeInsets
    }
    
    // MARK: - Image Functions
    
    fileprivate func inverseMask(fromAlphaMask alphaMask: CGImage, with rect: CGRect) -> CGImage {
        // Create context.
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        // Fill rect, clip to alpha mask and clear.
        UIColor.white.setFill()
        UIRectFill(rect)
        context.clip(to: rect, mask: alphaMask)
        context.clear(rect)
        // Return image.
        let image = context.makeImage()
        UIGraphicsEndImageContext()
        return image!
    }
    
    fileprivate func strokeImage(with rect: CGRect, frameRef: CTFrame, strokeSize: CGFloat, stroke strokeColor: UIColor) -> CGImage {
        // Create context.
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        context.setTextDrawingMode(.stroke)
        // Draw clipping mask.
        context.setLineWidth(strokeSize)
        context.setLineJoin(.round)
        UIColor.white.setStroke()
        CTFrameDraw(frameRef, context)
        // Save clipping mask.
        let clippingMask = context.makeImage()
        // Clear the content.
        context.clear(rect)
        // Draw stroke.
        context.clip(to: rect, mask: clippingMask!)
        context.translateBy(x: 0.0, y: rect.height)
        context.scaleBy(x: 1.0, y: -1.0)
        strokeColor.setFill()
        UIRectFill(rect)

        // Clean up and return image.
        // Create gradient from white to black.

        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors.map {$0.cgColor} as CFArray, locations: nil) {
        // Draw head and/or tail gradient.
            context.drawLinearGradient(gradient, start: CGPoint.zero, end: CGPoint(x: rect.width, y: rect.height), options: [])
        }
        let image = context.makeImage()
        UIGraphicsEndImageContext()
        return image!
    }
    
    fileprivate func linearGradientImage(with rect: CGRect, fadeHead: Bool, fadeTail: Bool) -> CGImage {
        // Create an opaque context.
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        // White background will mask opaque, black gradient will mask transparent.
        UIColor.white.setFill()
        UIRectFill(rect)
        // Create gradient from white to black.
        let locs : [CGFloat] = [0.0, 1.0]
        let components : [CGFloat] = [1.0, 1.0, 0.0, 1.0]
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: components, locations: locs, count: 2)!
        // Draw head and/or tail gradient.
        let fadeWidth: CGFloat = CGFloat(fminf(Float(rect.height * 2.0), floorf(Float(rect.width / 4.0))))
        let minX: CGFloat = rect.minX
        let maxX: CGFloat = rect.maxX
        if fadeTail {
            let startX: CGFloat = maxX - fadeWidth
            let startPoint = CGPoint(x: startX, y: CGFloat(rect.midY))
            let endPoint = CGPoint(x: maxX, y: CGFloat(rect.midY))
            context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        }
        if fadeHead {
            let startX: CGFloat = minX + fadeWidth
            let startPoint = CGPoint(x: startX, y: CGFloat(rect.midY))
            let endPoint = CGPoint(x: minX, y: CGFloat(rect.midY))
            context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        }
        // Clean up and return image.
        
        let image = context.makeImage()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func CTLineBreakModeFromUILineBreakMode(_ lineBreakMode: NSLineBreakMode) -> CTLineBreakMode {
        switch (lineBreakMode) {
        case .byWordWrapping: return .byWordWrapping;
        case .byCharWrapping: return .byCharWrapping;
        case .byClipping: return .byClipping;
        case .byTruncatingHead: return .byTruncatingHead;
        case .byTruncatingTail: return .byTruncatingTail;
        case .byTruncatingMiddle: return .byTruncatingMiddle;
        @unknown default:
            fatalError()
        }
    }
}

extension CGSize {
    func scale(w: CGFloat, h: CGFloat) -> CGSize {
        return CGSize(width: width * w, height: height * h)
    }
}

class GradientLabel: UILabel {
    var gradientColors: [CGColor] = []

    override func drawText(in rect: CGRect) {
        if let gradientColor = drawGradientColor(in: rect, colors: gradientColors) {
            self.textColor = gradientColor
        }
        super.drawText(in: rect)
    }

    private func drawGradientColor(in rect: CGRect, colors: [CGColor]) -> UIColor? {
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.saveGState()
        defer { currentContext?.restoreGState() }

        let size = rect.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: colors as CFArray,
                                        locations: nil) else { return nil }

        let context = UIGraphicsGetCurrentContext()
        context?.drawLinearGradient(gradient,
                                    start: CGPoint.zero,
                                    end: CGPoint(x: size.width, y: 0),
                                    options: [])
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let image = gradientImage else { return nil }
        return UIColor(patternImage: image)
    }


}
