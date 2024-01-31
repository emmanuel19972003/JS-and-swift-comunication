//
//  ViewController.swift
//  JS comunication
//
//  Created by Emmanuel Zambrano Quitian on 1/25/24.
//

import UIKit
import WebKit

enum JSActions: String {
    case buttonOne = "buton_one"
    case buttonTwo = "buton_two"
    case error
}

class ViewController: UIViewController {
    
    
    
    var webView = WKWebView()
    let button = UIButton(frame: .zero)
    var webViewGoogle = WKWebView()
    let buttonGoogle = UIButton(frame: .zero)
    let httpContent = """
    <!DOCTYPE html><html><body>

    <input 
        style="font-size : 50px; width: 100%; height: 100px;"

        type="text"
        placeholder="Name"

        id="fname"

        name="fname">

    <button 
        style="font-size : 50px; width: 100%; height: 200px;"

        id="alert-button"

        onclick="onClick()"

        >Click me</button>

    <button
        style="font-size : 50px; width: 100%; height: 200px;"

        id="el-button2"

        onclick="onClick2()"

        >Boton 2</button>

    <script>

    function onClick() {

    window.webkit.messageHandlers.buttonOne.postMessage("Button One Action");

    }

    function onClick2() {

    window.webkit.messageHandlers.buttonTwo.postMessage("Button Two Action");

    }

    </script>

    </body></html>

    """

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpwebView()
        setUpGoogleWebView()
        setUpButtons()
        viewHierarchy()
        viewConstraints()
    }
    
    func viewHierarchy() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        webViewGoogle.translatesAutoresizingMaskIntoConstraints = false
        buttonGoogle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        view.addSubview(button)
        view.addSubview(webViewGoogle)
        view.addSubview(buttonGoogle)

    }
    
    func viewConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            webView.heightAnchor.constraint(equalToConstant: 200),
            
            button.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 10),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            button.heightAnchor.constraint(equalToConstant: 100),
            
            webViewGoogle.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10),
            webViewGoogle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            webViewGoogle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            webViewGoogle.heightAnchor.constraint(equalToConstant: 300),
            
            buttonGoogle.topAnchor.constraint(equalTo: webViewGoogle.bottomAnchor, constant: 10),
            buttonGoogle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            buttonGoogle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            buttonGoogle.heightAnchor.constraint(equalToConstant: 100)
            
        ])
        
    }
    
    func setUpwebView() {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = WKUserContentController()
        configuration.userContentController.add(self, name: "buttonOne")
        configuration.userContentController.add(self, name: "buttonTwo")
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.loadHTMLString(httpContent, baseURL: nil)
    }
    
    func setUpGoogleWebView() {
        let link = URL(string: "https://www.google.com/")!
        let request = URLRequest(url: link)
        webViewGoogle.load(request)
    }
    
    func setUpButtons() {
        button.addTarget(self, action: #selector(buttonTaped), for: .touchUpInside)
        button.setTitle("Tap me", for: .normal)
        button.backgroundColor = .systemBlue
        
        buttonGoogle.addTarget(self, action: #selector(buttonGoogleTaped), for: .touchUpInside)
        buttonGoogle.setTitle("Tap me for Google", for: .normal)
        buttonGoogle.backgroundColor = .systemBlue
    }
    
    @objc func buttonTaped() {
        let jsCode = "document.getElementById('fname').value"
        webView.evaluateJavaScript(jsCode) { result, error in
            print(result)
        }
    }
    
    @objc func buttonGoogleTaped() {
        //SIvCob
        let jsCode =  "document.getElementById('SIvCob').textContent = 'Hello world!';"
        webViewGoogle.evaluateJavaScript(jsCode) { result, error in
            print(result)
        }
    }


}

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name)
        print(message.body)
        if let action = JSActions(rawValue: message.name) {
            switch action {
            case .buttonOne:
                print(message.body)
            case .buttonTwo:
                print(message.body)
            case .error:
                print("error")
            }
            
        }
    }
}

