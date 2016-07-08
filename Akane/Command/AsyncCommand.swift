//
// This file is part of Akane
//
// Created by JC on 06/07/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

/**
 Adds an attribute `isExecuting` which you can observe to determine whether or not the command is running.
*/
public class AsyncCommand : RelayCommand {
    private(set) var isExecuting = Observable(false)

    /**
     @see RelayCommand
     `action` closure receives an extra parameter compared to `RelayCommand`: `completed`. Use it to inform `AsyncCommand`
     that your action is terminated and thus `isExecuting` should be passed to `false`.
    */
    public init(canExecute canExecuteUpdater: () -> Bool, action: (UIControl?, completed: (Void -> Void)) -> Void) {
        super.init(canExecute: canExecuteUpdater, action: { _ in })

        self.action = { [weak self] control in
            guard let strongSelf = self else {
                return
            }

            strongSelf.isExecuting.next(true)
            action(control, completed: { strongSelf.isExecuting.next(false) })
        }
    }

    public convenience init(action: (UIControl?, completed: (Void -> Void)) -> Void) {
        self.init(canExecute: { return true }, action: action)
    }

    /// Action is executable only if not already executing
    public override func execute(trigger: UIControl?) {
        guard !self.isExecuting.value else {
            return
        }

        super.execute(trigger)
    }

}