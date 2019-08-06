//
//  Stem
//
//  Copyright (c) 2017 linhay - https://github.com/linhay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

import UIKit

public extension UIViewController {
    
    /// 获取当前显示控制器
    static var current: UIViewController? {
        func find(rawVC: UIViewController) -> UIViewController {
            switch rawVC {
            case let nav as UINavigationController:
                guard let vc = nav.viewControllers.last else { return rawVC }
                return find(rawVC: vc)
            case let tab as UITabBarController:
                guard let vc = tab.selectedViewController else { return rawVC }
                return find(rawVC: vc)
            case let vc where vc.presentedViewController != nil:
                return find(rawVC: vc.presentedViewController!)
            default:
                return rawVC
            }
        }
        guard let rootViewController = UIApplication.shared.windows.filter({ (item) -> Bool in
            /// =.=,如果没手动设置的话...
            return item.windowLevel == UIWindow.Level.normal && item.isKeyWindow
        }).first?.rootViewController else {
            assert(false)
            return UIViewController()
        }
        return find(rawVC: rootViewController)
    }
    
}

// MARK: - UIViewController
public extension Stem where Base: UIViewController {
    
    /// tabbarHeight高度
    var tabbarHeight: CGFloat {
        return base.tabBarController?.tabBar.bounds.height ?? 0
    }
    
    /// 能否回退
    var canback: Bool {
        return (base.navigationController?.viewControllers.count ?? 0) > 1
    }
    
    /// 当前是控制器是否是被modal出来
    var isByPresented: Bool {
        guard base.presentingViewController == nil else { return false }
        return true
    }
    
    /// 是否是当前显示控制器
    var isVisible: Bool {
        guard let vc = UIViewController.current else { return false }
        return vc == base || vc.tabBarController == base || vc.navigationController == base
    }


    /// 父控制器
    var parents: [UIViewController] {
        var list = [UIViewController]()
        var vc: UIViewController = base
        while let parent = vc.parent {
            list.append(parent)
            vc = parent
        }
        return list
    }

    /// 惰性查询父控制器
    ///
    /// - Parameter where: 条件
    /// - Returns: 父控制器
    func first(parent where: (_: UIViewController) -> Bool) -> UIViewController? {
        var vc: UIViewController = base
        while let parent = vc.parent {
            if `where`(parent) { return parent }
            vc = parent
        }
        return nil
    }


    /// 添加子控制器
    ///
    /// - Parameter childs: 子控制器
    @discardableResult
    func addChilds(_ childs: UIViewController...) -> Stem<Base> {
        childs.forEach({base.addChild($0)})
        return self
    }

    /// 前进至指定控制器
    ///
    /// - Parameters:
    ///   - vc: 指定控制器
    ///   - isRemove: 前进后是否移除当前控制器
    ///   - animated: 是否显示动画
    @discardableResult
    func push(vc: UIViewController?, isRemove: Bool = false, animated: Bool = true) -> Stem<Base> {
        guard let vc = vc else { return self }
        switch base {
        case let nav as UINavigationController:
            nav.pushViewController(vc, animated: animated)
        default:
            base.navigationController?.pushViewController(vc, animated: animated)
            if isRemove {
                guard let vcs = base.navigationController?.viewControllers else{ return self }
                guard let flags = vcs.firstIndex(of: base.self) else { return self }
                base.navigationController?.viewControllers.remove(at: flags)
            }
        }
        return self
    }
    
    /// modal 指定控制器
    ///
    /// - Parameters:
    ///   - vc: 指定控制器
    ///   - animated: 是否显示动画
    ///   - completion: 完成后事件
    @discardableResult
    func present(vc: UIViewController?, animated: Bool = true, completion: (() -> Void)? = nil) -> Stem<Base> {
        guard let vc = vc else { return self }
        base.present(vc, animated: animated, completion: completion)
        return self
    }
    
    /// 后退一层控制器
    ///
    /// - Parameter animated: 是否显示动画
    /// - Returns: vc
    @discardableResult
    func pop(animated: Bool) -> UIViewController? {
        switch base {
        case let nav as UINavigationController:
            return nav.popViewController(animated: animated)
        default:
            return base.navigationController?.popViewController(animated: animated)
        }
    }
    
    /// 后退至指定控制器
    ///
    /// - Parameters:
    ///   - vc: 指定控制器
    ///   - animated: 是否显示动画
    /// - Returns: vcs
    @discardableResult
    func pop(vc: UIViewController, animated: Bool) -> [UIViewController]? {
        switch base {
        case let nav as UINavigationController:
            return nav.popToViewController(vc, animated: animated)
        default:
            return base.navigationController?.popToViewController(vc, animated: animated)
        }
    }
    
    /// 后退至根控制器
    ///
    /// - Parameter animated: 是否显示动画
    /// - Returns: vcs
    @discardableResult
    func pop(toRootVC animated: Bool) -> [UIViewController]? {
        if let vc = base as? UINavigationController {
            return vc.popToRootViewController(animated: animated)
        }else{
            return base.navigationController?.popToRootViewController(animated: animated)
        }
    }
    
}
