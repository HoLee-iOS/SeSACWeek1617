//
//  SubjectViewModel.swift
//  SeSACWeek1617
//
//  Created by 이현호 on 2022/10/25.
//

import Foundation
import RxSwift
import RxCocoa

//associated type == generic
//뷰모델에서 인풋 아웃풋 사용은 똑같지만 내부의 구성요소가 다 다르기 때문에
//어떤 타입인지 명확하게 정의하기가 힘들기 때문에
//associated type 사용!
protocol CommonViewModel {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
    
}

struct Contact {
    var name: String
    var age: Int
    var number: String
}

class SubjectViewModel: CommonViewModel {
    
    var contactData = [
        Contact(name: "Jack", age: 21, number: "01012341234"),
        Contact(name: "Real", age: 22, number: "01012343211"),
        Contact(name: "Hue", age: 23, number: "01012349098"),
    ]
    
    var list = PublishSubject<[Contact]>()
    
    func fetchData() {
        list.onNext(contactData)
    }
    
    func resetData() {
        list.onNext([])
    }
    
    func newData() {
        let new = Contact(name: "고래밥", age: Int.random(in: 10...50), number: "01012212121")
        contactData.append(new)
        
        list.onNext(contactData)
    }
    
    func filterData(query: String) {
        
        let result = query != "" ? contactData.filter{$0.name.lowercased().contains(query)} : contactData
        list.onNext(result)
                
    }
    
    struct Input {
        let addTap: ControlEvent<Void>
        let resetTap: ControlEvent<Void>
        let newTap: ControlEvent<Void>
        let searchText: ControlProperty<String?>
    }
    
    struct Output {
        let addTap: ControlEvent<Void>
        let resetTap: ControlEvent<Void>
        let newTap: ControlEvent<Void>
        let list: Driver<[Contact]>
        let searchText: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        let list = list.asDriver(onErrorJustReturn: [])
        
        let text = input.searchText
            .orEmpty
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance) //wait
            .distinctUntilChanged() //같은 값을 받지 않음
        
        return Output(addTap: input.addTap, resetTap: input.resetTap, newTap: input.newTap, list: list, searchText: text)
    }
    
}
