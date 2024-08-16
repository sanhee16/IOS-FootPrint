//
//  Color+Extension.swift
//  Footprint
//
//  Created by sandy on 8/10/24.
//

import Foundation
import SwiftUI

import Foundation
import SwiftUI

//MARK: #1 원색
extension Color {
    static let blueGray_100: Color = Color(hex: "#f1f5f9")
    static let blueGray_200: Color = Color(hex: "#e2e8f0")
    static let blueGray_300: Color = Color(hex: "#cbd5e1")
    static let blueGray_400: Color = Color(hex: "#94a3b8")
    static let blueGray_50: Color = Color(hex: "#f8fafc")
    static let blueGray_500: Color = Color(hex: "#64748b")
    static let blueGray_600: Color = Color(hex: "#475569")
    static let blueGray_700: Color = Color(hex: "#334155")
    static let blueGray_800: Color = Color(hex: "#1e293b")
    static let blueGray_900: Color = Color(hex: "#0f172a")
    static let blue_100: Color = Color(hex: "#c9d5ff")
    static let blue_200: Color = Color(hex: "#a4b9ff")
    static let blue_300: Color = Color(hex: "#678aff")
    static let blue_400: Color = Color(hex: "#3b68ff")
    static let blue_50: Color = Color(hex: "#eef2ff")
    static let blue_500: Color = Color(hex: "#2955ea")
    static let blue_600: Color = Color(hex: "#1840c8")
    static let blue_700: Color = Color(hex: "#0a2ea6")
    static let blue_800: Color = Color(hex: "#13276c")
    static let blue_900: Color = Color(hex: "#0a184a")
    static let green_100: Color = Color(hex: "#e7ffbe")
    static let green_200: Color = Color(hex: "#d7ff95")
    static let green_300: Color = Color(hex: "#c7ff6b")
    static let green_400: Color = Color(hex: "#b8ff42")
    static let green_50: Color = Color(hex: "#f6ffe8")
    static let green_500: Color = Color(hex: "#9eef17")
    static let green_600: Color = Color(hex: "#7dc604")
    static let green_700: Color = Color(hex: "#629d00")
    static let green_800: Color = Color(hex: "#497500")
    static let green_900: Color = Color(hex: "#2f4c00")
    static let red_100: Color = Color(hex: "#ffcabe")
    static let red_200: Color = Color(hex: "#ffa795")
    static let red_300: Color = Color(hex: "#ff856b")
    static let red_400: Color = Color(hex: "#ff6342")
    static let red_50: Color = Color(hex: "#ffece8")
    static let red_500: Color = Color(hex: "#ef3d17")
    static let red_600: Color = Color(hex: "#c62604")
    static let red_700: Color = Color(hex: "#9d1c00")
    static let red_800: Color = Color(hex: "#751500")
    static let red_900: Color = Color(hex: "#4c0d00")
    static let yellow: Color = Color(hex: "#efbd17")
    static let zineGray_100: Color = Color(hex: "#f4f4f5")
    static let zineGray_200: Color = Color(hex: "#e4e4e7")
    static let zineGray_300: Color = Color(hex: "#d4d4d8")
    static let zineGray_400: Color = Color(hex: "#a1a1aa")
    static let zineGray_50: Color = Color(hex: "#fafafa")
    static let zineGray_500: Color = Color(hex: "#71717a")
    static let zineGray_600: Color = Color(hex: "#52525b")
    static let zineGray_700: Color = Color(hex: "#3f3f46")
    static let zineGray_800: Color = Color(hex: "#27272a")
    static let zineGray_900: Color = Color(hex: "#18181b")
}

//MARK: #2 의미
extension Color {
    static let blackGray_100: Color = Color.zineGray_100
    static let blackGray_200: Color = Color.zineGray_200
    static let blackGray_300: Color = Color.zineGray_300
    static let blackGray_400: Color = Color.zineGray_400
    static let blackGray_50: Color = Color.zineGray_50
    static let blackGray_500: Color = Color.zineGray_500
    static let blackGray_600: Color = Color.zineGray_600
    static let blackGray_700: Color = Color.zineGray_700
    static let blackGray_800: Color = Color.zineGray_800
    static let blackGray_900: Color = Color.zineGray_900
    static let error_100: Color = Color.red_100
    static let error_200: Color = Color.red_200
    static let error_300: Color = Color.red_300
    static let error_400: Color = Color.red_400
    static let error_50: Color = Color.red_50
    static let error_500: Color = Color.red_500
    static let error_600: Color = Color.red_600
    static let error_700: Color = Color.red_700
    static let error_800: Color = Color.red_800
    static let error_900: Color = Color.red_900
    static let primary_100: Color = Color.blue_100
    static let primary_200: Color = Color.blue_200
    static let primary_300: Color = Color.blue_300
    static let primary_400: Color = Color.blue_400
    static let primary_50: Color = Color.blue_50
    static let primary_500: Color = Color.blue_500
    static let primary_600: Color = Color.blue_600
    static let primary_700: Color = Color.blue_700
    static let primary_800: Color = Color.blue_800
    static let primary_900: Color = Color.blue_900
    static let success_100: Color = Color.green_100
    static let success_200: Color = Color.green_200
    static let success_300: Color = Color.green_300
    static let success_400: Color = Color.green_400
    static let success_50: Color = Color.green_50
    static let success_500: Color = Color.green_500
    static let success_600: Color = Color.green_600
    static let success_700: Color = Color.green_700
    static let success_800: Color = Color.green_800
    static let success_900: Color = Color.green_900

}

