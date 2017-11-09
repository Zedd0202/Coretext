//
//  ViewController.swift
//  Coretext
//
//  Created by Zedd on 2017. 11. 8..
//  Copyright © 2017년 Zedd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textDrawingView: textDrawingView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textDrawingView.text = "Zedd!"
        textDrawingView.lineWidth = 2
        textDrawingView.startColor = UIColor.red
        textDrawingView.endColor = UIColor.blue
    }
    @IBAction func animatedButtonClicked(_ sender: Any) {
        textDrawingView.startAnimation()
    }
    
    
}
class textDrawingView : UIView{
    public var text :String = ""{
        didSet{createLayers(from: text) }
    }

    public var startColor  :UIColor = .black{
        didSet{applyColor(first: startColor, second: endColor)}
    }
    public var endColor  :UIColor = .black{
        didSet{applyColor(first: startColor, second: endColor)}
    }
    public var lineWidth :CGFloat = 1{
        didSet{shapeLayer.forEach{$0.lineWidth = lineWidth } }
    }
    private var shapeLayer = [CAShapeLayer]()
    
    public func startAnimation(){
        
        animateLayers()
    }
    
    private func createLayers(from text: String){
      
        
        let spacing : CGFloat = 10
        let measurmentPath = UIBezierPath()
        for (index,character) in text.characters.enumerated(){
            let path  = bezierPath(from: character)
            let translation = measurmentPath.cgPath.boundingBox.width + spacing*min(CGFloat(index),1)
            let transform = CGAffineTransform(translationX: translation, y: 0)
            path.apply(transform)
            measurmentPath.append(path)
            
            
            
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.lineWidth = 1
            layer.strokeEnd = 0
            layer.strokeColor = self.startColor.cgColor
            layer.fillColor = UIColor.clear.cgColor
            layer.frame = bounds
            layer.isGeometryFlipped = true
            self.layer.addSublayer(layer)
            shapeLayer.append(layer)
        }
        
        
        
    }
    private func bezierPath(from character:Character)->UIBezierPath{
        let font = UIFont(name: "Pacifico", size: 50)!
        var unichars = [UniChar]("\(character)".utf16)
        var glyphs = [CGGlyph](repeating:0, count : unichars.count)
        let gotGlyphs = CTFontGetGlyphsForCharacters(font, &unichars, &glyphs, unichars.count)//t or f
        if gotGlyphs, let path = CTFontCreatePathForGlyph(font, glyphs[0], nil)//cgpath
        {
            
            return UIBezierPath(cgPath: path)
        
    }
        else{
            return UIBezierPath()
        }
    
}
    private func applyColor (first :UIColor,second : UIColor){
        var firstRed :CGFloat = 0
        var secondRed : CGFloat = 0
        
        var firstGreen : CGFloat = 0
        var secondGreen : CGFloat = 0
        
        var firstBlue : CGFloat = 0
        var secondBlue : CGFloat = 0
        
        var firstAlpha : CGFloat = 0
        var secondAlpha : CGFloat = 0
        first.getRed(&firstRed, green: &firstGreen, blue: &firstBlue, alpha: &firstAlpha)
        second.getRed(&secondRed, green: &secondGreen, blue: &secondBlue, alpha: &secondAlpha)
        for (index,layer) in shapeLayer.enumerated(){
            //layer.strokeColor =
            let ratio = CGFloat(index)/CGFloat(shapeLayer.count)
            let newRed = secondRed * ratio + firstRed * (1-ratio)
             let newGreen = secondGreen * ratio + firstGreen * (1-ratio)
             let newBlue = secondBlue * ratio + firstBlue * (1-ratio)
             let newAlpha = secondAlpha * ratio + firstAlpha * (1-ratio)
            let color = UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: newAlpha)
            
            layer.strokeColor = color.cgColor
            
        }
    }
private func animateLayers(){
    
    
    for (index,layer) in shapeLayer.enumerated(){
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.beginTime = CACurrentMediaTime() + CFTimeInterval(index) * 0.5
        animation.toValue = 1
        animation.duration = 1
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        layer.add(animation, forKey: "animation")
    }
    
}
}
