//MIT License
//
//Copyright (c) 2019 Ryan Baumbach <github@ryan.codes>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

import UIKit

public protocol AppLaunchViewControllerDelegate: class {
    func didStartLaunching(completionHandler: @escaping () -> Void)
    func didFinishLaunching()
}

public class AppLaunchViewController: UIViewController {
    // MARK: - Type aliases
    
    public typealias OnLaunchHandler = (() -> Void) -> Void
    
    // MARK: - Public properties
    
    public var customLoadingView: UIView?
    
    // MARK: - Private properties
    
    private weak var delegate: AppLaunchViewControllerDelegate?
    
    private var onLaunch: OnLaunchHandler?
    private var onCompletion: (() -> Void)?
    
    // MARK: - Init methods
    
    public convenience init(delegate: AppLaunchViewControllerDelegate) {
        self.init(nibName: nil, bundle: nil)
        
        self.delegate = delegate
    }
    
    public convenience init(onLaunch: @escaping OnLaunchHandler, onCompletion: @escaping () -> Void) {
        self.init(nibName: nil, bundle: nil)
        
        self.onLaunch = onLaunch
        self.onCompletion = onCompletion
    }
    
    // MARK: - View lifecycle
    
    public override func loadView() {
        super.loadView()

        setupLoadingView()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let delegate = delegate {
            delegate.didStartLaunching { [weak self] in
                self?.delegate?.didFinishLaunching()
            }
        } else {
            onLaunch? { [weak self] in
                self?.onCompletion?()
            }
        }
    }
    
    // MARK: - Private methods
    
    private func setupLoadingView() {
        if let customLoadingView = customLoadingView {
            view = customLoadingView
        } else {
            setupDefaultLoadingView()
        }
    }
    
    private func setupDefaultLoadingView() {
        view.backgroundColor = .black
        
        setupDefaultActivityIndicatorView()
    }
    
    private func setupDefaultActivityIndicatorView() {
        let activityIndicatorView = UIActivityIndicatorView()
        
        anchor(activityIndicatorView, toParentView: view)
        
        if #available(iOS 13.0, *) {
            activityIndicatorView.style = .large
        } else {
            activityIndicatorView.style = .whiteLarge
        }
        
        activityIndicatorView.color = .white
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidesWhenStopped = true
    }
    
    private func anchor(_ childView: UIView, toParentView parentView: UIView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(childView)
        
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                childView.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor),
                childView.leadingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leadingAnchor),
                childView.trailingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.trailingAnchor),
                childView.bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                childView.topAnchor.constraint(equalTo: parentView.topAnchor),
                childView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
                childView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
                childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
            ])
        }
    }
}

/*
 
 Notes: Override loadView() in the view lifecycle if you specify a nil nibName in init(nibname:bundle:), or else
 The system will attempt to fetch a nib in various ways.
 https://developer.apple.com/documentation/uikit/uiviewcontroller/1621487-nibname
 
 */
