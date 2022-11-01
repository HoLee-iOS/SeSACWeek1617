//
//  NewsViewModel.swift
//  SeSACWeek1617
//
//  Created by 이현호 on 2022/10/20.
//

import Foundation
import RxSwift
import RxCocoa

class NewsViewModel {
    
    //var pageNumber = BehaviorSubject(value: "3000")
    var pageNumber = BehaviorRelay(value: "3000")
    
    //var list = BehaviorSubject(value: News.items)
    var list = BehaviorRelay(value: News.items)
    
    func changeFormatPageNumber(text: String) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal //1,234의 형태
        let text = text.replacingOccurrences(of: ",", with: "")
        guard let number = Int(text) else { return } //처음에 ,가 들어간 형태로 변경이 되면 ,가 들어갔기 때문에 Int로 형변환이 불가해지기 때문에 Return 되버림!
        let result = numberFormatter.string(for: number)!
        pageNumber.accept(result)
    }
    
    func loadSample() {
        //list.onNext(News.items)
        list.accept(News.items)
    }
    
    func resetSample() {
        list.accept([])
    }
    
}
