//
//  NewsViewController.swift
//  SeSACWeek1617
//
//  Created by 이현호 on 2022/10/20.
//

import UIKit
import RxSwift
import RxCocoa

class NewsViewController: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!
    
    //1. 뷰모델 클래스 인스턴스 가져오기
    var viewModel = NewsViewModel()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, News.NewsItem>!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierachy()
        configureDataSource()
        bindData()
    }
    
    func bindData() {
        //2. 뷰모델이 가지고 있는 데이터를 뷰컨에서 쓸 수 있게 넘겨줌
        //value가 변경될 때 마다 실행! 뷰디드로드에 있지만 뷰디드로드 시점에만 실행되지 않고 실시간으로 값이 변할때마다 실행됨!
        numberTextField.rx.text.orEmpty
            .withUnretained(self)
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .bind { (vc, value) in
            vc.viewModel.changeFormatPageNumber(text: value)
            }
            .disposed(by: disposeBag)
        
        loadButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.loadSample()
            }
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.resetSample()
            }
            .disposed(by: disposeBag)
        
        viewModel.pageNumber
            .withUnretained(self)
            .bind { (vc, value) in
                vc.numberTextField.text = value
            }
            .disposed(by: disposeBag)
        
        viewModel.list
            .withUnretained(self)
            .bind { (vc, items) in
            var snapshot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
            snapshot.appendSections([0])
            snapshot.appendItems(items) //itemIdentifier에 들어감!
            vc.dataSource.apply(snapshot, animatingDifferences: true)
            }
            .disposed(by: disposeBag)
    }
}

extension NewsViewController {
    
    func configureHierachy() { //addSubview, init, snapkit
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .lightGray
    }
    
    func configureDataSource() {
        //cellForRowAt과 같이 각 셀마다 실행되기 때문에 itemIdentifier가 배열을 각각의 원소 형태로 보여줄 수 있음
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, News.NewsItem> { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            content.secondaryText = itemIdentifier.body
            
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
}
