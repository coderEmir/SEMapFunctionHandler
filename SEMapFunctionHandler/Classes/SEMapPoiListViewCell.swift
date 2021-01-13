//
//  SEMapPoiListViewCell.swift
//  SEMapFunctionHandler
//
//  Created by wenchang on 2021/1/4.
//

import UIKit
import AMapSearchKit

class SEMapPoiListViewCell: UITableViewCell {

    var mapPoi: AMapPOI? = nil {
        willSet(newMapPoi) {

            addressLb.text = newMapPoi?.name
            addressDetailLb.text = newMapPoi?.address
        }
    }
    
    var isAddressUnSelected: Bool = false {
        willSet (newIsAddressUnSelected) {
            checkImageV.isHidden = newIsAddressUnSelected
        }
    }
    
    lazy var addressLb: UILabel = {
        let addressLb = UILabel.init()
        addressLb.font = UIFont.systemFont(ofSize: 15)
        addressLb.textColor = UIColor(red: 37 / 255.0, green: 33 / 255.0, blue: 32 / 255.0, alpha: 1)
        return addressLb
    }()
    
    lazy var addressDetailLb: UILabel = {
        let addressDetailLb = UILabel.init()
        addressDetailLb.font = UIFont.systemFont(ofSize: 12)
        addressDetailLb.textColor = UIColor(red: 176 / 255.0, green: 175 / 255.0, blue: 173 / 255.0, alpha: 1)
        return addressDetailLb
    }()
    
    lazy var checkImageV: UIImageView = {
        let marker = UIImage(imageName: "check_address", currentClass:SEMapPoiListViewCell.classForCoder())
        let checkImageV = UIImageView.init(image: marker)
        checkImageV.isHidden = true
        checkImageV.contentMode = .left
        return checkImageV
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        self.selectionStyle = .none
        
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func render() {
        contentView.addSubview(addressLb)
        contentView.addSubview(addressDetailLb)
        contentView.addSubview(checkImageV)
        
        addressLb.snp.makeConstraints { make in
            make.left.equalTo(17.5)
            make.top.equalTo(13)
            make.height.equalTo(16)
            make.width.lessThanOrEqualTo(260)
        }
        addressDetailLb.snp.makeConstraints { make in
            make.width.left.equalTo(addressLb)
            make.bottom.equalTo(-12)
            make.height.equalTo(12)
        }
        checkImageV.snp.makeConstraints { make in
            make.right.top.bottom.equalTo(0)
            make.width.equalTo(37)
        }
    }
}
