//
//  NewsViewModel.swift
//  SeSACWeek1617
//
//  Created by 이현호 on 2022/10/20.
//

import Foundation

class NewsViewModel {
    
    var pageNumber: CObservable<String> = CObservable("3000")
    
    var sample: CObservable<[News.NewsItem]> = CObservable(News.items)
    
    func changeFormatPageNumber(text: String) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal //1,234의 형태
        let text = text.replacingOccurrences(of: ",", with: "")
        guard let number = Int(text) else { return } //처음에 ,가 들어간 형태로 변경이 되면 ,가 들어갔기 때문에 Int로 형변환이 불가해지기 때문에 Return 되버림!
        let result = numberFormatter.string(for: number)!
        pageNumber.value = result
    }
    
    func resetSample() {
        sample.value = []
    }
    
    func loadSample() {
        sample.value = News.items
    }
    
}
