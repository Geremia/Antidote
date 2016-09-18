//
//  StaticTableDefaultCellModel.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 08/12/15.
//  Copyright © 2015 dvor. All rights reserved.
//

import Foundation

class StaticTableDefaultCellModel: StaticTableSelectableCellModel {
    enum RightImageType {
        case none
        case arrow
        case checkmark
    }

    var userStatus: UserStatus?

    var title: String?
    var value: String?

    var rightButton: String?
    var rightButtonHandler: ((Void) -> Void)?

    var rightImageType: RightImageType = .none

    var userInteractionEnabled: Bool = true

    var canCopyValue: Bool = false
}
