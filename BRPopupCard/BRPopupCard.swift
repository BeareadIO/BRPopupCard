//
//  BRPopupCard.swift
//  BRPopupCard
//
//  Created by Archy on 2018/3/22.
//  Copyright © 2018年 Archy. All rights reserved.
//

import UIKit

@objc public protocol BRPopupCardDelegate {
    @objc optional func popupCard(card: BRPopupCard, willShowIn view: UIView)
    @objc optional func popupCard(card: BRPopupCard, didShowIn view: UIView)
    @objc optional func popupCard(card: BRPopupCard, willHideIn view: UIView)
    @objc optional func popupCard(card: BRPopupCard, didHideIn view: UIView)
    
    @objc optional func popupCard(didClickImage card: BRPopupCard)
    @objc optional func popupCard(didClickTitle card: BRPopupCard)
    @objc optional func popupCard(didClickContent card: BRPopupCard)
    @objc optional func popupCard(didClickArea card: BRPopupCard)
    @objc optional func popupCard(didClickCancel card: BRPopupCard)
}


public enum BRPopupCardBackground {
    case normal
    case mask
    case blur
}

public enum BRPopupCardType {
    case text
    case image
    case custom
}

public class BRPopupCard: UIView {
    
    let textInfoWidth = UIScreen.main.bounds.size.width - 40

    public weak var delegate: BRPopupCardDelegate?
    
    private(set) var parentView: UIView!
    
    public var title: String? {
        didSet {
            lblTitle.text = title
        }
    }
    
    public var content: String? {
        didSet {
            lblContent.text = content
        }
    }
    
    public var img: UIImage? {
        didSet {
            imageView.image = img
        }
    }
    
    public var imgUrl: String? {
        didSet {
            imageView.image = UIImage.init(named: imgUrl!)
        }
    }
    
    public var attributedContent: NSAttributedString? {
        didSet {
            lblContent.attributedText = attributedContent
        }
    }
    
    public var contentView: UIView? {
        didSet {
            insertSubview(contentView!, belowSubview: btnClose)
            textInfoView.removeFromSuperview()
            imageInfoView.removeFromSuperview()
            contentView?.frame = CGRect.init(x: (self.bounds.size.width - contentView!.frame.size.width) / 2.0 , y: (self.bounds.size.height - contentView!.frame.size.height) / 2.0, width: contentView!.frame.size.width, height: contentView!.frame.size.height )
        }
    }
    
    public var type: BRPopupCardType = .text {
        didSet {
            textInfoView.removeFromSuperview()
            imageInfoView.removeFromSuperview()
            if type == .text {
                addSubview(textInfoView)
                insertSubview(textInfoView, belowSubview: btnClose)
                btnClose.setImage(UIImage.init(named: "btn_cancel"), for: .normal)
            }
            else if type == .image {
                addSubview(imageInfoView)
                insertSubview(imageInfoView, belowSubview: btnClose)
                btnClose.setImage(UIImage.init(named: "btn_cancel_w"), for: .normal)
            }
            else if type == .custom {
                addSubview(imageInfoView)
                insertSubview(imageInfoView, belowSubview: btnClose)
                btnClose.setImage(UIImage.init(named: "btn_cancel"), for: .normal)
            }
            layoutIfNeeded()
            setNeedsLayout()
        }
    }
    
    public var background: BRPopupCardBackground = .blur {
        didSet {
            if let current = currentBGView {
                current.removeFromSuperview()
            }
            if background == .blur {
                blurBGView.removeFromSuperview()
                addSubview(blurBGView)
                sendSubview(toBack: blurBGView)
                currentBGView = blurBGView
            }
            else if background == .mask {
                normalBGView.removeFromSuperview()
                normalBGView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                addSubview(normalBGView)
                sendSubview(toBack: normalBGView)
                currentBGView = normalBGView
            }
            else if background == .normal {
                normalBGView.removeFromSuperview()
                normalBGView.backgroundColor = .clear
                addSubview(normalBGView)
                sendSubview(toBack: normalBGView)
                currentBGView = normalBGView
            }
        }
    }
    
