//
//  Calander_extension.swift
//  Project
//
//  Created by 张凯强 on 2018/3/15.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import Foundation
import UIKit
extension Calendar {
    ///当月天数
    var currentMonthForDays: Int {
        get{
            let range = self.range(of: Calendar.Component.day, in: Calendar.Component.month, for: Date.init())
            let num = range?.count
            return num ?? 31
        }
    }
    
    
    
    ///获取指定月天数
    func getTargetMonthCountDay(month: Int) -> Int {
        let now = Date.init()
        let calendar = Calendar.current
        var comp = calendar.dateComponents(Set<Calendar.Component>.init([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day,Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]), from: now)
        comp.month = month
        let targetDate = calendar.date(from: comp) ?? now
        let range = self.range(of: Calendar.Component.day, in: Calendar.Component.month, for: targetDate)
        let num = range?.count
        return num ?? 31
    }
    ///计算从现在开始到指定时间间隔之后的时间
    func getTargetTimeWith(day: String, num: Int) -> Date{
        let now = Date.init()
        let calendar = Calendar.current
        var comp = calendar.dateComponents(Set<Calendar.Component>.init([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day,Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]), from: now)
        let currentDay = comp.day ?? 1
        comp.day = currentDay + num
        let targetDate = calendar.date(from: comp)
        return targetDate ?? Date.init()
    }
    ///获取指定日期的date
    func getZhiDingTime(month: Int, day: Int, year: Int = 2018) -> Date {
        let now = Date.init()
        let calendar = Calendar.current
        var comp = calendar.dateComponents(Set<Calendar.Component>.init([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day,Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]), from: now)
        comp.day = day
        comp.year = year
        comp.month = month
        let date = calendar.date(from: comp)
        return date ?? Date.init()
        
    }
    //两个日期的比较1, date1是更远的。-1：date1是past, 0: 两个相等
    func comparDate(date1: Date, date2: Date) -> Int {
        let result = date1.compare(date2)
        if result == .orderedDescending {
            return 1
        }else if (result == .orderedAscending) {
            return -1
        }else {
            return 0
        }
    }
    ///字符串转换成date,指定日期的字符串转换成date
    func theTargetStringConversionDate(str: String) -> Date {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
    
        let date = formatter.date(from: str) ?? Date.init()
        let timeZone = NSTimeZone.system
        let inter = timeZone.secondsFromGMT(for: Date.init())
        let localDate = date.addingTimeInterval(TimeInterval(inter))
        
        return localDate
    }
    ///date对象转换成字符串
    func theTargetDateConversionStr(date: Date) -> String {
        let dateFormat = DateFormatter.init()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDateStr = dateFormat.string(from: date)
        return currentDateStr
    }
    ///获取给定字符串的月份
    func getTargetMonthWithStr(time: String) -> Int {
        let date = self.theTargetStringConversionDate(str: time)
        //获取指定日期的月份
        let month = self.getMonth(date: date)
        return month
    }
    func getTargetDayWithStr(time: String) -> Int {
        let date = self.theTargetStringConversionDate(str: time)
        //获取指定日期的月份
        let month = self.getDay(date: date)
        return month
    }
    
    
    
    func getMonth(date: Date = Date.init()) -> Int {
        let calendar = Calendar.current
        var comp = calendar.dateComponents(Set<Calendar.Component>.init([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day,Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]), from: date)
        let month = comp.month ?? 1
        return month
    }
    func getDay(date: Date = Date.init()) -> Int {
        let calendar = Calendar.current
        var comp = calendar.dateComponents(Set<Calendar.Component>.init([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day,Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]), from: date)
        let day = comp.day ?? 1
        return day
    }
    func getyear(date: Date = Date.init()) -> Int {
        let calendar = Calendar.current
        var comp = calendar.dateComponents(Set<Calendar.Component>.init([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day,Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]), from: date)
        let year = comp.year ?? 2018
        return year
    }
    
    func getDifferenceByDate(oldTime: String, newTime: String) -> Int {
        
        let calander = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let old = calander.theTargetStringConversionDate(str: oldTime + " 00:00:00")
        let new = calander.theTargetStringConversionDate(str: newTime + " 01:00:00")
        mylog(old)
        mylog(new)
        let comp = calander.dateComponents(Set<Calendar.Component>.init([Calendar.Component.day]), from: old, to: new)
        
        
        return comp.day ?? 15
        
    }
    
    
    
    func configStart() -> String {
        let currentMonth = self.getMonth()
        ///首先看看从现在开始推迟7天后有没有超过16号
        let zhidingDate = self.getZhiDingTime(month: currentMonth, day: 16)
        ///退职七天之后的日期
        let targetDate = self.getTargetTimeWith(day: "", num: 7)
        var selectMonth = currentMonth
        var selectDay = 1
        let result = self.comparDate(date1: zhidingDate, date2: targetDate)
        if (result == -1) || (result == 0) {
            //开始时间移动到下一个月
            let targetMonth = currentMonth + 1
            selectMonth = targetMonth
            selectDay = 1
        }else {
            selectDay = 16
        }
        let month: String = String.init(format: "%02d", selectMonth)
        let day: String = String.init(format: "%02d", selectDay)
        return "2018-\(month)-\(day)"
    }
    
    
    func configEnd(startTime: String) -> [String: String] {
        var startMonth = self.getTargetMonthWithStr(time: startTime + " 00:00:00")
        var startDay = self.getTargetDayWithStr(time: startTime + " 00:00:00")
        var endDay: Int = 15
        if startDay == 1 {
            //是从该月的第一天开始的。
            
        }else {
            endDay = self.getTargetMonthCountDay(month:startMonth)
            
        }
        let month: String = String.init(format: "%02d", startMonth)
        let day: String = String.init(format: "%02d", endDay)
        let endTime: String = "2018-\(month)-\(day)"
        
        let dayCount = self.getDifferenceByDate(oldTime: startTime, newTime: endTime) + 1
        let dayCountStr = String.init(format: "%d", dayCount)
        
        
        return ["endTime": endTime, "dayCount": dayCountStr]
        
    }
    
    
    
   
    
}
