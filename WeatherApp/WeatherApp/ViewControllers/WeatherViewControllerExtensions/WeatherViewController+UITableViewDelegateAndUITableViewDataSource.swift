import Foundation
import UIKit

//MARK: - Extension - UITableViewDelegate, UITableVieDataSource 

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - TableView Functions
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomHeaderTableViewCell") as? CustomHeaderTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(with: hourlyModels)
        tableViewHeaderHeight = cell.collectionViewHeightConstraint.constant
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.view.frame.size.height/5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dailyModels.count == 0 {
            return 0
        } else {
            return dailyModels.count + 7
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < dailyModels.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as? WeatherTableViewCell else {
                return UITableViewCell()
            }
            cell.configureCell(with: dailyModels[indexPath.row])
            return cell
        } else if indexPath.row < dailyModels.count + 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodayForecastTableViewCell", for: indexPath) as? TodayForecastTableViewCell else {
                return UITableViewCell()
            }
            cell.showTodayDescription(from: cityWeatherDescription)
            return cell
        } else if indexPath.row < dailyModels.count + 6 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodayForecastInfoTableViewCell", for: indexPath) as? TodayForecastInfoTableViewCell else {
                return UITableViewCell()
            }
            cell.configureCell(with: cityWeatherDescription, at: indexPath.row - (dailyModels.count + 1))
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LastTableViewCell", for: indexPath) as? LastTableViewCell else {
                return UITableViewCell()
            }
            cell.configureCell(with: cityWeatherDescription)
            if let currentLocation = currentLocation {
                cell.getCurrentLocation(from: currentLocation)
            }
            return cell
        }
    }
    
    //MARK: - ScrollView Functions
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let y: CGFloat = scrollView.contentOffset.y
        let newHeaderHeight: CGFloat = currentWeatherDescriptionViewHeightConstraint.constant - y
        
        for cell in self.tableView.visibleCells {
            var paddingToDissapear:CGFloat = 0
            
            if let headerHight = tableViewHeaderHeight {
                paddingToDissapear = headerHight
            }
            
            let hiddenFrameHeight = y + paddingToDissapear - cell.frame.origin.y
            if (hiddenFrameHeight >= 0 || hiddenFrameHeight <= cell.frame.size.height) {
                if let customCell = cell as? WeatherTableViewCell {
                    customCell.maskCell(fromTop: hiddenFrameHeight)
                }
                if let customCell = cell as? TodayForecastTableViewCell {
                    customCell.maskCell(fromTop: hiddenFrameHeight)
                }
                if let customCell = cell as? TodayForecastInfoTableViewCell {
                    customCell.maskCell(fromTop: hiddenFrameHeight)
                }
                if let customCell = cell as? LastTableViewCell {
                    customCell.maskCell(fromTop: hiddenFrameHeight)
                }
            }
        }
        
        let currentVelocityY = scrollView.panGestureRecognizer.velocity(in: scrollView.superview).y
        let currentVelocityYSign = Int(currentVelocityY).signum()

        if currentVelocityYSign != lastVelocityYSign && currentVelocityYSign != 0 {
            lastVelocityYSign = currentVelocityYSign
        }

        if newHeaderHeight > headerViewMaxHeight {
            currentWeatherDescriptionViewHeightConstraint.constant = headerViewMaxHeight
        } else if newHeaderHeight < headerViewMinHeight {
            currentWeatherDescriptionViewHeightConstraint.constant = headerViewMinHeight
        } else {
            currentWeatherDescriptionViewHeightConstraint.constant = newHeaderHeight
            if let cityNameLabelY = cityNameLabelY {
                cityNameLabelYConstraint?.constant = cityNameLabelY*percent(from: newHeaderHeight, percantageValue: headerViewMaxHeight)
            }
            changeLabelsAlpha(with: newHeaderHeight)
            scrollView.contentOffset.y = 0
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if lastVelocityYSign < 0 {
            moveTableViewUp()
        } else if lastVelocityYSign > 0 {
            if currentWeatherDescriptionViewHeightConstraint.constant - scrollView.contentOffset.y < headerViewMaxHeight {
                moveTableViewUp()
            }
        }
    }
    
    //MARK: - Flow Functions
    
    func changeLabelsAlpha(with newHeaderHeight: CGFloat) {
        minAndMaxTemperatureForTodayLabel.alpha = percentAlpha(from: minAndMaxTemperatureForTodayLabelLowerPoint, percantageValue: newHeaderHeight - minAndMaxTemperatureForTodayLabelLowerPoint)
        currentTemperatureLabel.alpha = percentAlpha(from: currentTemperatureLabelLowerPoint, percantageValue: newHeaderHeight - currentTemperatureLabelLowerPoint)
        degreeKindLabel.alpha = percentAlpha(from: degreeKindLabelLowerPoint, percantageValue: newHeaderHeight - degreeKindLabelLowerPoint)
        plusMinusTemperatureLabel.alpha = percentAlpha(from: plusMinusTemperatureLabelLowerPoint, percantageValue: newHeaderHeight - plusMinusTemperatureLabelLowerPoint)
    }
    
    func percentAlpha(from value: CGFloat, percantageValue: CGFloat) -> CGFloat {
        let valueToReturn = (value*percantageValue)/10000
        if valueToReturn < 0 {
            return 0
        } else if valueToReturn > 1 {
            return 1
        } else {
            return valueToReturn
        }
    }
    
    func percent(from value: CGFloat, percantageValue: CGFloat) -> CGFloat {
        return value/percantageValue
    }
    
    func moveTableViewUp() {
        if minAndMaxTemperatureForTodayLabel.alpha < 0.2 {
            animateActionWith(duration: 0.2)
        } else {
            animateActionWith(duration: 1)
        }
    }
    
    func animateActionWith(duration: Double) {
        if let cityNameLabelY = cityNameLabelY {
            cityNameLabelYConstraint?.constant = cityNameLabelY*percent(from: headerViewMinHeight, percantageValue: headerViewMaxHeight)
        }
        currentWeatherDescriptionViewHeightConstraint.constant = headerViewMinHeight
        UIView.animate(withDuration: duration) {
            self.changeLabelsAlpha(with: self.headerViewMinHeight)
            self.view.layoutIfNeeded()
        }
    }
    
}
