//
//  GetCode.swift
//  Exp_AST_Converter
//
//  Created by pook on 1/5/20.
//  Copyright © 2020 pookjw. All rights reserved.
//

import Foundation

func showDigraph(_ exp: String) -> String{
    if exp == ""{
        return ""
    }
    
    var exp_arr = exp.components(separatedBy: " ")
    var parentheses_opened: [Int] {
        var result: [Int] = []
        for a in 0..<exp_arr.count{
            if exp_arr[a] == "("{
                result.append(a)
            }
        }
        return result
    }
    var parentheses_closed: [Int] {
        var result: [Int] = []
        for a in 0..<exp_arr.count{
            if exp_arr[a] == ")"{
                result.append(a)
            }
        }
        return result
    }
    var first_index: Int {
        parentheses_opened.last!
    }
    var last_index: Int {
        for a in parentheses_closed {
            if a > first_index {
                return a
            }
        }
        print("Index Error!")
        return -1
    }
    var result = "digraph graphname {\n"
    var dictionary: [String] = [exp]
    var count = 0
    var temp_1: Int?
    var temp_2: Int?
    var temp_3: Int?
    var temp_4: Int?
    
    //
    
    func add_cal_result(dictionary: [String], text: inout String, count: inout Int) {
        //print(count)
        //text += "\(count)\n"
        text += "   \"\(dictionary[count])\" -> \"\(dictionary[count+1])\";\n"
        text += "   \"\(dictionary[count+1])\" -> \"\(dictionary[count+2])\";\n"
        text += "   \"\(dictionary[count+2])\" -> \"\(dictionary[count+3])\";\n"
        text += "   \"\(dictionary[count])\" -> \"\(dictionary[count])\";\n"
        count += 3
    }
    
    func add_par1_result(dictionary: [String], text: inout String, count: inout Int) {
        //print(count)
        //text += "\(count)\n"
        text += "   \"\(dictionary[count])\" -> \"\(dictionary[count+1])\";\n"
        count += 1
    }
    
    func add_par2_result(dictionary: [String], text: inout String, count: inout Int, temp: Int) {
        //print(count)
        //text += "\(count)\n"
        text += "   \"\(dictionary[temp])\" -> \"\(dictionary[count+1])\";\n"
        count += 1
    }
    
    func add_par3_result(dictionary: [String], text: inout String, count: inout Int) {
        //print(count)
        //text += "\(count)\n"
        text += "   \"\(dictionary[count-1])\" -> \"\(dictionary[count])\";\n"
    }
    
    //
    
    func calculate(arr: [String], dictionary: inout [String], text: inout String, count: inout Int) -> Int{
        var arr = arr
        var left_index: Int?
        var right_index: Int?
        var left: String {
            arr[left_index!]
        }
        var right: String {
            arr[right_index!]
        }
        var temp_4: Int?
        
        var temp_5: String?
        
        for opr in [["*", "/"], ["+", "-"]]{
            while arr.contains(opr[0]) || arr.contains(opr[1]){
                if !arr.contains(opr[0]){
                    temp_5 = opr[1]
                } else if !arr.contains(opr[1]){
                    temp_5 = opr[0]
                } else {
                    if arr.firstIndex(of: opr[0])! < arr.firstIndex(of: opr[1])! {
                        temp_5 = opr[0]
                    } else {
                        temp_5 = opr[1]
                    }
                }
                
                left_index = arr.firstIndex(of: temp_5!)! - 1
                right_index = arr.firstIndex(of: temp_5!)! + 1
                
                dictionary.append(left + " " + temp_5! + " " + right)
                
                if temp_5! == "*"{
                    temp_4 = Int(arr[left_index!])! * Int(arr[right_index!])!
                }else if temp_5! == "/"{
                    temp_4 = Int(arr[left_index!])! / Int(arr[right_index!])!
                    
                }else if temp_5! == "+"{
                    temp_4 = Int(arr[left_index!])! + Int(arr[right_index!])!
                    
                }else if temp_5! == "-"{
                    temp_4 = Int(arr[left_index!])! - Int(arr[right_index!])!
                }
                
                dictionary.append(String(temp_4!))
                
                arr.remove(at: left_index!)
                arr.remove(at: left_index!)
                arr.remove(at: left_index!)
                arr.insert(String(temp_4!), at: left_index!)
                
                dictionary.append(arr.joined(separator: " "))
                
                add_cal_result(dictionary: dictionary, text: &text, count: &count)
                //add_result()
            }
        }
        return Int(arr.first!)!
        /*
         print("Got: \(arr)")
         return 3*/
    }
    
    //
    
    //find_parentheses(arr: exp_arr, opened: &parentheses_opened, closed: &parentheses_closed)
    
    while !parentheses_opened.isEmpty{
        temp_4 = count
        
        dictionary.append(Array(exp_arr[first_index...last_index]).joined(separator: " "))
        add_par1_result(dictionary: dictionary, text: &result, count: &count)
        
        temp_1 = calculate(arr: Array(exp_arr[first_index+1...last_index-1]), dictionary: &dictionary, text: &result, count: &count)
        temp_2 = first_index
        temp_3 = last_index
        
        exp_arr.removeSubrange(first_index...last_index)
        exp_arr.insert(String(temp_1!), at: temp_2!)
        
        dictionary.append(exp_arr.joined(separator: " "))
        add_par2_result(dictionary: dictionary, text: &result, count: &count, temp: temp_4!)
        
        add_par3_result(dictionary: dictionary, text: &result, count: &count)
    }
    
    calculate(arr: exp_arr, dictionary: &dictionary, text: &result, count: &count)
    
    result += "}\n"
    return result
}
