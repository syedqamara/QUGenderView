//
//  QUGenderSketchView.swift
//  GenderSelection
//
//  Created by Syed Qamar Abbas on 4/25/18.
//  Copyright © 2018 Syed Qamar Abbas. All rights reserved.
//

import UIKit

struct AnimationKeys {
    static let UnderGarments = "GenderChangeShouldChangeUnderGarmentsPosition"
    static let BodyCurves = "GenderChangeShouldChangeBodyCurves"
    static let NickerChange = "GenderChangeShouldChangeNickers"
}

public class QUGenderSketchView: UIView {
    var bodyHeight: CGFloat = 0.0
    fileprivate var bodyEndYAxis: CGFloat = 0.0
    fileprivate var bodyEndXAxis: CGFloat = 0.0
    fileprivate var bodyStartXAxis: CGFloat = 0.0
    fileprivate var FootYAxis: CGFloat = 0.0
    fileprivate var lineWidth: CGFloat = 3.0
    fileprivate var oldBodyPath: UIBezierPath?
    fileprivate var oldNickerPath: UIBezierPath?
    fileprivate var headLayer = CAShapeLayer()
    fileprivate var bodyLayer = CAShapeLayer()
    fileprivate var nickerLayer = CAShapeLayer()
    fileprivate var underGarmentsLayer = CAShapeLayer()
    fileprivate var legsLayer = CAShapeLayer()
    fileprivate var lineLayer = CAShapeLayer()
    fileprivate var bellyHoleLayer = CAShapeLayer()
    public var layerColor = UIColor.lightGray
    
    
    public var genderType = GenderType.male {
        willSet(newGender) {
            addHeadLayer()
            animateUnderGarmentsWithGenderType(newGender)
            animateBodyWithNewGenderType(newGender)
            animateNickerWithNewGenderType(newGender)
        }
    }
    
