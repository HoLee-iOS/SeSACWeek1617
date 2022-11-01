//
//  SubscribeViewController.swift
//  SeSACWeek1617
//
//  Created by 이현호 on 2022/10/26.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import RxDataSources

class SubscribeViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>(configureCell: { dataSource, tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = "\(item)"
        return cell
    })
    
    func testRxDataSource() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }
        
        Observable.just([
            SectionModel(model: "안농", items: [1, 2, 3]),
            SectionModel(model: "슈웃", items: [4, 5, 6]),
            SectionModel(model: "두둥", items: [7, 8, 9])
        ])
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func testRxAlamofire() {
        //Success Error => <Single>
        //성공하거나 실패하는 네트워크 통신에서 많이 쓰임
        let url = APIKey.searchURL + "apple"
        request(.get, url, headers: ["Authorization" : APIKey.authorization])
            .data()
            .decode(type: SearchPhoto.self, decoder: JSONDecoder())
            .subscribe(onNext: { value in
                print(value.results[0].likes)
            })
            .disposed(by: disposeBag)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        testRxDataSource()
        
        testRxAlamofire()
    
        
        Observable.of(1,2,3,4,5,6,7,8,9,10)
            .skip(3) //앞에서부터 3개 무시 후 4부터 실행
            .filter { $0 % 2 == 0 } //4, 6, 8, 10
            .map{ $0 * 2 }
            .subscribe { value in
                
            }
            .disposed(by: disposeBag)
        
        
        //탭 > 레이블: "안녕 반가워"
        
        //1.
        let sample = button.rx.tap
        
        sample
            .subscribe { [weak self] _ in
                self?.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        //2.
        button.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                DispatchQueue.main.async {
                    vc.label.text = "안녕 반가워"
                }
            }
            .disposed(by: disposeBag)
        
        //3. 네트워크 통신이나 파일 다운로드 등 백그라운드 작업?
        button.rx.tap
            .observe(on: MainScheduler.instance) //어떤 쓰레드로 동작하게 해줄지 지정
            .withUnretained(self)
            .subscribe { vc, value in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        //4. bind: subscribe, mainScheduler, error X
        button.rx.tap
            .withUnretained(self)
            .bind { vc, value in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        //5. operator로 데이터의 stream 조작
        button
            .rx
            .tap
            //.debug() //print와 같음
            .map{ "안녕 반가워" }
            //.debug() //위와 결과가 다름
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        //6. driver traits: bind + stream 공유(리소스 낭비 방지, share())
        button.rx.tap
            .map{ "안녕 반가워" }
            .asDriver(onErrorJustReturn: "에러")
            .drive(label.rx.text)
            .disposed(by: disposeBag)
        
    }
    
}
