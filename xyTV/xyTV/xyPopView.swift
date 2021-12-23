//
//  xyPopView.swift
//  xyTV
//
//  Created by 强风吹拂 on 2021/12/23.
//

import UIKit

class xyPopView: UIView {

    var bottowView : UIView!
    var switchButton : UIButton!
    var mesLabel : UILabel!
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           bottowView = UIView()
           self.addSubview(bottowView)
           bottowView.snp.makeConstraints { make in
               make.left.right.bottom.equalTo(self)
               make.height.equalTo(300)
           }
           bottowView.backgroundColor = UIColor.red
           
           
        
       }
       
      

       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var point = touches.first?.location(in: self)
        point = bottowView.layer.convert(point ?? CGPoint.zero, from: layer)
        if !bottowView.layer.contains(point ?? CGPoint.zero) {
            self.isHidden = true
            
        }
    }

}