//MARK: #3 응용
extension Color {
    static let bg_bgb: Color = Color(hex: "#f1f5f9")
    static let bg_default: Color = Color(hex: "#f2f2f3")
    static let bg_white: Color = Color.zineGray_50
    static let cont_gray_default: Color = Color.blackGray_900
    static let cont_gray_high: Color = Color.blueGray_800
    static let cont_gray_low: Color = Color.blueGray_300
    static let cont_gray_mid: Color = Color.blueGray_500
    static let cont_gray_reversal: Color = Color.blueGray_50
    static let cont_primary_default: Color = Color.primary_800
    static let cont_primary_high: Color = Color.primary_700
    static let cont_primary_low: Color = Color.primary_200
    static let cont_primary_mid: Color = Color.primary_500
    static let cont_primary_reversal: Color = Color.primary_50
    static let cont_error_default: Color = Color.error_500
    static let stroke_active: Color = Color.blueGray_500
    static let stroke_default: Color = Color.blackGray_200
    static let stroke_done: Color = Color.blueGray_300
    static let stroke_error: Color = Color.red_500
    static let dim_black_high: Color = Color(hex: "#000000b3")
    static let dim_black_low: Color = Color(hex: "#00000026")
    static let dim_black_mid: Color = Color(hex: "#00000080")
    static let dim_white_high: Color = Color(hex: "#ffffffd9")
    static let dim_white_low: Color = Color(hex: "#ffffff33")
    static let dim_white_mid: Color = Color(hex: "#ffffff80")
    static let dropSahdow_gray_high: Color = Color(hex: "#000000b3")
    static let dropSahdow_gray_low: Color = Color(hex: "#00000026")
    static let dropSahdow_gray_mid: Color = Color(hex: "#00000080")
    static let dropSahdow_primary_high: Color = Color(hex: "#4162d2b3")
    static let dropSahdow_primary_low: Color = Color(hex: "#4162d226")
    static let dropSahdow_primary_mid: Color = Color(hex: "#4162d280")
    static let etc_black_high: Color = Color(hex: "#363943")
    static let etc_black_mid: Color = Color(hex: "#9a9ba0")
    static let etc_blue_high: Color = Color(hex: "#349aef")
    static let etc_blue_mid: Color = Color(hex: "#aed7f9")
    static let etc_green_high: Color = Color(hex: "#1fc998")
    static let etc_green_mid: Color = Color(hex: "#a5e9d6")
    static let etc_orange_high: Color = Color(hex: "#fa5252")
    static let etc_orange_mid: Color = Color(hex: "#fdbaba")
    static let etc_pink_high: Color = Color(hex: "#fc1961")
    static let etc_pink_mid: Color = Color(hex: "#fd8baf")
    static let etc_purple_high: Color = Color(hex: "#8e5ce6")
    static let etc_purple_mid: Color = Color(hex: "#d2bef5")
    static let etc_yellow_high: Color = Color(hex: "#fcc216")
    static let etc_yellow_mid: Color = Color(hex: "#fde08a")
    static let btn_ic_bg_able: Color = Color.blueGray_50
    static let btn_ic_bg_default: Color = Color.blueGray_50
    static let btn_ic_bg_disable: Color = Color.blueGray_100
    static let btn_ic_bg_press: Color = Color.primary_50
    static let btn_ic_cont_able: Color = Color.primary_400
    static let btn_ic_cont_default: Color = Color.blueGray_500
    static let btn_ic_cont_disable: Color = Color.blueGray_300
    static let btn_ic_cont_press: Color = Color.primary_400
    static let btn_ic_exception_bg_default: Color = Color.blackGray_900
    static let btn_ic_exception_cont_default: Color = Color.blueGray_50
    static let btn_ic_stroke_able: Color = Color.blueGray_200
    static let btn_ic_stroke_default: Color = Color.blueGray_200
    static let btn_ic_stroke_disable: Color = Color.blueGray_50
    static let btn_ic_stroke_press: Color = Color.primary_100
    static let btn_lightSolid_bg_default: Color = Color.blueGray_200
    static let btn_lightSolid_bg_disable: Color = Color.blueGray_300
    static let btn_lightSolid_bg_press: Color = Color.blueGray_50
    static let btn_lightSolid_cont_default: Color = Color.blueGray_500
    static let btn_lightSolid_cont_disable: Color = Color.blackGray_400
    static let btn_lightSolid_cont_press: Color = Color.primary_600
    static let btn_outline_bg_default: Color = Color.blueGray_50
    static let btn_outline_bg_disable: Color = Color.blueGray_200
    static let btn_outline_bg_press: Color = Color.blueGray_100
    static let btn_outline_cont_default: Color = Color.primary_500
    static let btn_outline_cont_disable: Color = Color.blueGray_400
    static let btn_outline_cont_press: Color = Color.primary_500
    static let btn_outline_stroke_default: Color = Color.primary_500
    static let btn_outline_stroke_disable: Color = Color.blueGray_400
    static let btn_outline_stroke_press: Color = Color.primary_300
    static let btn_solid_bg_default: Color = Color.blue_500
    static let btn_solid_bg_disable: Color = Color.primary_800
    static let btn_solid_bg_press: Color = Color.primary_300
    static let btn_solid_cont_default: Color = Color.blackGray_50
    static let btn_solid_cont_disable: Color = Color.blueGray_400
    static let btn_solid_cont_press: Color = Color.blueGray_50
    static let btn_text_gray_default: Color = Color.blueGray_700
    static let btn_text_gray_disable: Color = Color.blackGray_400
    static let btn_text_gray_press: Color = Color.blackGray_500
    static let btn_text_primary_default: Color = Color.primary_500
    static let btn_text_primary_disable: Color = Color.blueGray_400
    static let btn_text_primary_press: Color = Color.primary_500
}
