# PasswordPanel
swift 手绘密码
> 闲来无事学习swift3.0，顺手写了个手势密码的demo来巩固一下. 代码中自定义了两个类，一个是NumberButton用来控制Button的，一个是GesturePasswordView，是用来显示密码面板的。绘图部分就是在GesturePasswordView上进行的。下面直接上代码，代码中有相关的注释，代码也比较简单。

1、NumberButton的定义
```
class NumberButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self .setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        
        self.layer.borderColor = UIColor.green.cgColor
        self.layer.borderWidth = 5
        self.layer.cornerRadius = self.width * 0.5
        self.layer.masksToBounds = true
        self.isUserInteractionEnabled = false
    }
    
}
```

2、GesturePasswordView 定义

```
class GesturePasswordView: UIView {
    //路径
    var path:UIBezierPath =  UIBezierPath()
    //父控制器
    weak var controller:UIViewController?
    //存储已经路过的点
    var pointsArr = [CGPoint]()
    
    //当前手指所在点
    var fingurePoint:CGPoint!
    //密码存储
    var passwordArr : [Int] = [Int]()
    //提供给其他类获取密码字符串
    var password:String{
        get{
            var str = ""
            for p in passwordArr{
                str.append(String(p))
            }
            return str
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self .setup()
    }
    
    convenience init(frame: CGRect, controller:UIViewController) {
        self.init(frame: frame)
        self.controller = controller
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -初始化
    func setup(){
        // TODO: 创建视图
        self.backgroundColor = .cyan
        let colNum = 3
        var col = 0,row = 0
        
        let width:CGFloat = 60.0
        let height:CGFloat = width
        
        var x:CGFloat = 0
        var y:CGFloat = 0
        
        
        /// 计算空隙
        let space = (self.width - CGFloat(colNum) * width) / 4
        
        for index in 0..<9{
            //计算当前所在行
            col = index % colNum
            row = index / colNum
            //计算坐标
            x = CGFloat(col) * width + CGFloat(col + 1) * space
            y = CGFloat(row) * width + CGFloat(row + 1) * space
            let button = NumberButton(frame: CGRect(x: x, y: y, width: width, height: height))
            
            button.tag = index
            
            self.addSubview(button)
        }
        
        //MARK: 初始化路径
        self.path.lineWidth = 10
        self.path.lineCapStyle = .round

        self.path.lineJoinStyle = .round
        UIColor.black.setStroke()
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        //每次点击移除所有存储过的点，重新统计
        self.pointsArr.removeAll()
        
        self.touchChanged(touch: touches.first!)
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.touchChanged(touch: touches.first!)
    }

    //MARK: 触摸变化时的方法
    func touchChanged(touch:UITouch){
        let point = touch.location(in: self)
        
        self.fingurePoint = point
        
        for button in self.subviews{
            
            if button.isKind(of: NumberButton.self) && !self.pointsArr.contains(button.center) && button.frame.contains(point){
                
                //记录已经走过的点
                self.passwordArr.append(button.tag)
                
                //记录密码
                self.pointsArr.append(button.center)
                //设置按钮的背景色为红色
                button.backgroundColor  =  UIColor.red
            }
            
        }
        //会调用draw 方法
        self.setNeedsDisplay()
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let alertVC = UIAlertController(title: "您的密码是:", message: "\(passwordArr)", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: {
            _ in
            //移除存储的密码
           self.passwordArr.removeAll()
            UIView.animate(withDuration: 0.25, delay: 1, options: UIViewAnimationOptions.curveEaseInOut, animations:
                {
                    //移除所有的记录
                    self.pointsArr.removeAll()
                    self.path.removeAllPoints()
                    self.setNeedsDisplay()
                    self.fingurePoint = CGPoint.zero
                    
                    //清除所有按钮的选中状态
                    for button in self.subviews{
                        
                        if button.isKind(of: NumberButton.self) {
        
                            button.backgroundColor  =  UIColor.clear

                        }
                        
                    }
            }, completion: nil)
        })
        
        //弹出提示框
        alertVC.addAction(action)
        self.controller?.present(alertVC, animated: true, completion: nil)

    }
    
    //MARK: 绘制
    override func draw(_ rect: CGRect) {
       self.path.removeAllPoints()
        for (index,point) in self.pointsArr.enumerated(){
            
            if index == 0{
                self.path.move(to: point)
            }else{
                self.path.addLine(to: point)
            }
            
        }
        //让画线跟随手指
        if self.fingurePoint != CGPoint.zero && self.pointsArr.count > 0{
            self.path.addLine(to: self.fingurePoint)
        }

        self.path.stroke()
    }
}
```

> 其中我提供了一个队UIView的frame下size，origin，x，y，width，height属性的快捷访问方法，实现如下:

3、UIView下size，origin，x，y，width，height属性的快捷访问方法

```
extension UIView{
    
    var size:CGSize {
         get{
            return self.frame.size
        }
         set{
            self.frame.size = newValue
        }
    }
    
    var origin: CGPoint {
         get{
            return self.frame.origin
        }
         set{
            self.frame.origin = newValue
        }
    }
    
    
    var width:CGFloat{
         get{
            return self.size.width
        }
        set{
            self.size.width = newValue
        }
    }
    
    var height:CGFloat{
         get{
            return self.size.height
        }
        set{
            self.size.height = newValue
        }
    }
    
    var x:CGFloat{
        get{
            return self.origin.x
        }
        set{
            self.origin.x = newValue
        }
    }
    
    var y:CGFloat{
        get{
            return self.origin.y
        }
        set{
            self.origin.y = newValue
        }
    }
}
```
