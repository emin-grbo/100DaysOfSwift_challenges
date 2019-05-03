//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

let artboard = CGRect(x: 0, y: 0, width: 700, height: 700)
let mainView = UIView(frame: artboard)
mainView.backgroundColor = UIColor(red: 64/255, green: 64/255, blue: 69/255, alpha: 1)

// Present the view controller in the Live View window


let renderer = UIGraphicsImageRenderer(bounds: artboard)
let rendered = renderer.image { ctx in

    ctx.cgContext.setLineWidth(0.5)
    
    var xPos: CGFloat = 0
    var yPos: CGFloat = 0
    
    // Text attributes
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    
    let textAttrs: [NSAttributedString.Key:Any] = [
        .font: UIFont.systemFont(ofSize: 12),
        .foregroundColor: UIColor.white,
        .paragraphStyle: paragraphStyle
    ]
    
    
    for _ in 0...5 {
        // Draw vertical lines
        xPos += 100
        let points: [CGPoint] = [
            CGPoint(x: xPos, y: 0),
            CGPoint(x: xPos, y: artboard.height)
        ]
        ctx.cgContext.addLines(between: points)
        
        // Adding text for vertical lines
        let textH = "\(Int(xPos))"
        let topMeasurement = NSAttributedString(string: textH, attributes: textAttrs)
        topMeasurement.draw(in: CGRect(x: xPos - 25, y: 0, width: 50, height: 20))
        
        // Draw horizontal lines
        yPos += 100
        let pointsH: [CGPoint] = [
            CGPoint(x: 0, y: yPos),
            CGPoint(x: artboard.width, y: yPos)
        ]
        
        // Adding text for horizontal lines
        let textV = "\(Int(yPos))"
        let leftMeasurement = NSAttributedString(string: textV, attributes: textAttrs)
        leftMeasurement.draw(in: CGRect(x: 0, y: yPos - 8, width: 25, height: 20))
        
        UIColor.white.withAlphaComponent(0.2).setStroke()
        ctx.cgContext.addLines(between: pointsH)
        ctx.cgContext.drawPath(using: .fillStroke)
    }
    
    // Drawing content
    UIColor.yellow.setFill()
    UIColor.orange.setStroke()
    ctx.cgContext.setLineWidth(10)
    
    let face1 = CGRect(x: 100, y: 100, width: 200, height: 200)
    ctx.cgContext.addEllipse(in: face1)
    ctx.cgContext.drawPath(using: .fillStroke)
    
    UIColor.black.setFill()
    let eye1 = CGRect(x: 140, y: 150, width: 40, height: 40)
    let eye2 = CGRect(x: 220, y: 150, width: 40, height: 40)
    let mouth = CGRect(x: 170, y: 210, width: 60, height: 60)
    
    ctx.cgContext.fillEllipse(in: eye1)
    ctx.cgContext.fillEllipse(in: eye2)
    ctx.cgContext.fillEllipse(in: mouth)
    
    ctx.cgContext.move(to: CGPoint(x: 400, y: 300))
    ctx.cgContext.setLineCap(.round)
    ctx.cgContext.setLineJoin(CGLineJoin.round)
    
    let starLines = [
    CGPoint(x: 400, y: 175),
    CGPoint(x: 470, y: 170),
    CGPoint(x: 500, y: 100),
    CGPoint(x: 530, y: 170),
    CGPoint(x: 600, y: 175),
    CGPoint(x: 550, y: 225),
    CGPoint(x: 570, y: 300),
    CGPoint(x: 500, y: 260),
    CGPoint(x: 430, y: 300),
    CGPoint(x: 450, y: 225),
    CGPoint(x: 400, y: 175)
    ]
    
    ctx.cgContext.addLines(between: starLines)
    
    UIColor.yellow.setFill()
    ctx.cgContext.drawPath(using: .fillStroke)
    
    UIColor.black.setStroke()
    ctx.cgContext.move(to: CGPoint(x: 100, y: 400))
    ctx.cgContext.addLine(to: CGPoint(x: 200, y: 400))
    ctx.cgContext.move(to: CGPoint(x: 150, y: 400))
    ctx.cgContext.addLine(to: CGPoint(x: 150, y: 500))
    ctx.cgContext.move(to: CGPoint(x: 200, y: 400))
    ctx.cgContext.addLine(to: CGPoint(x: 220, y: 500))
    ctx.cgContext.addLine(to: CGPoint(x: 250, y: 450))
    ctx.cgContext.addLine(to: CGPoint(x: 280, y: 500))
    ctx.cgContext.addLine(to: CGPoint(x: 300, y: 400))
    ctx.cgContext.move(to: CGPoint(x: 350, y: 400))
    ctx.cgContext.addLine(to: CGPoint(x: 350, y: 500))
    ctx.cgContext.move(to: CGPoint(x: 400, y: 500))
    ctx.cgContext.addLine(to: CGPoint(x: 400, y: 400))
    ctx.cgContext.addLine(to: CGPoint(x: 500, y: 500))
    ctx.cgContext.addLine(to: CGPoint(x: 500, y: 400))
    ctx.cgContext.strokePath()
}

let renderedImage = UIImageView(image: rendered)
mainView.addSubview(renderedImage)
PlaygroundPage.current.liveView = mainView


