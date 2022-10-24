//
//  RxCocoaExampleViewController.swift
//  SeSACWeek1617
//
//  Created by 이현호 on 2022/10/24.
//

import UIKit
import RxCocoa
import RxSwift

class RxCocoaExampleViewController: UIViewController {

    @IBOutlet weak var simpleTableView: UITableView!
    @IBOutlet weak var simplePickerView: UIPickerView!
    @IBOutlet weak var simpleLabel: UILabel!
    @IBOutlet weak var simpleSwitch: UISwitch!
    
    @IBOutlet weak var signName: UITextField!
    @IBOutlet weak var signEmail: UITextField!
    @IBOutlet weak var signButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        setPickerView()
        setSwitch()
        setSign()
        setOperator()
    }
    
    func setOperator() {
        
        let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
        let itemsB = [2.3, 2.0, 1.3]
        
        Observable.just(itemsA)
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just - \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.of(itemsA)
            .subscribe { value in
                print("of - \(value)")
            } onError: { error in
                print("of - \(error)")
            } onCompleted: {
                print("of completed")
            } onDisposed: {
                print("of disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.from(itemsA)
            .subscribe { value in
                print("from - \(value)")
            } onError: { error in
                print("from - \(error)")
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.repeatElement("Jack")
            .take(5)
            .subscribe { value in
                print("repeat - \(value)")
            } onError: { error in
                print("repeat - \(error)")
            } onCompleted: {
                print("repeat completed")
            } onDisposed: {
                print("repeat disposed")
            }
            .disposed(by: disposeBag)
        
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("interval - \(value)")
            } onError: { error in
                print("interval - \(error)")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
            .disposed(by: disposeBag)

    }
    
    func setSign() {
        //ex. 텍1(Observable), 텍2(Observable) -> 레이블(Observer, bind)
        //등록된 개체 중 하나만 변경되어도 실행됨!
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) { value1, value2 in
            return "name은 \(value1), 이메일은 \(value2)입니다"
        }
        .bind(to: simpleLabel.rx.text)
        .disposed(by: disposeBag)
        
        //아래와 같이 타입은 subscribe 전까지 계속 변경 가능!
        signName //UITextField
            .rx //Reactive
            .text //String?
            .orEmpty //String
            .map { $0.count } //Int
            .map { $0 < 2 || $0 > 10 } //Bool
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        signEmail.rx.text.orEmpty
            .map { $0.count > 12 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signButton.rx.tap
//            .bind(to: simpleLabel.rx.text)
        //화면 띄워주기와 같은 액션은 subscribe로 사용함
            .subscribe { _ in
                self.showAlert()
            }
            .disposed(by: disposeBag)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "하하하", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    func setSwitch() {
        Observable.of(false) //just? of?
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
    
    func setTableView() {
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        //item 생성
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])

        //cellForRowAt과 비슷한 느낌
        items
        .bind(to: simpleTableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)
        
        //item은 indexPath, model은 Data
        //항상 마지막에 disposed 필수!
        //next 이외에 다른 케이스 사용이 되지 않는다면 아래와 같이 .bind로 사용!
        //didSelectRowAt과 비슷함!
        simpleTableView.rx.modelSelected(String.self)
            .map { data in
                "\(data)를 클릭했습니다." //최종적으로 들어갈 형태는 map과 같이 변환하겠음!
            }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setPickerView() {
        let items = Observable.just([
                "영화",
                "애니메이션",
                "드라마",
                "기타"
            ])
     
        items
            .bind(to: simplePickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
        
        simplePickerView.rx.modelSelected(String.self)
        //아래와 같이 subscribe만 사용하는 것과 bind와 같음!
        //받아온 정보에 대해서 타입이 맞지 않으므로 아래와 같이 map을 사용해서 계속 변화를 줌
            .map { $0.first }
            .bind(to: simpleLabel.rx.text)
//            .subscribe { value in
//                print(value)
//            }
            .disposed(by: disposeBag)
    }

}
