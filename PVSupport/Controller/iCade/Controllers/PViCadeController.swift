//  Converted to Swift 4 by Swiftify v4.2.29618 - https://objectivec2swift.com/
//
//  PViCadeController.swift
//  Provenance
//
//  Created by Josejulio Martínez on 19/06/15.
//  Copyright (c) 2015 Josejulio Martínez. All rights reserved.
//

import GameController

public class PViCadeController: GCController {
	
    public private(set) var iCadeGamepad: PViCadeGamepad = PViCadeGamepad()
    public let reader: PViCadeReader = PViCadeReader.shared
    public var controllerPressedAnyKey: ((_ controller: PViCadeController?) -> Void)?

    public func refreshListener() {
        reader.stopListening()
        reader.listenToKeyWindow()
    }

    deinit {
        reader.stopListening()
    }

    func button(forState button: iCadeControllerState) -> PViCadeGamepadButtonInput? {
        switch button {
        case iCadeControllerState.buttonA:
            return self.iCadeGamepad.rightTrigger
        case iCadeControllerState.buttonB:
            return self.iCadeGamepad.leftShoulder
        case iCadeControllerState.buttonC:
            return self.iCadeGamepad.leftTrigger
        case iCadeControllerState.buttonD:
            return self.iCadeGamepad.rightShoulder
        case iCadeControllerState.buttonE:
            return self.iCadeGamepad.buttonY
        case iCadeControllerState.buttonF:
            return self.iCadeGamepad.buttonB
        case iCadeControllerState.buttonG:
            return self.iCadeGamepad.buttonX
        case iCadeControllerState.buttonH:
            return self.iCadeGamepad.buttonA
        case iCadeControllerState.buttonH:
            return self.iCadeGamepad.leftTrigger
        case iCadeControllerState.buttonH:
            return self.iCadeGamepad.rightTrigger
        default:
            return nil
        }
    }

    public override init() {
        super.init()

		reader.buttonDownHandler = { [weak self] button in
            guard let `self` = self else { return }

            switch button {
			case iCadeControllerState.joystickDown, iCadeControllerState.joystickLeft, iCadeControllerState.joystickRight, iCadeControllerState.joystickUp:
                DLOG("Pad Changed: \(button)")
				self.iCadeGamepad.dpad.padChanged()
			default:
                if let button = self.button(forState: button) {
                    DLOG("Pressed button: \(button)")
                    button.isPressed = true
                } else {
                    DLOG("Unsupported button: \(button)")
                }
            }

			self.controllerPressedAnyKey?(self)
		}

		reader.buttonUpHandler = { [weak self] button in
            guard let `self` = self else { return }

            switch button {
            case iCadeControllerState.joystickDown, iCadeControllerState.joystickLeft, iCadeControllerState.joystickRight, iCadeControllerState.joystickUp:
                DLOG("Pad Changed: \(button)")
                self.iCadeGamepad.dpad.padChanged()
            default:
                if let button = self.button(forState: button) {
                    DLOG("De-Pressed button: \(button)")
                    button.isPressed = false
                } else {
                    DLOG("Unsupported button: \(button)")
                }
            }
		}
    }

	override public var controllerPausedHandler: ((GCController) -> Void)? {
        get {
            return super.controllerPausedHandler
        }
        set(controllerPausedHandler) {
            // dummy method to avoid NSInternalInconsistencyException
        }
    }

	override public var gamepad: GCGamepad? {
        return nil
    }

	override public var extendedGamepad: GCExtendedGamepad? {
        return iCadeGamepad
    }

	override public var vendorName: String? {
        return "iCade"
    }

    // don't know if it's nessesary but seems good
	public override var isAttachedToDevice: Bool {
		return false
	}

    // don't know if it's nessesary to set a specific index but without implementing this method the app crashes
	private var _playerIndex: GCControllerPlayerIndex = GCControllerPlayerIndex(rawValue: 0)!
	override public var playerIndex: GCControllerPlayerIndex {
		get {
			return _playerIndex
		}
		set {
			_playerIndex = newValue
		}
	}
}
