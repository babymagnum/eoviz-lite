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

    @IBOutlet weak var webView: WKWebView!
    
    @Inject private var filterJamKerjaTimVM: FilterJamKerjaTimVM
    @Inject private var jamKerjaTimVM: JamKerjaTimVM
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterJamKerjaTimVM.resetFilterJamKerjaTim()
        
        jamKerjaTimVM.resetVariable()
        
        setupView()
        
        observeData()
        
        getData()
    }
    
    private func getData() {
        jamKerjaTimVM.daftarShift(nc: navigationController, data: (dateStart: jamKerjaTimVM.dateStart.value, dateEnd: jamKerjaTimVM.dateEnd.value, listKaryawan: jamKerjaTimVM.listKaryawan.value))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView == self.webView {
            jamKerjaTimVM.isLoading.accept(false)
        }
    }
    
    private func setupView() {
        webView.scrollView.addSubview(refreshControl)
        webView.navigationDelegate = self
    }
    
    override func _handleRefresh(refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        getData()
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
//            self.viewContainer.addSubview(self.webview)
//            NSLayoutConstraint.activate([
//                self.webview.leadingAnchor.constraint(equalTo: self.viewContainer.leadingAnchor),
//                self.webview.topAnchor.constraint(equalTo: self.viewContainer.topAnchor),
//                self.webview.rightAnchor.constraint(equalTo: self.viewContainer.rightAnchor),
//                self.webview.bottomAnchor.constraint(equalTo: self.viewContainer.bottomAnchor)])
            let url = URL(string: value)
            guard let _url = url else { return }
            self.webView.load(URLRequest(url: _url))
        }).disposed(by: disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

extension JamKerjaTimVC: FilterJamKerjaTimProtocol {
    func applyFilter(dateStart: String, dateEnd: String, listKaryawan: [String]) {
        jamKerjaTimVM.dateStart.accept(dateStart == "" ? "" : PublicFunction.dateStringTo(date: dateStart, fromPattern: "dd/MM/yyyy", toPattern: "yyyy-MM-dd"))
        jamKerjaTimVM.dateEnd.accept(dateEnd == "" ? "" : PublicFunction.dateStringTo(date: dateEnd, fromPattern: "dd/MM/yyyy", toPattern: "yyyy-MM-dd"))
        jamKerjaTimVM.listKaryawan.accept(listKaryawan)
        
        getData()
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
