//
//  xyLiveViewController.swift
//  xyTV
//
//  Created by 强风吹拂 on 2021/12/20.
//

import UIKit

class xyLiveViewController: UIViewController, LFLiveSessionDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    var liveButton : UIButton!
    var toolbarCollection : UICollectionView!
    let cellID = "CELLID"
//    var cameraButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        session.delegate = self
        session.preView = self.view
        
        self.requestAccessForVideo()
        self.requestAccessForAudio()
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(containerView)
        containerView.addSubview(stateLabel)
        containerView.addSubview(closeButton)
        containerView.addSubview(beautyButton)
//        containerView.addSubview(cameraButton)
//        containerView.addSubview(startLiveButton)
        
       
       
       
        
        
        self.setUI()
        
    }
    
    func setUI(){
        // 开始直播
        liveButton = UIButton()
        containerView.addSubview(liveButton)
        self.liveButton.snp.makeConstraints { make in
            make.bottom.equalTo(containerView).offset(-30)
            make.centerX.equalTo(containerView)
            make.height.equalTo(40);
            make.width.equalTo(xyWidth/2)
            
        }
        liveButton.layer.cornerRadius = 20
        liveButton.layer.masksToBounds = true
        liveButton.backgroundColor = .red
        liveButton.setTitle("开始视频直播", for: .normal)
        liveButton.setTitleColor(UIColor.white, for: .normal)
        liveButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        liveButton.addTarget(self, action: #selector(didTappedStartLiveButton(_:)), for: .touchUpInside)
        
        //自定义item的FlowLayout

         let flowLayout = UICollectionViewFlowLayout()

         //设置item的size

         flowLayout.itemSize = CGSize.init(width:xyWidth/2,height:38)

         //设置item的排列方式

        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical

         //设置item的四边边距

        flowLayout.sectionInset = UIEdgeInsets(top: 0,left: 0, bottom: 0, right: 0)

         //列间距

         flowLayout.minimumLineSpacing = 0

         //行间距

         flowLayout.minimumInteritemSpacing = 0
        
         
        toolbarCollection = UICollectionView(frame: CGRect.init(x:0, y:0, width: 0, height: 0),collectionViewLayout:flowLayout)

        containerView.addSubview(toolbarCollection)
        toolbarCollection.snp.makeConstraints { make in
            make.left.right.equalTo(containerView)
            make.height.equalTo(38)
            make.bottom.equalTo(liveButton.snp.top).offset(-10)

        }
        toolbarCollection.backgroundColor = UIColor.clear
        //设置数据源对象

        toolbarCollection.dataSource = self

              //设置代理对象

        toolbarCollection.delegate = self

              //设置uicollectionView的单元格点击

//        toolbarCollection.allowsSelection = true
        toolbarCollection.register(UINib(nibName: "xyToolbarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:cellID)
     

      
    }
    
    func numberOfSections(in collectionView:UICollectionView) ->Int {
           return 1

       }

       

       func collectionView(_ collectionView:UICollectionView, numberOfItemsInSection section:Int) -> Int {
           return 2

       }

       

       func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath:IndexPath) -> UICollectionViewCell {
           var cell = xyToolbarCollectionViewCell()
           cell = collectionView.dequeueReusableCell(withReuseIdentifier:cellID, for: indexPath) as! xyToolbarCollectionViewCell
           cell.toolbarLabel.text = "你好"
           
           if indexPath.row == 0 {
               cell.toolbarLabel.text = "翻转"
               cell.toolbarImageView.image = UIImage.init(named: "camra_preview")
           }else if indexPath.row == 1{
               cell.toolbarLabel.text = "美颜"
               cell.toolbarImageView.image = UIImage.init(named: "camra_beauty")
           }

           cell.backgroundColor = UIColor.clear
           
           cell.sender.tag =  indexPath.row + 100
           
           
           cell.sender.addTarget(self, action: #selector(toolbarAdd(_:)), for: .touchUpInside)
           return cell

           

       }
    
    
    @objc func toolbarAdd(_ button: UIButton) -> Void{
        if button.tag == 100{ // 摄像头翻转
            let devicePositon = session.captureDevicePosition;
            session.captureDevicePosition = (devicePositon == AVCaptureDevice.Position.back) ? AVCaptureDevice.Position.front : AVCaptureDevice.Position.back
            
        }else if button.tag == 101{ // 美颜
            
        }
    }
    
   
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: AccessAuth
    
    func requestAccessForVideo() -> Void {
//        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch status  {
        // 许可对话没有出现，发起授权许可
        case AVAuthorizationStatus.notDetermined:
            
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                if(granted){
                    DispatchQueue.main.async {
                        self.session.running = true
                    }
                }
            }
            break;
        // 已经开启授权，可继续
        case AVAuthorizationStatus.authorized:
            session.running = true;
            break;
        // 用户明确地拒绝授权，或者相机设备无法访问
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    
    func requestAccessForAudio() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status  {
        // 许可对话没有出现，发起授权许可
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                
            }
            break;
        // 已经开启授权，可继续
        case AVAuthorizationStatus.authorized:
            break;
        // 用户明确地拒绝授权，或者相机设备无法访问
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    
    //MARK: - Callbacks
    
    // 回调
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print("debugInfo: \(debugInfo?.currentBandwidth)")
    }
    
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print("errorCode: \(errorCode.rawValue)")
    }
    
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        print("liveStateDidChange: \(state.rawValue)")
        switch state {
        case LFLiveState.ready:
            stateLabel.text = "未连接"
            break;
        case LFLiveState.pending:
            stateLabel.text = "连接中"
            break;
        case LFLiveState.start:
            stateLabel.text = "已连接"
            break;
        case LFLiveState.error:
            stateLabel.text = "连接错误"
            break;
        case LFLiveState.stop:
            stateLabel.text = "未连接"
            break;
        default:
                break;
        }
    }
    
    //MARK: - Events
    
    // 开始直播
    @objc func didTappedStartLiveButton(_ button: UIButton) -> Void {
        liveButton.setTitle("结束视频直播", for: UIControl.State())
        liveButton.isSelected = !liveButton.isSelected;
        if (liveButton.isSelected) {
            liveButton.setTitle("结束视频直播", for: UIControl.State())
            let stream = LFLiveStreamInfo()
            stream.url = "rtmp://192.168.1.102:1950/ppx/room"
            session.startLive(stream)
        } else {
            liveButton.setTitle("开始视频直播", for: UIControl.State())
            session.stopLive()
        }
    }
    
    // 美颜
    @objc func didTappedBeautyButton(_ button: UIButton) -> Void {
        session.beautyFace = !session.beautyFace;
        beautyButton.isSelected = !session.beautyFace
    }
    
    // 摄像头
    @objc func didTappedCameraButton(_ button: UIButton) -> Void {
        
    }
    
    // 关闭
    @objc func didTappedCloseButton(_ button: UIButton) -> Void  {
        
    }
    
    //MARK: - Getters and Setters
    
    //  默认分辨率368 ＊ 640  音频：44.1 iphone6以上48  双声道  方向竖屏
    var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.defaultConfiguration(for: LFLiveAudioQuality.high)
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.low3)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        return session!
    }()
    
    // 视图
    var containerView: UIView = {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        containerView.backgroundColor = UIColor.clear
//        containerView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleHeight]
        containerView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight,UIView.AutoresizingMask.flexibleHeight]
        return containerView
    }()
    
    // 状态Label
    var stateLabel: UILabel = {
        let stateLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 80, height: 40))
        stateLabel.text = "未连接"
        stateLabel.textColor = UIColor.white
        stateLabel.font = UIFont.systemFont(ofSize: 14)
        return stateLabel
    }()
    
    // 关闭按钮
    var closeButton: UIButton = {
        let closeButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 10 - 44, y: 20, width: 44, height: 44))
        closeButton.setImage(UIImage(named: "close_preview"), for: UIControl.State())
        return closeButton
    }()
    
    // 摄像头
    var cameraButton: UIButton = {
        let cameraButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 54 * 2, y: 20, width: 44, height: 44))
        cameraButton.setImage(UIImage(named: "camra_preview"), for: UIControl.State())
        return cameraButton
    }()
    
    // 摄像头
    var beautyButton: UIButton = {
        let beautyButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 54 * 3, y: 20, width: 44, height: 44))
        beautyButton.setImage(UIImage(named: ""), for: .selected)
        beautyButton.setImage(UIImage(named: ""), for: .normal)
        return beautyButton
    }()
    
}
