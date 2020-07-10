//
//  JamKerjaTimVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 30/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import WebKit
import DIKit
import SVProgressHUD
import RxSwift
import SafariServices

class JamKerjaTimVC: BaseViewController, WKNavigationDelegate, WKUIDelegate {

//    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var labelNotSupported: CustomLabel!
    @IBOutlet weak var buttonUseSafari: CustomButton!
    @IBOutlet weak var viewNotSupported: UIView!
    @IBOutlet weak var viewNotSupportedHeight: NSLayoutConstraint!
    @IBOutlet weak var viewContainer: UIView!
    
    @Inject private var filterJamKerjaTimVM: FilterJamKerjaTimVM
    @Inject private var jamKerjaTimVM: JamKerjaTimVM
    private var disposeBag = DisposeBag()
    lazy var webview: WKWebView = {
        let wv = WKWebView()
        wv.uiDelegate = self
        wv.navigationDelegate = self
        wv.translatesAutoresizingMaskIntoConstraints = false
        return wv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterJamKerjaTimVM.resetFilterJamKerjaTim()
        
        setupView()
        
        observeData()
        
        jamKerjaTimVM.daftarShift(nc: navigationController, data: (dateStart: "", dateEnd: "", listKaryawan: [String]()))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView == webview {
            jamKerjaTimVM.isLoading.accept(false)
        }
    }
    
    private func hideNotSupported() {
        viewNotSupported.isHidden = true
        viewNotSupportedHeight.constant = 0
        self.view.layoutIfNeeded()
    }
    
    private func setupView() {
        webview.navigationDelegate = self
    }
    
    @IBAction func useSafariClick(_ sender: Any) {
        if let url = URL(string: jamKerjaTimVM.url.value) {
            UIApplication.shared.open(url)
        }
    }
    
    private func observeData() {
        jamKerjaTimVM.isLoading.subscribe(onNext: { value in
            if value {
                self.addBlurView(view: self.view)
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                self.removeBlurView(view: self.view)
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
        
        jamKerjaTimVM.url.subscribe(onNext: { value in
            if #available(iOS 11, *) {
                self.viewContainer.addSubview(self.webview)
                NSLayoutConstraint.activate([
                    self.webview.leadingAnchor.constraint(equalTo: self.viewContainer.leadingAnchor),
                    self.webview.topAnchor.constraint(equalTo: self.viewContainer.topAnchor),
                    self.webview.rightAnchor.constraint(equalTo: self.viewContainer.rightAnchor),
                    self.webview.bottomAnchor.constraint(equalTo: self.viewContainer.bottomAnchor)])
                self.hideNotSupported()
                self.webview.isHidden = false
                let url = URL(string: value)
                guard let _url = url else { return }
                self.webview.load(URLRequest(url: _url))
            } else {
                self.labelNotSupported.text = "webview_not_supported".localize()
                self.buttonUseSafari.setTitle("use_safari".localize(), for: .normal)
                
                UIView.animate(withDuration: 0.2) {
                    self.webview.isHidden = true
                    self.viewNotSupported.isHidden = false
                    self.viewNotSupportedHeight.constant = 1000
                }
            }
        }).disposed(by: disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

extension JamKerjaTimVC: FilterJamKerjaTimProtocol {
    func applyFilter(dateStart: String, dateEnd: String, listKaryawan: [String]) {
        jamKerjaTimVM.daftarShift(nc: navigationController, data: (dateStart: dateStart == "" ? "" : PublicFunction.dateStringTo(date: dateStart, fromPattern: "dd/MM/yyyy", toPattern: "yyyy-MM-dd"), dateEnd: dateEnd == "" ? "" : PublicFunction.dateStringTo(date: dateEnd, fromPattern: "dd/MM/yyyy", toPattern: "yyyy-MM-dd"), listKaryawan: listKaryawan))
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonFilterClick(_ sender: Any) {
        let vc = FilterJamKerjaTimVC()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}
