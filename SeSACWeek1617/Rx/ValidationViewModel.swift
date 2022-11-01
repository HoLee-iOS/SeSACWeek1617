//
//  ValidationViewModel.swift
//  SeSACWeek1617
//
//  Created by 이현호 on 2022/10/27.
//

import Foundation
import RxSwift
import RxCocoa

class ValidationViewModel {
    
    let validText = BehaviorRelay(value: "닉네임은 최소 8자 이상 필요해요")
    
    struct Input {
        let text: ControlProperty<String?> //nameTextField.rx.text
        let tap: ControlEvent<Void> //stepButton.rx.tap
    }
    
    struct Output {
        let validation: Observable<Bool>
        let tap: ControlEvent<Void> //연산관계가 없기 때문에 인풋과 동일함
        let text: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let valid = input.text
            .orEmpty
            .map { $0.count >= 8 }
            .share()
        
        let text = validText.asDriver()
        
        return Output(validation: valid, tap: input.tap, text: text)
    }
    
}
