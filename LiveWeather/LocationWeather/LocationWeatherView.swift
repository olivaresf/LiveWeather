//
//  LocationWeatherView.swift
//  LiveWeather
//
//  Created by Nirav Bhatt on 11/3/20.
//

import UIKit
import SnapKit

protocol LocationWeatherViewDelegate: AnyObject {
    func segmentSelected(idx: Int)
}

class LocationWeatherView: UIView {
	lazy var timeStampTextLabel: UILabel = UILabel()
	lazy var timeStampLabel: UILabel = UILabel()
	lazy var hStackForTimeStamp: UIStackView = UIStackView(
		arrangedSubviews: [self.timeStampTextLabel, self.timeStampLabel])

	lazy var weatherStateTextLabel: UILabel = UILabel()
	lazy var weatherStateLabel: UILabel = UILabel()
	lazy var hStackForWeatherState: UIStackView = UIStackView(
		arrangedSubviews: [self.weatherStateTextLabel, self.weatherStateLabel])

	lazy var temperatureTextLabel: UILabel = UILabel()
    lazy var temperatureLabel: UILabel = UILabel()
	lazy var hStackForTemperature: UIStackView = UIStackView(
		arrangedSubviews: [self.temperatureTextLabel, self.temperatureLabel])

	lazy var humidityTextLabel: UILabel = UILabel()
	lazy var humidityLabel: UILabel = UILabel()
	lazy var hStackForHumidity: UIStackView = UIStackView(
		arrangedSubviews: [self.humidityTextLabel, self.humidityLabel])

	lazy var windSpeedTextLabel: UILabel = UILabel()
	lazy var windSpeedLabel: UILabel = UILabel()
	lazy var hStackForWindSpeed: UIStackView = UIStackView(
		arrangedSubviews: [self.windSpeedTextLabel, self.windSpeedLabel])

    lazy var selectedLocationTitle: UILabel = UILabel()
    lazy var segmentControl: UISegmentedControl = UISegmentedControl()

	lazy var vStack: UIStackView = UIStackView(arrangedSubviews:
		[self.segmentControl, self.selectedLocationTitle, self.hStackForTimeStamp, self.hStackForWeatherState,
		self.hStackForTemperature, self.hStackForHumidity, self.hStackForWindSpeed])

    var segmentTitles: [String] = []
	weak var delegate: LocationWeatherViewDelegate?

