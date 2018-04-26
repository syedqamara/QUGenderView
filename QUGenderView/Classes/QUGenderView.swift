//
//  QUGenderView..swift
//  GenderSelection
//
//  Created by Syed Qamar Abbas on 4/25/18.
//  Copyright © 2018 Syed Qamar Abbas. All rights reserved.
//

import UIKit
public enum GenderType: String {
    case male = "male"
    case female = "female"
}
public typealias GenderSelectionCompletion = ((GenderType)->())
public class QUGenderView: UIView {
    fileprivate var genderSelectionCompletion: GenderSelectionCompletion?
    public var topLabel: UILabel?
    public var maleButton: UIButton?
    public var femaleButton: UIButton?
    public var genderSketchView: QUGenderSketchView?
    private var selectedGender = GenderType.male {
        didSet{
            self.changeTopLabelName
        }
    }
    var changeTopLabelName: Void {
        self.topLabel?.text = "I'm a \(selectedGender.rawValue)"
        self.topLabel?.sizeToFit()
    }
    
    private var genderButtonContainerView: UIView?
    
    public var genderButtonColor: UIColor = .black {
        willSet(newValue) {
            setButtonColors(newValue, selectedButtonColor)
        }
    }
    public var selectedButtonColor: UIColor = .black {
        willSet(newValue) {
            setButtonColors(genderButtonColor, newValue)
        }
    }
    
    fileprivate var defaultFont: UIFont {
        return UIFont.boldSystemFont(ofSize: 20)
    }
    public func genderIsSelected(completion: @escaping GenderSelectionCompletion) {
        self.genderSelectionCompletion = completion
    }
    public var clotheColor: UIColor = .darkGray {
        willSet(newColor) {
            self.genderSketchView?.setColtheColor(color: newColor)
        }
    }
    
    @objc fileprivate func genderIsSelected(sender: UIButton) {
        if let completion = genderSelectionCompletion{
            
            if sender == self.maleButton && self.selectedGender != .male {
                selectedGender = .male
                self.genderSketchView?.genderType = selectedGender
            }else if sender == self.femaleButton && self.selectedGender != .female {
                selectedGender = .female
                self.genderSketchView?.genderType = selectedGender
            }
            self.changeSelectionColor
            completion(selectedGender)
        }
    }
    public init(frame: CGRect, andColor: UIColor) {
        super.init(frame: frame)
        initializeSubViews(frame, color: andColor)
        
    }
    private override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubViews(frame)
        
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.clear
        self.layer.backgroundColor = UIColor.clear.cgColor
    }
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setButtonColors(_ color: UIColor, _ selectedColor: UIColor) {
        if selectedGender == .male {
            maleButton?.setTitleColor(selectedColor, for: .normal)
            femaleButton?.setTitleColor(color, for: .normal)
        }else {
            maleButton?.setTitleColor(color, for: .normal)
            femaleButton?.setTitleColor(selectedColor, for: .normal)
        }
        
    }
    var changeSelectionColor: Void {
        setButtonColors(genderButtonColor, selectedButtonColor)
    }
    func initializeSubViews(_ rect: CGRect, color: UIColor = UIColor.lightGray) {
        if topLabel == nil {
            topLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
            topLabel?.center = CGPoint(x: rect.width/2, y: 40)
            topLabel?.font = defaultFont
            topLabel?.text = "I'm a"
            topLabel?.textAlignment = .center
            addSubview(topLabel!)
        }
        if genderSketchView == nil {
            let frame = CGRect(x: 20, y: 80, width: rect.width - 40, height: rect.height - 200)
            genderSketchView = QUGenderSketchView(with: frame, andDefaultGenderType: selectedGender, color: color)
            genderSketchView?.backgroundColor = UIColor.clear
            addSubview(genderSketchView!)
        }
        if genderButtonContainerView == nil {
            genderButtonContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
            genderButtonContainerView?.center = CGPoint(x: rect.width/2, y: rect.height - 80)
            genderButtonContainerView?.backgroundColor = UIColor.darkGray
            addSubview(genderButtonContainerView!)
            
            //initializing male button
            maleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 75, height: 50))
            maleButton?.titleLabel?.font = defaultFont
            maleButton?.setTitle("Boy", for: .normal)
            genderButtonContainerView?.addSubview(maleButton!)
            
            //initializing female button
            femaleButton = UIButton(frame: CGRect(x: 75, y: 0, width: 75, height: 50))
            femaleButton?.titleLabel?.font = defaultFont
            femaleButton?.setTitle("Girl", for: .normal)
            genderButtonContainerView?.addSubview(femaleButton!)
            
            changeSelectionColor
            maleButton?.addTarget(self, action: #selector(genderIsSelected(sender:)), for: .touchUpInside)
            femaleButton?.addTarget(self, action: #selector(genderIsSelected(sender:)), for: .touchUpInside)
        }
        self.changeTopLabelName
    }
    

}
