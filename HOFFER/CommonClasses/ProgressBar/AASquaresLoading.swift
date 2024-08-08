//
//  AASquaresLoading.swift
//  Etix Mobile
//
//  Created by Anas Ait Ali on 18/02/15.
//  Copyright (c) 2015 Etix. All rights reserved.
//

import UIKit

//MARK: AASquareLoadingInterface
/**
 Interface for the AASquareLoading class
 */
public protocol AASquareLoadingInterface: AnyObject {
    var color : UIColor { get set }
    var backgroundColor : UIColor? { get set }
    
    func start(delay : TimeInterval)
    func stop(delay : TimeInterval)
    func setSquareSize(size: Float)
}

private var AASLAssociationKey: UInt8 = 0

//MARK: UIView extension
public extension UIView {
    
    /**
     Variable to allow access to the class AASquareLoading
     */
    var squareLoading: AASquareLoadingInterface {
        get {
            if let value = objc_getAssociatedObject(self, &AASLAssociationKey) as? AASquareLoadingInterface {
                return value
            } else {
                let squareLoading = AASquaresLoading(target: self)
                
                objc_setAssociatedObject(self, &AASLAssociationKey, squareLoading,
                                         objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
                
                return squareLoading
            }
        }
        
        set {
            objc_setAssociatedObject(self, &AASLAssociationKey, newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

//MARK: AASquareLoading class

/**
 Main class AASquareLoading
 */
public class AASquaresLoading : UIView, AASquareLoadingInterface, CAAnimationDelegate  {
    public var view : UIView = UIView()
    private(set) public var size : Float = 0
    public var color : UIColor = UIColor(red: 32.0/255.0, green: 62.0/255.0, blue: 132.0/255.0, alpha: 1) {
        didSet { //
            for layer in squares {
                layer.backgroundColor = color.cgColor
            }
        }
    }
    public var parentView : UIView?
    
    private var squareSize: Float?
    private var gapSize: Float?
    private var moveTime: Float?
    private var squareStartX: Float?
    private var squareStartY: Float?
    private var squareStartOpacity: Float?
    private var squareEndX: Float?
    private var squareEndY: Float?
    private var squareEndOpacity: Float?
    private var squareOffsetX: [Float] = [Float](repeating: 0, count: 9)
    private var squareOffsetY: [Float] = [Float](repeating: 0, count: 9)
    private var squareOpacity: [Float] = [Float](repeating: 0, count: 9)
    private var squares : [CALayer] = [CALayer]()
    
    public init(target: UIView) {
        super.init(frame: target.frame)
        
        parentView = target
        setup(size: self.size)
    }
    
    public init(target: UIView, size: Float) {
        super.init(frame: target.frame)
        
        parentView = target
        setup(size: size)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup(size: 0)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup(size: 0)
    }
    
    public override func layoutSubviews() {
        updateFrame()
        super.layoutSubviews()
    }
    
    private func setup(size: Float) {
        self.size = size
        updateFrame()
        self.initialize()
    }
    
    private func updateFrame() {
        if parentView != nil {
            self.frame = CGRect(x:0, y:0, width:parentView!.frame.width, height:parentView!.frame.height)
        }
        size = 80 //
        if size == 0 {
            let width = frame.size.width
            let height = frame.size.height
            size = width > height ? Float(height/8) : Float(width/8)
        }
        self.view.frame = CGRect(x:frame.width / 2 - CGFloat(size) / 2,
                                 y:frame.height / 2 - CGFloat(size) / 2, width:CGFloat(size), height:CGFloat(size))
    }
    
    /**
     Function to start the loading animation
     
     - Parameter delay : The delay before the loading start
     */
    public func start(delay : TimeInterval = 0.0) {
        if (parentView != nil) {
            self.layer.opacity = 0
            self.parentView!.addSubview(self)
			UIView.animate(withDuration: 0.6, delay: delay, options: UIView.AnimationOptions.curveEaseInOut,
                           animations: { () -> Void in
                            self.layer.opacity = 1
            }, completion: nil)
        }
    }
    
    /**
     Function to start the loading animation
     
     - Parameter delay : The delay before the loading start
     */
    public func stop(delay : TimeInterval = 0.0) {
        DispatchQueue.main.async {
          self.removeFromSuperview()
        }
        if (parentView != nil) {
            DispatchQueue.main.async {
               self.layer.opacity = 1
            }
			UIView.animate(withDuration: 0.6, delay: delay, options: UIView.AnimationOptions.curveEaseInOut,
                           animations: { () -> Void in
                            DispatchQueue.main.async {
                               self.layer.opacity = 0
                            }                            
            }, completion: { (success: Bool) -> Void in
                self.removeFromSuperview()
            })
        }
    }
    
    public func setSquareSize(size: Float) {
        self.view.layer.sublayers = nil
        setup(size: size)
    }
    
    private func initialize() {
        let gap : Float = 0.04
        gapSize = size * gap
        squareSize = size * (1.0 - 2 * gap) / 3
        moveTime = 0.15
        squares = [CALayer]()
        
        self.addSubview(view)
        if (self.backgroundColor == nil) {
            //self.backgroundColor = UIColor.white.withAlphaComponent(0.9)
            self.backgroundColor = UIColor.black.withAlphaComponent(0.2) //
        }
        for i : Int in 0 ..< 3 {
            for j : Int in 0 ..< 3 {
                var offsetX, offsetY : Float
                let idx : Int = 3 * i + j
                if i == 1 {
                    offsetX = squareSize! * (2 - Float(j)) + gapSize! * (2 - Float(j))
                    offsetY = squareSize! * Float(i) + gapSize! * Float(i)
                } else {
                    offsetX = squareSize! * Float(j) + gapSize! * Float(j)
                    offsetY = squareSize! * Float(i) + gapSize! * Float(i)
                }
                squareOffsetX[idx] = offsetX
                squareOffsetY[idx] = offsetY
                squareOpacity[idx] = 0.1 * (Float(idx) + 1)
            }
        }
        squareStartX = squareOffsetX[0]
        squareStartY = squareOffsetY[0] - 2 * squareSize! - 2 * gapSize!
        squareStartOpacity = 0.0
        squareEndX = squareOffsetX[8]
        squareEndY = squareOffsetY[8] + 2 * squareSize! + 2 * gapSize!
        squareEndOpacity = 0.0
        
        for i in -1 ..< 9 {
            self.addSquareAnimation(position: i)
        }
    }
    
    private func addSquareAnimation(position: Int) {
        let square : CALayer = CALayer()
        if position == -1 {
            square.frame = CGRect(x:CGFloat(squareStartX!), y:CGFloat(squareStartY!),
                                  width:CGFloat(squareSize!), height:CGFloat(squareSize!))
            square.opacity = squareStartOpacity!
        } else {
            square.frame = CGRect(x:CGFloat(squareOffsetX[position]),
                                  y:CGFloat(squareOffsetY[position]), width:CGFloat(squareSize!), height:CGFloat(squareSize!))
            square.opacity = squareOpacity[position]
        }
        square.backgroundColor = self.color.cgColor
        squares.append(square)
        self.view.layer.addSublayer(square)
        
        var keyTimes = [Float]()
        var alphas = [Float]()
        keyTimes.append(0.0)
        if position == -1 {
            alphas.append(0.0)
        } else {
            alphas.append(squareOpacity[position])
        }
        if position == 0 {
            square.opacity = 0.0
        }
        
        let sp : CGPoint = square.position
        let path : CGMutablePath = CGMutablePath()
        
        //    CGPathMoveToPoint(path, nil, sp.x, sp.y)
        path.move(to: CGPoint(x: sp.x, y: sp.y))
        
        var x, y, a : Float
        if position == -1 {
            x = squareOffsetX[0] - squareStartX!
            y = squareOffsetY[0] - squareStartY!
            a = squareOpacity[0]
        } else if position == 8 {
            x = squareEndX! - squareOffsetX[position]
            y = squareEndY! - squareOffsetY[position]
            a = squareEndOpacity!
        } else {
            x = squareOffsetX[position + 1] - squareOffsetX[position]
            y = squareOffsetY[position + 1] - squareOffsetY[position]
            a = squareOpacity[position + 1]
        }
        //    CGPathAddLineToPoint(path, nil, sp.x + CGFloat(x), sp.y + CGFloat(y))
        path.addLine(to: CGPoint(x: sp.x + CGFloat(x), y: sp.y + CGFloat(y)))
        keyTimes.append(1.0 / 8.0)
        alphas.append(a)
        
        //    CGPathAddLineToPoint(path, nil, sp.x + CGFloat(x), sp.y + CGFloat(y))
        path.addLine(to: CGPoint(x: sp.x + CGFloat(x), y: sp.y + CGFloat(y)))
        keyTimes.append(1.0)
        alphas.append(a)
        
        let posAnim : CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        posAnim.isRemovedOnCompletion = false
        posAnim.duration = Double(moveTime! * 8)
        posAnim.path = path
        posAnim.keyTimes = keyTimes as [NSNumber]?
        
        let alphaAnim : CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "opacity")
        alphaAnim.isRemovedOnCompletion = false
        alphaAnim.duration = Double(moveTime! * 8)
        alphaAnim.values = alphas
        alphaAnim.keyTimes = keyTimes as [NSNumber]?
        
        let blankAnim : CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "opacity")
        blankAnim.isRemovedOnCompletion = false
        blankAnim.beginTime = Double(moveTime! * 8)
        blankAnim.duration = Double(moveTime!)
        blankAnim.values = [0.0, 0.0]
        blankAnim.keyTimes = [0.0, 1.0]
        
        var beginTime : Float
        if position == -1 {
            beginTime = 0
        } else {
            beginTime = moveTime! * Float(8 - position)
        }
        let group : CAAnimationGroup = CAAnimationGroup()
        group.animations = [posAnim, alphaAnim, blankAnim]
        group.beginTime = CACurrentMediaTime() + Double(beginTime)
        group.repeatCount = HUGE
        group.isRemovedOnCompletion = false
        group.delegate = self
        group.duration = Double(9 * moveTime!)
        
        square.add(group, forKey: "square-\(position)")
    }
}
