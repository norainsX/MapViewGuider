//
//  ebouncer.swift
//  WorldRoad
//
//  Created by norains on 2020/10/17.
//  Copyright © 2020 norains. All rights reserved.
//

import Combine
import SwiftUI

class Debouncer {
    private var perform: () -> Void
    private var delayMilliseconds: Int
    private var publisher: PassthroughSubject<Int, Never> = PassthroughSubject<Int, Never>()
    private var subscriber: AnyCancellable?

    init(delayMilliseconds: Int, perform: @escaping () -> Void) {
        self.delayMilliseconds = delayMilliseconds
        self.perform = perform
    }

    func restart() {
        if subscriber == nil {
            subscriber = publisher
                .debounce(for: .milliseconds(delayMilliseconds), scheduler: RunLoop.main)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in
                },

                receiveValue: { _ in
                    self.perform()
                })
        }

        publisher.send(0)
    }
}
