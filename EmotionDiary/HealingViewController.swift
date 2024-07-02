//
//  HealingViewController.swift
//  EmotionDiary
//
//  Created by NERO on 7/1/24.
//

import UIKit
import SnapKit

final class HealingViewController: UIViewController {
    enum Nasa: String, CaseIterable {
        static let baseURL = "https://apod.nasa.gov/apod/image/"
        case one = "2308/sombrero_spitzer_3000.jpg"
        case two = "2212/NGC1365-CDK24-CDK17.jpg"
        case three = "2307/M64Hubble.jpg"
        case four = "2306/BeyondEarth_Unknown_3000.jpg"
        case five = "2307/NGC6559_Block_1311.jpg"
        case six = "2304/OlympusMons_MarsExpress_6000.jpg"
        case seven = "2305/pia23122c-16.jpg"
        case eight = "2308/SunMonster_Wenz_960.jpg"
        case nine = "2307/AldrinVisor_Apollo11_4096.jpg"
        static var photoURL: URL {
            return URL(string: Nasa.baseURL + Nasa.allCases.randomElement()!.rawValue)!
        }
    }
    
    private let healingTextLabel = {
        let label = UILabel()
        label.text = "✨ 우주 사진을 보며 힐링해 보아요! 🔭"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        return label
    }()
    
    private let requestButton = {
        let button = UIButton()
        button.setTitle("클릭", for: .normal)
        button.setTitleColor(.systemPurple, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.backgroundColor = .indicator
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private let healingImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let progressLabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.backgroundColor = .darkGray.withAlphaComponent(0.9)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    var urlSession = URLSession()
    var totalData: Double = 0
    var buffer: Data? {
        didSet {
            let currentPercentage = (Double(buffer?.count ?? 0) / totalData) * 100
            if !currentPercentage.isNaN {
                let formatPercentage = 100 - Int(currentPercentage)
                progressLabel.isHidden = false
                progressLabel.text = "멋진 사진이 도착하기까지\n\(formatPercentage)% 남았어요 👀"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (buffer != nil) {
            urlSession.invalidateAndCancel()
        }
    }
}

extension HealingViewController {
    private func configureHierarchy() {
        [healingTextLabel, requestButton, healingImageView, progressLabel].forEach {
            view.addSubview($0)
        }
    }
    
    private func configureLayout() {
        healingTextLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }
        requestButton.snp.makeConstraints {
            $0.top.equalTo(healingTextLabel.snp.bottom).offset(8)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(60)
            $0.height.equalTo(30)
        }
        healingImageView.snp.makeConstraints {
            $0.top.equalTo(requestButton.snp.bottom).offset(25)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(400)
        }
        progressLabel.snp.makeConstraints {
            $0.center.equalTo(healingImageView)
            $0.height.equalTo(150)
            $0.width.equalTo(170)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .black
        progressLabel.isHidden = true
        requestButton.addTarget(self, action: #selector(requestButtonClicked), for: .touchUpInside)
    }
    
    @objc func requestButtonClicked() {
        requestButton.isUserInteractionEnabled = false
        buffer = Data()
        requestNasaPhoto()
    }
}

extension HealingViewController: URLSessionDataDelegate {
    func requestNasaPhoto() {
        let request = URLRequest(url: Nasa.photoURL)
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        urlSession.dataTask(with: request).resume()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) async -> URLSession.ResponseDisposition {
        if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) {
            let contentLength = response.value(forHTTPHeaderField: "Content-Length")!
            totalData = Double(contentLength)!
            return .allow
        } else {
            return .cancel
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        buffer?.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        if let error {
            progressLabel.text = "사진을 불러오지 못했어요 😞"
            healingImageView.image = UIImage.slime9
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.progressLabel.isHidden = true
            }
        } else {
            guard let buffer = buffer else {
                requestButton.isUserInteractionEnabled = true
                return
            }
            progressLabel.text = "⭐️ 짠! ⭐️"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.progressLabel.isHidden = true
            }
            let responseImage = UIImage(data: buffer)
            healingImageView.image = responseImage
        }
        requestButton.isUserInteractionEnabled = true
    }
}
