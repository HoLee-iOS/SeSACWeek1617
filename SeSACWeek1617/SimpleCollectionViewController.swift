//
//  SimpleCollectionViewController.swift
//  SeSACWeek1617
//
//  Created by 이현호 on 2022/10/18.
//

import UIKit

struct User: Hashable {
    let id = UUID().uuidString
    let name: String
    let age: Int
}

class SimpleCollectionViewController: UICollectionViewController {

    //var list = ["닭곰탕", "삼계탕", "들기름김", "삼분카레", "콘소메 치킨"]
    
    var list = [
        User(name: "뽀로로", age: 3),
        User(name: "뽀로로", age: 3),
        User(name: "해리포터", age: 33),
        User(name: "도라에몽", age: 5)
    ]
    
    //https://developer.apple.com/documentation/uikit/uicollectionview/cellregistration
    //cellForItemAt 이전에 호출되어야하기 때문에 보통 이런 식으로 전역변수 형태로 만들어서 사용함!
    //cellForItmeAt 전에 생성되어야 함! => register 코드와 유사한 역할
    //만약 따로 cell 파일을 만들어서 사용한다면 UICollectionViewListCell 부분에 해당 셀 파일 넣어주기!
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, User>!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, User>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = createLayout()
        
        //1. Identifier 2. struct
        //register
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell() //cl.defaultContentConfiguration()
            
            content.text = itemIdentifier.name
            content.textProperties.color = .green
            
            content.secondaryText = "\(itemIdentifier.age)살"
            content.prefersSideBySideTextAndSecondaryText = false
            content.textToSecondaryTextVerticalPadding = 20
            
            content.image = itemIdentifier.age < 8 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star")
            content.imageProperties.tintColor = .yellow
            
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColor = .lightGray
            backgroundConfig.cornerRadius = 10
            backgroundConfig.strokeWidth = 2
            backgroundConfig.strokeColor = .systemOrange
            cell.backgroundConfiguration = backgroundConfig
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, User>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        dataSource.apply(snapshot)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item = list[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)

        return cell
    }

}

extension SimpleCollectionViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        //14+ 컬렉션뷰를 테이블뷰 스타일처럼 사용 가능 (List Configuration)
        //컬렉션뷰 스타일 (컬렉션뷰 셀 X)
        var configuration  = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false
        configuration.backgroundColor = .blue
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
}
