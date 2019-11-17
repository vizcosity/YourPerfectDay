//
//  LogViewController.swift
//  Benson
//
//  Created by Aaron Baw on 27/08/2019.
//  Copyright © 2019 Ventr. All rights reserved.
//

import UIKit

class LogViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
        
    var logs: [MetricLog] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! { didSet {
        self.collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        } }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MetricLogCell", for: indexPath) as! CheckinCollectionViewCell
                
        cell.metricLog = MetricLog(metrics: [MetricAttribute(name: "Mood", value: 3), MetricAttribute(name: "Focus", value: 2)], timeSince: "2 mins ago")
        
        return cell
    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        
        print("CollectionView width: \(collectionView.layer.bounds.width)")
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    }
    
    //
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let cell = collectionView.cellForItem(at: indexPath)
//
//        return CGSize(width: collectionView.layer.bounds.width, height: cell!.frame.height)
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
