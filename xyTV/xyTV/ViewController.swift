//
//  ViewController.swift
//  xyTV
//
//  Created by 强风吹拂 on 2021/12/18.
//

import UIKit
import SnapKit
import Alamofire
class ViewController: UIViewController {
    
    
    var liveButton :UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = .white
        liveButton = UIButton()
        self.view.addSubview(liveButton)
        liveButton.setTitle("直播按钮", for: .normal)
        liveButton.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self.view)
            make.height.equalTo(50)
            make.width.equalTo(200)
            
            
        }
        liveButton.setTitleColor(.black, for: .normal)
        liveButton.backgroundColor = .green
        
        self.liveButton.addTarget(self, action: #selector(add), for: .touchUpInside)

        
    }
    @objc func add(){
        let xyLiveC = xyLiveViewController()
        // 显示全屏
        xyLiveC.modalPresentationStyle = .fullScreen
        self.present(xyLiveC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: AccessAuth
    
    
}