    init(with frame: CGRect, andDefaultGenderType: GenderType, color: UIColor = .lightGray) {
        super.init(frame: frame)
        layerColor = color
        genderType = andDefaultGenderType
        self.backgroundColor = UIColor.clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    fileprivate var headPath: UIBezierPath {
        let headHeight = bounds.height/6
        let hFrame = CGRect(x: (bounds.width/2) - (headHeight/2), y: 10, width: headHeight, height: headHeight)
        let path = UIBezierPath(ovalIn: hFrame)
        path.close()
        return path
    }
    fileprivate func bodyPath(type: GenderType) -> UIBezierPath {
        let armBodyMargin: CGFloat = (bounds.width/37.5)
        let headHeight = bounds.height/6
        let topY = (bounds.width/12.5) + headHeight
        let startX = (bounds.width/2) - (headHeight/1.2)
        let EndX = (bounds.width/2) + (headHeight/1.2)
        
        let neckInit = (bounds.width/2) - (headHeight/3.5)
        let neckFinal = (bounds.width/2) + (headHeight/3.5)
        
        let rightArmRightSideY = topY + (headHeight * 1.5)
        let rightArmRightSideX = EndX + armBodyMargin
        let rightArmLeftSideX = EndX - armBodyMargin
        
        let rightUnderArmY = topY + (bounds.width/12.5)
        let rightUnderArmX = EndX - (bounds.width/12.5)
        
        let bodyEndY = rightArmRightSideY 
        
        let arcDifference = ((armBodyMargin * 2))
        
        let leftUnderArmX = startX + (bounds.width/12.5)
        
        let leftArmRightSideX = startX + armBodyMargin
        let leftArmLeftSideX = startX - armBodyMargin
        
        
        let bodyCenterY = ((bodyEndY - rightUnderArmY)/2) + rightUnderArmY
        let bodyRightControlX = rightUnderArmX - (bounds.width/15)
        let bodyLeftControlX = leftUnderArmX + (bounds.width/15)
        
        //Globally Store Body Parts Positions
        bodyEndYAxis = bodyEndY
        bodyEndXAxis = rightUnderArmX
        bodyStartXAxis = leftUnderArmX
        
        bodyHeight = bodyEndYAxis - topY
        
        //All Positions
        let startPosition = CGPoint(x: startX, y: topY)
        let startPositionAfter = CGPoint(x: startX + (arcDifference), y: topY)
        let startPositionBelow = CGPoint(x: startX, y: topY + arcDifference)
        let neckInitialPosition = CGPoint(x: neckInit, y: topY)
        let neckFinalPosition = CGPoint(x: neckFinal, y: topY)
        let neckControlPoint = CGPoint(x: bounds.width/2, y: topY-(bounds.width/25))
        
        let endPosition = CGPoint(x: EndX, y: topY)
        let endPositionBefore = CGPoint(x: EndX - (arcDifference), y: topY)
        let endPositionUnder = CGPoint(x: EndX, y: topY + (arcDifference))
        let rightArmRightSidePosition = CGPoint(x: rightArmRightSideX, y: rightArmRightSideY)
        let rightArmLeftSidePosition = CGPoint(x: rightArmLeftSideX, y: rightArmRightSideY)
        let rightArmControlPoint = CGPoint(x: EndX, y: rightArmRightSideY + armBodyMargin)
        
        let rightUnderArmPosition = CGPoint(x: rightUnderArmX, y: rightUnderArmY)
        let bodyRightEndPosition = CGPoint(x: rightUnderArmX, y: bodyEndY)
        
        
        let bodyLeftEndPosition = CGPoint(x: leftUnderArmX, y: bodyEndY)
        let leftUnderArmPosition = CGPoint(x: leftUnderArmX, y: rightUnderArmY)
        
        let leftArmRightPosition = CGPoint(x: leftArmRightSideX, y: rightArmRightSideY)
        let leftArmLeftPosition = CGPoint(x: leftArmLeftSideX, y: rightArmRightSideY)
        let leftArmControlPoint = CGPoint(x: startX, y: rightArmRightSideY + armBodyMargin)
        
        let femaleControlPointRight = CGPoint(x: bodyRightControlX, y: bodyCenterY)
        let femaleControlPointLeft = CGPoint(x: bodyLeftControlX, y: bodyCenterY)
        
        let path = UIBezierPath()
        path.move(to: startPositionAfter)
        path.addLine(to: neckInitialPosition)
        path.addQuadCurve(to: neckFinalPosition, controlPoint: neckControlPoint)
        path.addLine(to: endPositionBefore)
        path.addQuadCurve(to: endPositionUnder, controlPoint: endPosition)
        path.addLine(to: rightArmRightSidePosition)
        path.addQuadCurve(to: rightArmLeftSidePosition, controlPoint: rightArmControlPoint)
        path.addLine(to: rightUnderArmPosition)
        
        if type == .female {
            path.addQuadCurve(to: bodyRightEndPosition, controlPoint: femaleControlPointRight)
        }else {
            path.addLine(to: bodyRightEndPosition)// write this into an if statement
        }
        path.addLine(to: bodyLeftEndPosition)
        
        if type == .female {
            path.addQuadCurve(to: leftUnderArmPosition, controlPoint: femaleControlPointLeft)
        }else {
            path.addLine(to: leftUnderArmPosition)
        }
        path.addLine(to: leftArmRightPosition)
        path.addQuadCurve(to: leftArmLeftPosition, controlPoint: leftArmControlPoint)
        path.addLine(to: startPositionBelow)
        path.addQuadCurve(to: startPositionAfter, controlPoint: startPosition)
        
        return path
    }
    
    fileprivate func nickerPath(_ gender: GenderType) -> UIBezierPath {
        let armBodyMargin: CGFloat = (bounds.width/18.75)
        let headHeight = bounds.height/5.5
        
        let leftX = bodyStartXAxis - (armBodyMargin/3)
        let rightX = bodyEndXAxis + (armBodyMargin/3)
        
        let yAxis = bodyEndYAxis - lineWidth
        
        
        
        let topRightPosition = CGPoint(x: rightX, y: yAxis)
        let topLeftPosition = CGPoint(x: leftX, y: yAxis)
        let bottomRightPositionMale = CGPoint(x: rightX, y: yAxis + headHeight)
        let bottomLeftPositionMale = CGPoint(x: leftX, y: yAxis + headHeight)
        
        let bottomRightPositionFemale = CGPoint(x: rightX + armBodyMargin, y: yAxis + headHeight)
        let bottomLeftPositionFemale = CGPoint(x: leftX - armBodyMargin, y: yAxis + headHeight)
        
        let path = UIBezierPath()
        path.move(to: topLeftPosition)
        path.addLine(to: topRightPosition)
        if gender == .male {
            path.addLine(to: bottomRightPositionMale)
            path.addLine(to: bottomLeftPositionMale)
        }else {
            path.addLine(to: bottomRightPositionFemale)
            path.addLine(to: bottomLeftPositionFemale)
        }
        path.addLine(to: topLeftPosition)
        return path
    }
    fileprivate var underGarmentsPath: UIBezierPath {
        let armBodyMargin: CGFloat = (bounds.width/25)
        var headHeight = bounds.height/5.5
        headHeight = headHeight/4
        
        let leftX = bodyStartXAxis - (armBodyMargin/7)
        let rightX = bodyEndXAxis + (armBodyMargin/7)
        
        let yAxis = bodyEndYAxis - lineWidth
        
        
        let topRightPosition = CGPoint(x: rightX, y: yAxis)
        let topLeftPosition = CGPoint(x: leftX, y: yAxis)
        let bottomRightPositionMale = CGPoint(x: rightX, y: yAxis + headHeight)
        let bottomLeftPositionMale = CGPoint(x: leftX, y: yAxis + headHeight)
        
        let path = UIBezierPath()
        path.move(to: topLeftPosition)
        path.addLine(to: topRightPosition)
        path.addLine(to: bottomRightPositionMale)
        path.addLine(to: bottomLeftPositionMale)
        path.addLine(to: topLeftPosition)
        return path
    }
    fileprivate var legsPath: UIBezierPath {
        let armBodyMargin: CGFloat = bounds.width/12.5
        let headHeight = bounds.height/5.5
        
        let leftLegLeftX = bodyStartXAxis + (armBodyMargin/7)
        var leftLegRightX = leftLegLeftX + (headHeight/3)
        let rightLegRightX = bodyEndXAxis - (armBodyMargin/7)
        var rightLegLeftX = rightLegRightX - (headHeight/3)
        
        if rightLegLeftX <= leftLegRightX {
            leftLegRightX = ((rightLegLeftX + leftLegRightX)/2) - (armBodyMargin/10)
            rightLegLeftX = ((rightLegLeftX + leftLegRightX)/2) +  (armBodyMargin/5)
        }
        
        var yAxis = bodyEndYAxis + headHeight
        yAxis = yAxis - lineWidth
        let finalYAxis = yAxis + (headHeight) + armBodyMargin
        FootYAxis = finalYAxis + armBodyMargin/1.3 + lineWidth
        let leftLegTopLeft = CGPoint(x: leftLegLeftX, y: yAxis)
        let leftLegBottomLeft = CGPoint(x: leftLegLeftX, y: finalYAxis)
        
        let leftLegTopRight = CGPoint(x: leftLegRightX, y: yAxis)
        let leftLegBottomRight = CGPoint(x: leftLegRightX, y: finalYAxis)
        
        let rightLegTopLeft = CGPoint(x: rightLegLeftX, y: yAxis)
        let rightLegBottomLeft = CGPoint(x: rightLegLeftX, y: finalYAxis)
        
        let rightLegTopRight = CGPoint(x: rightLegRightX, y: yAxis)
        let rightLegBottomRight = CGPoint(x: rightLegRightX, y: finalYAxis)
        
        let leftLegControlPoint1 = CGPoint(x: leftLegLeftX, y: finalYAxis + (armBodyMargin))
        let leftLegControlPoint2 = CGPoint(x: leftLegRightX, y: finalYAxis + (armBodyMargin))
        
        let rightLegControlPoint1 = CGPoint(x: rightLegLeftX, y: finalYAxis + (armBodyMargin))
        let rightLegControlPoint2 = CGPoint(x: rightLegRightX, y: finalYAxis + (armBodyMargin))
        
        let path = UIBezierPath()
        path.move(to: leftLegTopLeft)
        path.addLine(to: leftLegBottomLeft)
        path.addCurve(to: leftLegBottomRight, controlPoint1: leftLegControlPoint1, controlPoint2: leftLegControlPoint2)
        path.addLine(to: leftLegTopRight)
        path.addLine(to: leftLegTopLeft)
        path.move(to: rightLegTopLeft)
        path.addLine(to: rightLegBottomLeft)
        path.addCurve(to: rightLegBottomRight, controlPoint1: rightLegControlPoint1, controlPoint2: rightLegControlPoint2)
        path.addLine(to: rightLegTopRight)
        path.addLine(to: rightLegTopLeft)
        return path
    }
    
    fileprivate var bottomLinePath: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.bounds.size.width-250, y: FootYAxis))
        path.addLine(to: CGPoint(x: self.bounds.size.width-120, y: FootYAxis))
        path.move(to: CGPoint(x: self.bounds.size.width-100, y: FootYAxis))
        path.addLine(to: CGPoint(x: self.bounds.size.width-80, y: FootYAxis))
        return path
    }
    
    fileprivate var bellyHolePath: UIBezierPath {
        let frame = CGRect(x: bounds.width/2-5, y: bodyEndYAxis - 20, width: 10, height: 10)
        let path = UIBezierPath(ovalIn: frame)
        path.close()
        return path
    }
    
    fileprivate func animateUnderGarmentsWithGenderType(_ newGender: GenderType) {
        
        let animation = CASpringAnimation(keyPath: "position")
        animation.duration = animation.settlingDuration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animation.damping = 300
        animation.mass = 0.02
        animation.initialVelocity = 200
        let newValue = (bodyHeight - (bodyHeight/3)) * -1
        if newGender == .male {
            let newPosition = CGPoint(x: underGarmentsLayer.frame.origin.x, y: 0)
            let oldPosition = CGPoint(x: underGarmentsLayer.frame.origin.x, y: newValue)
            animation.fromValue = NSValue.init(cgPoint: oldPosition)
            animation.toValue = NSValue.init(cgPoint: newPosition)
            underGarmentsLayer.position = newPosition
        }else {
            
            let oldPosition = CGPoint(x: underGarmentsLayer.frame.origin.x, y: 0)
            let newPosition = CGPoint(x: underGarmentsLayer.frame.origin.x, y: newValue)
            animation.fromValue = NSValue.init(cgPoint: oldPosition)
            animation.toValue = NSValue.init(cgPoint: newPosition)
            underGarmentsLayer.position = newPosition
        }
        underGarmentsLayer.add(animation, forKey: AnimationKeys.UnderGarments)
    }
    fileprivate func animateBodyWithNewGenderType(_ newGender: GenderType) {
        guard let oldPath = self.oldBodyPath else {return}
        let newPath = bodyPath(type: newGender)
        let animation = CASpringAnimation(keyPath: "path")
        animation.duration = animation.settlingDuration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animation.damping = 300
        animation.mass = 0.12
        animation.initialVelocity = 100
        animation.fromValue = oldPath.cgPath
        animation.toValue = newPath.cgPath
        animation.isRemovedOnCompletion = false
        bodyLayer.add(animation, forKey: AnimationKeys.BodyCurves)
        bodyLayer.path = newPath.cgPath
    }
    fileprivate func animateNickerWithNewGenderType(_ newGender: GenderType) {
        guard let oldPath = self.oldNickerPath else {return}
        let newPath = nickerPath(newGender)
        let animation = CASpringAnimation(keyPath: "path")
        animation.duration = animation.settlingDuration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.damping = 500
        animation.mass = 0.08
        animation.initialVelocity = 100
        animation.fromValue = oldPath.cgPath
        animation.toValue = newPath.cgPath
        animation.isRemovedOnCompletion = false
        nickerLayer.add(animation, forKey: AnimationKeys.NickerChange)
        nickerLayer.path = newPath.cgPath
    }
    
    
    fileprivate func addHeadLayer() {
        headLayer.lineWidth = lineWidth
        headLayer.fillColor = layerColor.cgColor
        headLayer.strokeColor = UIColor.black.cgColor
        headLayer.path = headPath.cgPath
        headLayer.lineCap = "round"
        headLayer.lineJoin = kCALineJoinRound
        layer.addSublayer(headLayer)
        headLayer.drawShadow
    }