    init(delegate: LocationWeatherViewDelegate, segmentTitles: [String]) {
        self.delegate = delegate
        super.init(frame: .zero)
        self.segmentTitles = segmentTitles
        self.configureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureSubviews() {
        self.backgroundColor = .panelBackground
        self.cornerRadius = 8.0
        self.applyShadow()
		self.configureTimeStampUI()
		self.configureWeatherStateUI()
		self.configureTemperatureUI()
		self.configureHumidityUI()
		self.configureWindSpeedUI()
		self.configureSegmentControl()

		self.configureVStack()
    }

	func configureTimeStampUI() {
		self.timeStampTextLabel.textAlignment = .right
		self.timeStampLabel.textAlignment = .left

		self.timeStampTextLabel.text = DisplayConstants.updatedAt.rawValue
		self.timeStampLabel.text = Date().getFriendlyTime()

		self.hStackForTimeStamp.axis = .horizontal
		self.hStackForTimeStamp.alignment = .center
		self.hStackForTimeStamp.distribution = .equalSpacing
	}

	func configureWeatherStateUI() {
		self.weatherStateTextLabel.textAlignment = .right
		self.weatherStateLabel.textAlignment = .left

		self.weatherStateTextLabel.text = DisplayConstants.weatherState.rawValue
		self.weatherStateLabel.text = DisplayConstants.fetching.rawValue

		self.hStackForWeatherState.axis = .horizontal
		self.hStackForWeatherState.alignment = .center
		self.hStackForWeatherState.distribution = .equalSpacing
	}

	func configureTemperatureUI() {
		self.temperatureTextLabel.textAlignment = .right
		self.temperatureLabel.textAlignment = .left

		self.temperatureTextLabel.text = DisplayConstants.temperature.rawValue
		self.temperatureLabel.text = DisplayConstants.fetching.rawValue

		self.hStackForTemperature.axis = .horizontal
		self.hStackForTemperature.alignment = .center
		self.hStackForTemperature.distribution = .equalSpacing
	}

	func configureHumidityUI() {
		self.humidityTextLabel.textAlignment = .right
		self.humidityLabel.textAlignment = .left

		self.humidityTextLabel.text = DisplayConstants.humidity.rawValue
		self.humidityLabel.text = DisplayConstants.fetching.rawValue

		self.hStackForHumidity.axis = .horizontal
		self.hStackForHumidity.alignment = .center
		self.hStackForHumidity.distribution = .equalSpacing
	}

	func configureWindSpeedUI() {
		self.windSpeedTextLabel.textAlignment = .right
		self.windSpeedLabel.textAlignment = .left

		self.windSpeedTextLabel.text = DisplayConstants.windSpeed.rawValue
		self.windSpeedLabel.text = DisplayConstants.fetching.rawValue

		self.hStackForWindSpeed.axis = .horizontal
		self.hStackForWindSpeed.alignment = .center
		self.hStackForWindSpeed.distribution = .equalSpacing
	}

	func configureVStack() {
		self.vStack.axis = .vertical
		self.vStack.alignment = .center
		self.vStack.distribution = .equalSpacing

		// Format all UILabel instances within VStack
		self.vStack.applySubViewChanges(forSubviewType: UILabel.self) { (label) in
			label.textColor = .white
			switch label {
			case self.selectedLocationTitle:
				let fontSize: CGFloat = UIOptions.locationLabelHeight
				label.font = UIFont.boldSystemFont(ofSize: fontSize)
			default:
				let fontSize: CGFloat = UIOptions.normalLabelHeight
				label.font = UIFont.systemFont(ofSize: fontSize)
			}
		}

		self.addSubview(self.vStack)
	}

	func configureSegmentControl() {
		self.segmentControl.backgroundColor = UIColor.segmentBackground

		self.segmentControl.selectedSegmentColor = UIColor.segmentTint

		self.segmentControl.selectedSegmentIndex = 0
		self.segmentControl.setDividerImage(UIImage.segmentSeperator, forLeftSegmentState: .normal,
											rightSegmentState: .normal, barMetrics: .default)

		for idx in (0...self.segmentTitles.count - 1) {
			let segmentTitle = self.segmentTitles[idx]
			self.segmentControl.insertSegment(withTitle: segmentTitle, at: idx, animated: false)
		}

		let segmentFont: UIFont = UIFont.systemFont(ofSize: UIOptions.segmentFontHeight)
		self.segmentControl.setTitleTextAttributes(
			[NSAttributedString.Key.foregroundColor: UIColor.white,
			 NSAttributedString.Key.font: segmentFont], for: .normal)
		self.segmentControl.addTarget(self, action: #selector(locationChanged(_:)), for: .valueChanged)
		self.segmentControl.selectedSegmentIndex = 0
		self.segmentControl.apportionsSegmentWidthsByContent = true
		self.updateSelectedTitle(idx: 0)
	}

    func createConstraints() {
        self.snp.makeConstraints { (v) -> Void in
            v.width.equalToSuperview().multipliedBy(0.96)
			v.height.equalTo(UIOptions.containerHeight)
            v.center.equalToSuperview()
        }

        self.vStack.snp.makeConstraints { (v) -> Void in
			v.leading.equalToSuperview().inset(UIOptions.vStackPadding)
            v.trailing.equalToSuperview().inset(UIOptions.vStackPadding)
            v.top.equalToSuperview().inset(UIOptions.vStackPadding)
            v.bottom.equalToSuperview().inset(UIOptions.vStackPadding)
        }

		self.hStackForTimeStamp.snp.makeConstraints { (v) -> Void in
			v.leading.equalToSuperview().inset(UIOptions.hStackPadding)
			v.trailing.equalToSuperview().inset(UIOptions.hStackPadding)
		}

        self.hStackForTemperature.snp.makeConstraints { (v) -> Void in
            v.leading.equalToSuperview().inset(UIOptions.hStackPadding)
            v.trailing.equalToSuperview().inset(UIOptions.hStackPadding)
        }

		self.hStackForHumidity.snp.makeConstraints { (v) -> Void in
			v.leading.equalToSuperview().inset(UIOptions.hStackPadding)
			v.trailing.equalToSuperview().inset(UIOptions.hStackPadding)
		}

		self.hStackForWindSpeed.snp.makeConstraints { (v) -> Void in
			v.leading.equalToSuperview().inset(UIOptions.hStackPadding)
			v.trailing.equalToSuperview().inset(UIOptions.hStackPadding)
		}

        self.selectedLocationTitle.textAlignment = .center

		self.timeStampTextLabel.snp.makeConstraints { (v) in
			v.trailing.equalTo(self.weatherStateTextLabel.snp.trailing)
			v.trailing.equalTo(self.temperatureTextLabel.snp.trailing)
			v.trailing.equalTo(self.humidityTextLabel.snp.trailing)
			v.trailing.equalTo(self.windSpeedTextLabel.snp.trailing)
		}

        self.timeStampLabel.snp.makeConstraints { (v) in
			v.leading.equalTo(self.weatherStateLabel.snp.leading)
            v.leading.equalTo(self.temperatureLabel.snp.leading)
			v.leading.equalTo(self.humidityLabel.snp.leading)
			v.leading.equalTo(self.windSpeedLabel.snp.leading)
        }
    }

    @objc func locationChanged(_ sender: Any) {
        let segmentControl = sender as! UISegmentedControl
        let idx = segmentControl.selectedSegmentIndex
        self.updateSelectedTitle(idx: idx)
        self.delegate?.segmentSelected(idx: idx)
    }

    func updateSelectedTitle(idx: Int) {
        let title = self.segmentTitles[idx]
        self.selectedLocationTitle.text = title
    }

	func updateUI(temperature: String, timeStamp: String, humidity: String,
				  windSpeed: String, weatherState: String, withAnimation: Bool) {
		if withAnimation {
			// Animate all controls with type = UILabel
			self.vStack.applySubViewChanges(forSubviewType: UILabel.self) { label in
				UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseIn]) {
					label.alpha = 0.1
				} completion: { (_) in
					self.weatherStateLabel.text = weatherState
					self.temperatureLabel.text = temperature
					self.timeStampLabel.text = timeStamp
					self.humidityLabel.text = humidity
					self.windSpeedLabel.text = windSpeed

					UIView.animate(withDuration: 1.0) {
						label.alpha = 1.0
					}
				}
			}
		} else {
			self.weatherStateLabel.text = weatherState
			self.temperatureLabel.text = temperature
			self.timeStampLabel.text = timeStamp
			self.humidityLabel.text = humidity
			self.windSpeedLabel.text = windSpeed
        }
    }
}
