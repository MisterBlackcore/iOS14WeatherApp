import UIKit

class CustomHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var hourlyModels:[HourlyWeatherModel] = []
    
    //MARK: - Main Functions
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        collectionView.layoutIfNeeded()
        addSubview(SeparatorManager.shared.setSeparatorLineFor(style: 1, width: bounds.size.width))
    }
    
    //MARK: - Flow Functions
    
    func configureCell(with model: [HourlyWeatherModel]) {
        hourlyModels = model
        collectionView.reloadData()
    }
    
}

//MARK: - Extension - UICollectionViewDelegate, UICollectionViewDataSource

extension CustomHeaderTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - CollectionView Functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hourlyModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: hourlyModels[indexPath.row], index: indexPath.row)
        return cell
    }
    
}