//    func addHeadLayer() {
//        SmileView.removeSmileFrom(self)
//        let headHeight = bounds.height/6
//        _ = SmileView.showSmile(on: self, frame: CGRect(x: (bounds.width/2) - (headHeight/2), y: 10, width: headHeight, height: headHeight))
//    }
    fileprivate func addBodyLayer() {
        self.oldBodyPath = bodyPath(type: genderType)
        bodyLayer.lineWidth = lineWidth
        bodyLayer.fillColor = layerColor.cgColor
        bodyLayer.strokeColor = UIColor.black.cgColor
        bodyLayer.path = self.oldBodyPath!.cgPath
        bodyLayer.lineCap = "round"
        bodyLayer.lineJoin = kCALineJoinRound
        layer.addSublayer(bodyLayer)
        bodyLayer.drawShadow
    }
    fileprivate func addNickerLayer() {
        self.oldNickerPath = nickerPath(genderType)
        nickerLayer.lineWidth = lineWidth
//        nickerLayer.fillColor = layerColor.cgColor
        nickerLayer.strokeColor = UIColor.black.cgColor
        nickerLayer.path = self.oldNickerPath!.cgPath
        nickerLayer.lineCap = "round"
        nickerLayer.lineJoin = kCALineJoinRound
        layer.addSublayer(nickerLayer)
        nickerLayer.drawShadow
    }
    
    fileprivate func addLegsLayer() {
        legsLayer.lineWidth = lineWidth
        legsLayer.fillColor = layerColor.cgColor
        legsLayer.strokeColor = UIColor.black.cgColor
        legsLayer.path = legsPath.cgPath
        legsLayer.lineCap = "round"
        legsLayer.lineJoin = kCALineJoinRound
        layer.addSublayer(legsLayer)
        legsLayer.drawShadow
    }
    
    fileprivate func addLineLayer() {
        lineLayer.lineWidth = lineWidth*2
        lineLayer.fillColor = layerColor.cgColor
        lineLayer.strokeColor = UIColor.black.cgColor
        lineLayer.path = bottomLinePath.cgPath
        lineLayer.lineCap = "round"
        lineLayer.lineJoin = kCALineJoinRound
        layer.addSublayer(lineLayer)
        lineLayer.drawShadow
    }
    
    fileprivate func addBellyHoleLayer() {
        bellyHoleLayer.lineWidth = lineWidth/1.5
        bellyHoleLayer.fillColor = UIColor.black.withAlphaComponent(0.06).cgColor
        bellyHoleLayer.strokeColor = UIColor.clear.cgColor
        bellyHoleLayer.path = bellyHolePath.cgPath
        bellyHoleLayer.lineCap = "round"
        bellyHoleLayer.lineJoin = kCALineJoinRound
        layer.addSublayer(bellyHoleLayer)
        bellyHoleLayer.drawShadow
    }
    
    
    fileprivate func addUnderGarmentsLayer() {
        underGarmentsLayer.lineWidth = lineWidth
//        underGarmentsLayer.fillColor = layerColor.cgColor
        underGarmentsLayer.strokeColor = UIColor.black.cgColor
        underGarmentsLayer.path = underGarmentsPath.cgPath
        underGarmentsLayer.lineCap = "round"
        underGarmentsLayer.lineJoin = kCALineJoinRound
        layer.addSublayer(underGarmentsLayer)
        underGarmentsLayer.drawShadow
    }
    
    func setColtheColor(color: UIColor) {
        underGarmentsLayer.fillColor = color.cgColor
        nickerLayer.fillColor = color.cgColor
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func draw(_ rect: CGRect) {
        // Drawing code
        addHeadLayer()
        addBodyLayer()
        addUnderGarmentsLayer()
        addNickerLayer()
        addLegsLayer()
        addLineLayer()
        addBellyHoleLayer()
    }
}

extension CALayer {
    var drawShadow: Void {
        self.masksToBounds = false
        self.shadowColor = UIColor.black.cgColor
        self.shadowOffset = CGSize(width: 0, height: 2)
        self.shadowRadius = 3
        self.shadowOpacity = 0.8
    }
    var drawInsideShadow: Void {
        let newLayer = CAShapeLayer()
        let frameO = CGRect(x: 0, y: 0, width: 4, height: 4)
        newLayer.bounds = frameO
        newLayer.path = UIBezierPath(ovalIn: frameO).cgPath
//        newLayer.position = CGPoint(x: 3, y: 3)
        newLayer.fillColor = UIColor.black.withAlphaComponent(0.3).cgColor
        newLayer.masksToBounds = false
        newLayer.shadowColor = UIColor.black.cgColor
        newLayer.shadowOffset = CGSize(width: 0, height: 2)
        newLayer.shadowRadius = 3
        newLayer.shadowOpacity = 0.8
//        newLayer.fillRule = kCAFillRuleEvenOdd
        self.addSublayer(newLayer)
    }
}
