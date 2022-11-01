//
//  ValidationViewController.swift
//  SeSACWeek1617
//
//  Created by 이현호 on 2022/10/27.
//

import UIKit
import RxSwift
import RxCocoa

class ValidationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var stepButton: UIButton!
    
    let disposeBag = DisposeBag()
    let viewModel = ValidationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        observableVSSubject()
    }

    func bind() {
        
        //After
        let input = ValidationViewModel.Input(text: nameTextField.rx.text, tap: stepButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        //딱 subscribe 할 수 있는 객체만 남겨둠
        output.text
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.validText //VM -> VC (Output)
            .asDriver()
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        
        output.validation
            .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        let validation = nameTextField.rx.text //VC -> VM (Input)
            .orEmpty
            .map { $0.count >= 8 }
            .share() //Subject, Relay는 내부적으로 구현되어 있음

        validation
            .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        
        
        output.validation
            .withUnretained(self)
            .bind { (vc, value) in
                let color: UIColor = value ? .systemPink : .lightGray
                vc.stepButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        validation
            .withUnretained(self)
            .bind { (vc, value) in
                let color: UIColor = value ? .systemPink : .lightGray
                vc.stepButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        
        
        output.tap
            .bind { _ in
                print("next")
            }
            .disposed(by: disposeBag)
        
        stepButton.rx.tap //VC -> VM (Input)
            .bind { _ in
                print("next")
            }
            .disposed(by: disposeBag)
        
        
        
        //Before
        
        

        

        
        
        
        
        //Stream == Sequence
        
        //?? dispose 리소스 정리

    }
    
    func observableVSSubject() {
        
        let testA = stepButton.rx.tap
            .map { "안녕하세요" }
            .asDriver(onErrorJustReturn: "")
//            .share()
        
        testA
            .drive(validationLabel.rx.text)
//            .bind(to: validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        testA
            .drive(nameTextField.rx.text)
//            .bind(to: nameTextField.rx.text)
            .disposed(by: disposeBag)
        
        testA
            .drive(stepButton.rx.title())
//            .bind(to: stepButton.rx.title())
            .disposed(by: disposeBag)
        
        //just of from
        let sampleInt = Observable<Int>.create { observer in
            observer.onNext(Int.random(in: 1...100))
            return Disposables.create()
        }
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        
        let subjectInt = BehaviorSubject(value: 0)
        subjectInt.onNext(Int.random(in: 1...100))
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
    }
}