    private lazy var normalBGView: UIView = {
        let view = UIView.init(frame: bounds)
        view.isUserInteractionEnabled = true
        view.alpha = 0
        return view
    }()
    
    private lazy var blurBGView: UIVisualEffectView = {
        let effect = UIBlurEffect.init(style: .extraLight)
        let view = UIVisualEffectView.init(effect: effect)
        view.frame = self.bounds
        let vibEffect = UIVibrancyEffect.init(blurEffect: effect)
        let visView = UIVisualEffectView.init(effect: vibEffect)
        visView.frame = view.bounds
        view.contentView.addSubview(visView)
        view.alpha = 0
        return view
    }()
    
    private lazy var textInfoView: UIScrollView = {
        let view = UIScrollView.init(frame: CGRect.init(x: 20, y: 104, width: textInfoWidth, height: 20))
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.init(white: 0, alpha: 0.05).cgColor
        view.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        view.layer.shadowOpacity = 0.8
        view.alpha = 0
        view.addSubview(lblTitle)
        view.addSubview(lblContent)
        return view
    }()
    
    private lazy var lblTitle: UILabel = {
       let lbl = UILabel.init(frame: CGRect.init(x: 20, y: 30, width: textInfoWidth - 40, height: 20))
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.textColor = UIColor(red: 0.2274509804, green: 0.2392156863, blue: 0.2509803922, alpha: 1.0000000000)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var lblContent: UILabel = {
        let lbl = UILabel.init(frame: CGRect.init(x: 20, y: 65, width: textInfoWidth - 40, height: 20))
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = UIColor(red: 0.4392156863, green: 0.4509803922, blue: 0.4627450980, alpha: 1.0000000000)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var imageInfoView: UIView = {
       let view = UIView.init(frame: CGRect.init(x: (self.bounds.size.width - 240)/2.0, y: (self.bounds.size.height - 360)/2.0, width: 240, height: 360))
        view.alpha = 0
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.addSubview(imageView)
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 240, height: 360))
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var btnClose: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: (self.bounds.size.width - 44)/2.0, y: self.bounds.size.height - 30 - 44, width: 44, height: 44)
        btn.setImage(UIImage.init(named: "btn_cancel"), for: .normal)
        btn.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        return btn
    }()
    
    private var currentBGView: UIView!
    
    lazy var tapArea: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(areaAction(_:)))
        return tap
    }()
    
    lazy var tapTitle: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(titleAction(_:)))
        return tap
    }()
    
    lazy var tapContent: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(contentAction(_:)))
        return tap
    }()
    
    lazy var tapImage: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(imageAction(_:)))
        return tap
    }()
    
    public init(view: UIView) {
        super.init(frame: UIScreen.main.bounds)
        self.parentView = view
        view.addSubview(self)
        defaultInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func defaultInit() {
        backgroundColor = .clear
        addSubview(btnClose)
        insertSubview(textInfoView, belowSubview: btnClose)
        sendSubview(toBack: blurBGView)
        addGestureRecognizer(tapArea)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if type == .text {
            let defaultHeight = self.bounds.size.height - 208
            let titleHeight = lblTitle.sizeThatFits(CGSize.init(width: textInfoWidth - 40, height: CGFloat(MAXFLOAT))).height
            lblTitle.frame = CGRect.init(x: 20, y: 20, width: textInfoWidth - 40, height: titleHeight)
            let contentHeight = lblContent.sizeThatFits(CGSize.init(width: textInfoWidth - 40, height: CGFloat(MAXFLOAT))).height
            lblContent.frame = CGRect.init(x: 20, y: 20 + titleHeight + 15, width: textInfoWidth - 40, height: contentHeight)
            let totalHeight = 20 + 15 + 20 + titleHeight + contentHeight
            if totalHeight > self.bounds.size.height - 148 {
                textInfoView.frame = CGRect.init(x: 20, y: (self.bounds.size.height - defaultHeight)/2.0, width: textInfoWidth, height: defaultHeight)
            } else {
                textInfoView.frame = CGRect.init(x: 20, y: (self.bounds.size.height - totalHeight)/2.0, width: textInfoWidth, height: totalHeight)
            }
            textInfoView.contentSize = CGSize.init(width: textInfoWidth, height: totalHeight)
        }
    }
    
    public func show(animated: Bool = true) {
        setNeedsLayout()
        
        delegate?.popupCard?(card: self, willShowIn: parentView)
        
        if animated {
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                guard let `self` = self else { return }
                self.alpha = 1
                self.currentBGView.alpha = 1
                if self.type == .text {
                    self.textInfoView.alpha = 1
                }
                else if self.type == .image {
                    self.imageInfoView.alpha = 1
                }
                else if self.type == .custom {
                    self.contentView?.alpha = 1
                }
                }, completion: { (finished) in
                    self.didShow()
            })
        }
        else {
            self.alpha = 1
            self.currentBGView.alpha = 1
            if self.type == .text {
                self.textInfoView.alpha = 1
            }
            else if self.type == .image {
                self.imageInfoView.alpha = 1
            }
            else if self.type == .custom {
                self.contentView?.alpha = 1
            }
            self.didShow()
        }
    }
    
    private func didShow() {
        delegate?.popupCard?(card: self, didShowIn: parentView)
    }
    
    public func hide(animated: Bool = true) {
        delegate?.popupCard?(card: self, willHideIn: parentView)
        
        if animated {
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                guard let `self` = self else { return }
                self.alpha = 0
                self.currentBGView.alpha = 0
                if self.type == .text {
                    self.textInfoView.alpha = 0
                }
                else if self.type == .image {
                    self.imageInfoView.alpha = 0
                }
                else if self.type == .custom {
                    self.contentView?.alpha = 0
                }
                }, completion: { (finished) in
                    self.didHide()
            })
        }
        else {
            self.alpha = 0
            self.currentBGView.alpha = 0
            if self.type == .text {
                self.textInfoView.alpha = 0
            }
            else if self.type == .image {
                self.imageInfoView.alpha = 0
            }
            else if self.type == .custom {
                self.contentView?.alpha = 0
            }
            self.didHide()
        }
    }
    
    private func didHide() {
        delegate?.popupCard?(card: self, didHideIn: parentView)
        self.removeFromSuperview()
    }
    
    @objc private func areaAction(_ sender: UITapGestureRecognizer) {
        hide()
        delegate?.popupCard?(didClickArea: self)
    }
    
    @objc private func titleAction(_ sender: UITapGestureRecognizer) {
        hide()
        delegate?.popupCard?(didClickTitle: self)
    }
    
    @objc private func contentAction(_ sender: UITapGestureRecognizer) {
        hide()
        delegate?.popupCard?(didClickImage: self)
    }
    
    @objc private func imageAction(_ sender: UITapGestureRecognizer) {
        hide()
        delegate?.popupCard?(didClickImage: self)
    }
    
    @objc private func cancelAction(_ sender: UIButton) {
        hide()
        delegate?.popupCard?(didClickCancel: self)
    }
}

extension BRPopupCard {
    
    func show(_ title: String, content: String) {
        type = .text
        self.title = title
        self.content = content
        background = .blur
        show()
    }
    
    func show(_ image: UIImage) {
        type = .image
        self.img = image
        background = .mask
        show()
    }
    
    func show(_ imageUrl: String) {
        type = .image
        self.imgUrl = imageUrl
        background = .mask
        show()
    }
    
    func show(_ contentView: UIView) {
        type = .custom
        self.contentView = contentView
        background = .blur
        show()
    }
    
    
    class func show(_ title: String, content: String, inView: UIView) -> BRPopupCard {
        let card = BRPopupCard.init(view: inView)
        card.show(title, content: content)
        return card
    }
    
    class func show(_ image: UIImage, inView: UIView) -> BRPopupCard {
        let card = BRPopupCard.init(view: inView)
        card.show(image)
        return card
    }
    
    class func show(_ imageUrl: String, inView: UIView) -> BRPopupCard {
        let card = BRPopupCard.init(view: inView)
        card.show(imageUrl)
        return card
    }
    
    class func show(_ contentView: UIView, inView: UIView) -> BRPopupCard {
        let card = BRPopupCard.init(view: inView)
        card.show(contentView)
        return card
    }
}
