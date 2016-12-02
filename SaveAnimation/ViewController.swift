//
//  ViewController.swift
//  AnimationGIF
//
//  Created by Hideko Ogawa on 12/1/16.
//  Copyright © 2016 SoraUsagi Apps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var viewSegment: UISegmentedControl!
    @IBOutlet weak var lineCapSegment: UISegmentedControl!
    @IBOutlet weak var lineJoinSegment: UISegmentedControl!

    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!

    private let animationLayer: CALayer = CALayer()
    private let circleLayer = CAShapeLayer()
    private let checkLayer = CAShapeLayer()

    private let duration:TimeInterval = 1.0
    private var images:[UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.layer.addSublayer(animationLayer)
        DispatchQueue.main.async {
            self.layoutBase()
        }
    }

    private func layoutBase() {
        animationLayer.frame = CGRect(origin: .zero, size: contentView.frame.size)
        let height: CGFloat = animationLayer.frame.size.height
        let width: CGFloat = animationLayer.frame.size.width
        let lineWidth: CGFloat = 6
        let ovalRect = CGRect(x: lineWidth / 2, y: lineWidth / 2, width: width - lineWidth, height: height - lineWidth)
        let ovalPath = UIBezierPath(ovalIn: ovalRect)

        circleLayer.frame = animationLayer.frame
        circleLayer.lineWidth = lineWidth
        circleLayer.path = ovalPath.cgPath
        animationLayer.addSublayer(circleLayer)

        let checkLineWidth = width / 8
        checkLayer.lineWidth = checkLineWidth
        checkLayer.fillColor = UIColor.clear.cgColor
        checkLayer.lineCap = kCALineCapSquare
        updateCheckLayerPosition()
        animationLayer.addSublayer(checkLayer)
        changeView()
    }

    private func updateCheckLayerPosition() {
        checkLayer.transform = CATransform3DIdentity

        let width: CGFloat = animationLayer.frame.size.width
        let checkWidth:CGFloat = (width / 3)
        let checkHeight:CGFloat = checkWidth * 1.8
        let lineWidth = checkLayer.lineWidth

        var x:CGFloat = lineWidth / 2
        if checkLayer.lineCap != kCALineCapButt {
            x = lineWidth / 2
        }

        let checkPath = UIBezierPath()
        checkPath.move(to: CGPoint(x: x, y: checkHeight))
        checkPath.addLine(to: CGPoint(x: checkWidth, y: checkHeight))
        checkPath.addLine(to: CGPoint(x: checkWidth, y: x))
        checkLayer.path = checkPath.cgPath

        checkLayer.frame.size.width = checkWidth + (lineWidth / 2)
        checkLayer.frame.size.height = checkHeight + (lineWidth / 2)

        checkLayer.frame.origin.x = circleLayer.frame.midX - checkLayer.frame.size.width / 2
        checkLayer.frame.origin.y = circleLayer.frame.midY - checkLayer.frame.size.height / 2 - checkLayer.lineWidth / 2
        if viewSegment.selectedSegmentIndex == 3 {
            checkLayer.frame.origin.y -= 8
        }
        //checkLayer.backgroundColor = UIColor.orange.cgColor
        checkLayer.transform = CATransform3DRotate(CATransform3DIdentity, CGFloat(M_PI_4), 0, 0, 1)
        if viewSegment.selectedSegmentIndex == 1 || viewSegment.selectedSegmentIndex == 3 {
            checkLayer.transform = CATransform3DScale(checkLayer.transform, 0.9, 0.9, 0.9)
        }
    }

    //MARK: Actions

    @IBAction func changeView() {
        let color = self.view.tintColor
        let checkTransform = CATransform3DRotate(CATransform3DIdentity, CGFloat(M_PI_4), 0, 0, 1)
        var checkLineWidth = animationLayer.frame.size.width / 8

        switch viewSegment.selectedSegmentIndex {
        case 0:
            circleLayer.opacity = 1
            circleLayer.strokeColor = color?.cgColor
            circleLayer.fillColor = color?.cgColor
            checkLayer.strokeColor = UIColor.white.cgColor
            checkLayer.transform = checkTransform

        case 1:
            circleLayer.opacity = 1
            circleLayer.strokeColor = color?.cgColor
            circleLayer.fillColor = UIColor.clear.cgColor
            checkLayer.strokeColor = color?.cgColor

        case 2:
            circleLayer.opacity = 0
            checkLayer.strokeColor = color?.cgColor
            checkLayer.transform = checkTransform

        case 3:
            circleLayer.opacity = 1
            circleLayer.strokeColor = color?.cgColor
            circleLayer.fillColor = UIColor.clear.cgColor
            checkLayer.strokeColor = color?.cgColor
            checkLineWidth = circleLayer.lineWidth

        case 4:
            circleLayer.opacity = 1
            circleLayer.strokeColor = UIColor(white: 0.3, alpha: 1).cgColor
            circleLayer.fillColor = circleLayer.strokeColor
            checkLayer.strokeColor = UIColor(white: 1.0, alpha: 1).cgColor
            checkLayer.transform = checkTransform

        default:
            break
        }
        checkLayer.lineWidth = checkLineWidth
        updateCheckLayerPosition()
    }

    @IBAction func changedType() {
        switch (segment.selectedSegmentIndex) {
        case 0:
            createType1()
        case 1:
            createType2()
        case 2:
            createType3()
        case 3:
            createType4()
        case 4:
            createType5()
        default:
            break
        }
    }

    @IBAction func changedLineCap() {
        switch lineCapSegment.selectedSegmentIndex {
        case 0:
            checkLayer.lineCap = kCALineCapButt
        case 1:
            checkLayer.lineCap = kCALineCapRound
        case 2:
            checkLayer.lineCap = kCALineCapSquare
        default:
            break
        }
        changeView()
    }

    @IBAction func changedLineJoin() {
        switch lineJoinSegment.selectedSegmentIndex {
        case 0:
            checkLayer.lineJoin = kCALineJoinMiter
        case 1:
            checkLayer.lineJoin = kCALineJoinRound
        case 2:
            checkLayer.lineJoin = kCALineJoinBevel
        default:
            break
        }
    }

    private func createType1() {
        let height: CGFloat = animationLayer.frame.size.height
        let width: CGFloat = animationLayer.frame.size.width
        let ovalRect = CGRect(x: 0, y: 0, width: width, height: height)
        let ovalPath = UIBezierPath(ovalIn: ovalRect)

        let filledLayer = CAShapeLayer()
        filledLayer.frame = animationLayer.frame
        filledLayer.lineWidth = width
        filledLayer.path = ovalPath.cgPath
        filledLayer.strokeColor = UIColor.white.cgColor
        filledLayer.fillColor = UIColor.clear.cgColor
        filledLayer.transform = CATransform3DRotate(filledLayer.transform, CGFloat(-M_PI_2), 0, 0, 1)
        filledLayer.strokeEnd = 0
        animationLayer.mask = filledLayer

        let animation:CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        filledLayer.add(animation, forKey: "type1")
    }

    private func createType2() {
        let layer = self.animationLayer
        let spring = CASpringAnimation(keyPath: "transform")
        spring.damping = 7
        spring.fromValue = CATransform3DScale(CATransform3DIdentity, 0.1, 0.1, 1.0)
        spring.toValue = CATransform3DScale(CATransform3DIdentity, 0.75, 0.75, 1.0)
        spring.duration = spring.settlingDuration
        //spring.isRemovedOnCompletion = false
        //spring.fillMode = kCAFillModeForwards
        layer.add(spring, forKey: "type2")
    }

    private func createType3() {
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = CATransform3DScale(CATransform3DIdentity, 0.1, 0.1, 1.0)
        animation.toValue = CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 1.0)
        animation.duration = duration
        circleLayer.add(animation, forKey: "type3-1")

        let layer = self.checkLayer
        let spring = CASpringAnimation(keyPath: "transform")
        spring.damping = 7
        spring.fromValue = CATransform3DScale(layer.transform, 0.1, 0.1, 1.0)
        spring.toValue = CATransform3DScale(layer.transform, 1, 1, 1.0)
        spring.duration = spring.settlingDuration
        print(spring.settlingDuration)
        layer.add(spring, forKey: "type3-2")
    }

    private func createType4() {
        let layer = animationLayer
        let animation = CABasicAnimation(keyPath: "transform")
        var transform1 = CATransform3DRotate(CATransform3DIdentity, CGFloat(-1 * M_PI), 1, 1, 1)
        transform1 = CATransform3DScale(transform1, 0.1, 0.1, 1.0)
        animation.fromValue = transform1

        var transform2 = CATransform3DRotate(CATransform3DIdentity, CGFloat(2 * M_PI), 1, 1, 1)
        transform2 = CATransform3DScale(transform2, 1.0, 1.0, 1.0)
        animation.toValue = transform2

        let animation2 = CABasicAnimation(keyPath: "transform.scale")
        animation2.fromValue = CATransform3DScale(layer.transform, 0.1, 0.1, 1.0)
        animation2.toValue = CATransform3DScale(layer.transform, 1.0, 1.0, 1.0)

        let group = CAAnimationGroup()
        group.animations = [animation]
        group.duration = 0.6
        animationLayer.add(group, forKey: "type4 animation")
    }

    private func createType5() {
        if circleLayer.opacity > 0 {
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = 0
            animation.toValue = 1.0
            animation.duration = 0.5
            animationLayer.add(animation, forKey: "type5-1")
        }

        let animation2 = CABasicAnimation(keyPath: "strokeEnd")
        animation2.fromValue = 0.0
        animation2.toValue = 1.0
        animation2.duration = 0.8
        animation2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        checkLayer.add(animation2, forKey: "type5-2")
    }

    //MARK: Export

    @IBAction func create() {
        createButton.isEnabled = false
        let layer = animationLayer
        let start = CACurrentMediaTime()

        changedType()
        layer.timeOffset = start
        layer.speed = 0

        var results:[UIImage] = []
        let fps:Int = 10

        DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {
            for i in 0...20 {
                DispatchQueue.main.async {
                    let offset = start + TimeInterval(i) * (1 / Double(fps))
                    layer.timeOffset = offset
                    layer.speed = 0.0
                    layer.timeOffset = offset
                }
                Thread.sleep(forTimeInterval: 0.3)
                let semaphore = DispatchSemaphore(value: 0)
                DispatchQueue.main.async {
                    let image = self.captureView2()
                    //print(i, image.size)
                    results.append(image)
                    semaphore.signal()
                    //self.resumeLayer(layer: layer)
                }
                semaphore.wait()
            }
            self.images = results
            DispatchQueue.main.async {
                layer.speed = 1
                self.preview()
                self.exportImages()
                self.createButton.isEnabled = true
            }
        }
    }

    private func pauseLayer(layer: CALayer) {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }

    private func resumeLayer(layer: CALayer) {
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }

    @IBAction func preview() {
        previewImage.animationImages = images
        previewImage.animationDuration = 2
        previewImage.animationRepeatCount = 0
        previewImage.startAnimating()
    }

    private func captureView() -> UIImage {
        let rect = contentView.frame
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        contentView.layer.presentation()!.render(in: context)
        //contentView.drawHierarchy(in: CGRect(origin:.zero, size:rect.size), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    private func captureView2() -> UIImage {
        let rect = contentView.frame
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 1.0)
        contentView.drawHierarchy(in: CGRect(origin:.zero, size:rect.size), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    private func exportImages() {
        let dir = outputDir()
        print("output dir=\(dir)")
        outputLabel.text = dir
        let fm = FileManager.default
        for item in images.enumerated() {
            let prefix = "w_saved_\(item.offset)"
            let folder = dir + "/" + prefix + ".imageset"
            try! fm.createDirectory(atPath: folder, withIntermediateDirectories: true, attributes: nil)

            let data = UIImagePNGRepresentation(item.element)
            let fileName = "\(prefix)@2x.png"
            try! data?.write(to: URL(fileURLWithPath: folder + "/" + fileName))

            let json: String =
            "{\n"
            + "  \"images\" : [\n"
            + "    {\n"
            + "      \"idiom\" : \"watch\",\n"
            + "      \"filename\" : \"\(fileName)\",\n"
            + "      \"scale\" : \"2x\"\n"
            + "    }\n"
            + "  ],\n"
            + "  \"info\" : {\n"
            + "    \"version\" : 1,\n"
            + "    \"author\" : \"xcode\"\n"
            + "  }\n"
            + "}"
            try! json.write(toFile: folder + "/Contents.json", atomically: true, encoding: .utf8)
        }
        print("exported.")
    }

    private func outputDir() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let path = paths.first!
        let outputDir = path  + "/export"
        let fm = FileManager.default
        if fm.fileExists(atPath: outputDir) {
            try! fm.removeItem(atPath: outputDir)
        }
        try! fm.createDirectory(atPath: outputDir, withIntermediateDirectories: true, attributes: nil)
        return outputDir
    }
}

