//
//  SubjectViewController.swift
//  SeSACWeek1617
//
//  Created by 이현호 on 2022/10/25.
//

import UIKit
import RxSwift
import RxCocoa

class SubjectViewController: UIViewController {

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newButton: UIBarButtonItem!
    
    let publish = PublishSubject<Int>() //초기값이 없는 빈 상태
    let behavior = BehaviorSubject(value: 100) //초기값 필수, value의 타입으로 타입추론
    let replay = ReplaySubject<Int>.create(bufferSize: 3) //bufferSize에 작성된 숫자만큼 메모리에서 이벤트를 가지고 있다가 subscribe 직후 한 번에 이벤트를 방출
    let async = AsyncSubject<Int>()
    
    let disposeBag = DisposeBag()
    let viewModel = SubjectViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
        
        
        let input = SubjectViewModel.Input(addTap: addButton.rx.tap, resetTap: resetButton.rx.tap, newTap: newButton.rx.tap, searchText: searchBar.rx.text)
        let output = viewModel.transform(input: input)
        
        
        
        output.list
            .drive(tableView.rx.items(cellIdentifier: "ContactCell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element.name): \(element.age)세 (\(element.number))"
            }
            .disposed(by: disposeBag)
        
//        viewModel.list //VM -> VC 데이터 전달 (Output)
//            .asDriver(onErrorJustReturn: [])
//            .drive(tableView.rx.items(cellIdentifier: "ContactCell", cellType: UITableViewCell.self)) { (row, element, cell) in
//                cell.textLabel?.text = "\(element.name): \(element.age)세 (\(element.number))"
//            }
//            .disposed(by: disposeBag)
        
        
        
        output.addTap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.fetchData()
            }
            .disposed(by: disposeBag)
        
        //tap 했을 경우 기능 구현을 하고 싶다면 subscribe 사용
//        addButton.rx.tap //VC -> VM (Input)
//            .withUnretained(self)
//            .subscribe { (vc, _) in
//                vc.viewModel.fetchData()
//            }
//            .disposed(by: disposeBag)
        
        
        
        output.resetTap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.resetData()
            }
            .disposed(by: disposeBag)
        
//        resetButton.rx.tap //VC -> VM (Input)
//            .withUnretained(self)
//            .subscribe { (vc, _) in
//                vc.viewModel.resetData()
//            }
//            .disposed(by: disposeBag)
        
        
        
        output.newTap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.newData()
            }
            .disposed(by: disposeBag)
        
//        newButton.rx.tap //VC -> VM (Input)
//            .withUnretained(self)
//            .subscribe { (vc, _) in
//                vc.viewModel.newData()
//            }
//            .disposed(by: disposeBag)
        
        
        
        output.searchText
            .withUnretained(self)
            .subscribe { (vc, value) in
                print("=====\(value)")
                vc.viewModel.filterData(query: value)
            }
            .disposed(by: disposeBag)
        
        //서치바 때문에 초기값이 없다가 생김
//        searchBar.rx.text  //VC -> VM (Input)
//            .orEmpty
//            .distinctUntilChanged() //같은 값을 받지 않음
//            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance) //wait
//            .withUnretained(self)
//            .subscribe { (vc, value) in
//                print("=====\(value)")
//                vc.viewModel.filterData(query: value)
//            }
//            .disposed(by: disposeBag)
    }
    
}

extension SubjectViewController {
    func asyncSubject() {
//        async.onNext(100)
//        async.onNext(200)
//        async.onNext(300)
//        async.onNext(400)
//        async.onNext(500)
//
//        //observable
//        async
//            .subscribe { value in
//                print("async - \(value)")
//            } onError: { error in
//                print("async - \(error)")
//            } onCompleted: {
//                print("async completed")
//            } onDisposed: {
//                print("async disposed")
//            }
//            .disposed(by: disposeBag)
//
//        //observer
//        async.onNext(3)
//        async.onNext(4)
//        async.on(.next(5)) //onNext와 동일!
//
//        async.onCompleted()
//
//        //subscribe한 observable의 시퀀스가 onCompleted 되었기 때문에 실행되지 않음!
//        async.onNext(6)
//        async.onNext(7)
    }
    
    func replaySubject() {
        //bufferSize에 작성된 수 만큼 구독 전 발생한 이벤트들을 emit함
        //만약 bufferSize 수 만큼 구독 전 이벤트가 없다면 실행 자체가 되지 않음!
        
        replay.onNext(100)
        replay.onNext(200)
        replay.onNext(300)
        replay.onNext(400)
        replay.onNext(500)
        
        //observable
        replay
            .subscribe { value in
                print("replay - \(value)")
            } onError: { error in
                print("replay - \(error)")
            } onCompleted: {
                print("replay completed")
            } onDisposed: {
                print("replay disposed")
            }
            .disposed(by: disposeBag)

        //observer
        replay.onNext(3)
        replay.onNext(4)
        replay.on(.next(5)) //onNext와 동일!
        
        replay.onCompleted()
        
        //subscribe한 observable의 시퀀스가 onCompleted 되었기 때문에 실행되지 않음!
        replay.onNext(6)
        replay.onNext(7)
    }
    
    func behaviorSubject() {
        //구독 전에 가장 최근 값을 같이 emit
        
        behavior.onNext(1)
        behavior.onNext(2)
        
        //observable
        behavior
            .subscribe { value in
                print("behavior - \(value)")
            } onError: { error in
                print("behavior - \(error)")
            } onCompleted: {
                print("behavior completed")
            } onDisposed: {
                print("behavior disposed")
            }
            .disposed(by: disposeBag)

        //observer
        behavior.onNext(3)
        behavior.onNext(4)
        behavior.on(.next(5)) //onNext와 동일!
        
        behavior.onCompleted()
        
        //subscribe한 observable의 시퀀스가 onCompleted 되었기 때문에 실행되지 않음!
        behavior.onNext(6)
        behavior.onNext(7)
    }
    
    func publishSubject() {
        //초기값이 없는 빈 상태
        //subscribe 전/error/completed notification 이후 이벤트 무시
        //subscribe 후에 대한 이벤트는 다 처리함!
        
        //subscribe를 하기 이전의 코드이므로 실행되지 않음!
        //ex) 유튜브에서 채널을 구독하지 않으면 새로운 영상이 올라왔는지 알 수 없음!
        publish.onNext(1)
        publish.onNext(2)
        
        //observable
        publish
            .subscribe { value in
                print("publish - \(value)")
            } onError: { error in
                print("publish - \(error)")
            } onCompleted: {
                print("publish completed")
            } onDisposed: {
                print("publish disposed")
            }
            .disposed(by: disposeBag)

        //observer
        publish.onNext(3)
        publish.onNext(4)
        publish.on(.next(5)) //onNext와 동일!
        
        publish.onCompleted()
        
        //subscribe한 observable의 시퀀스가 onCompleted 되었기 때문에 실행되지 않음!
        publish.onNext(6)
        publish.onNext(7)
    }
}
