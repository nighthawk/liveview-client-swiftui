//
//  PhxImage.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

struct PhxImage: View {
    @ObservedElement private var element: ElementNode
    
    init<R: CustomRegistry>(element: ElementNode, context: LiveContext<R>) {
        self._element = ObservedElement(element: element, context: context)
    }
    
    public var body: some View {
        switch mode {
        case .symbol(let name):
            Image(systemName: name)
                .scaledIfPresent(scale: symbolScale)
                .foregroundColor(symbolColor)
        case .asset(let name):
            Image(name)
                // todo: this probably only works for symbols
                .scaledIfPresent(scale: symbolScale)
                .foregroundColor(symbolColor)
        }
    }
    
    private var mode: Mode {
        if let systemName = element.attributeValue(for: "system-name") {
            return .symbol(systemName)
        } else if let name = element.attributeValue(for: "name") {
            return .asset(name)
        } else {
            preconditionFailure("<image> must have system-name or name")
        }
    }
    
    private var symbolColor: Color? {
        if let attr = element.attributeValue(for: "symbol-color") {
            return Color(fromNamedOrCSSHex: attr)
        } else {
            return nil
        }
    }
    
    private var symbolScale: Image.Scale? {
        switch element.attributeValue(for: "symbol-scasle") {
        case nil:
            return nil
        case "small":
            return .small
        case "medium":
            return .medium
        case "large":
            return .large
        case .some(let attr):
            fatalError("invalid value '\(attr)' for symbol-scale")
        }
    }
}

extension PhxImage {
    enum Mode {
        case symbol(String)
        case asset(String)
    }
}

fileprivate extension Image {
    @ViewBuilder
    func scaledIfPresent(scale: Image.Scale?) -> some View {
        if let scale = scale {
            self.imageScale(scale)
        } else {
            self
        }
    }
}
