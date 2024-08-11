//
//  Color+Extension.swift
//  Footprint
//
//  Created by sandy on 8/10/24.
//

import Foundation
import SwiftUI

extension Color {
    static let error50: Color = Color(hex: "")
    
    //MARK: #1 원색
    static let BlueGray100: Color = Color(hex: "#f1f5f9")
    static let BlueGray200: Color = Color(hex: "#e2e8f0")
    static let BlueGray300: Color = Color(hex: "#cbd5e1")
    static let BlueGray400: Color = Color(hex: "#94a3b8")
    static let BlueGray50: Color = Color(hex: "#f8fafc")
    static let BlueGray500: Color = Color(hex: "#64748b")
    static let BlueGray600: Color = Color(hex: "#475569")
    static let BlueGray700: Color = Color(hex: "#334155")
    static let BlueGray800: Color = Color(hex: "#1e293b")
    static let BlueGray900: Color = Color(hex: "#0f172a")
    
    static let Blue100: Color = Color(hex: "#c9d5ff")
    static let Blue200: Color = Color(hex: "#a4b9ff")
    static let Blue300: Color = Color(hex: "#678aff")
    static let Blue400: Color = Color(hex: "#3b68ff")
    static let Blue50: Color = Color(hex: "#eef2ff")
    static let Blue500: Color = Color(hex: "#2955ea")
    static let Blue600: Color = Color(hex: "#1840c8")
    static let Blue700: Color = Color(hex: "#0a2ea6")
    static let Blue800: Color = Color(hex: "#13276c")
    static let Blue900: Color = Color(hex: "#0a184a")
    
    static let Green100: Color = Color(hex: "#e7ffbe")
    static let Green200: Color = Color(hex: "#d7ff95")
    static let Green300: Color = Color(hex: "#c7ff6b")
    static let Green400: Color = Color(hex: "#b8ff42")
    static let Green50: Color = Color(hex: "#f6ffe8")
    static let Green500: Color = Color(hex: "#9eef17")
    static let Green600: Color = Color(hex: "#7dc604")
    static let Green700: Color = Color(hex: "#629d00")
    static let Green800: Color = Color(hex: "#497500")
    static let Green900: Color = Color(hex: "#2f4c00")
    
    static let Orange: Color = Color(hex: "#efbd17")
    
    static let Red100: Color = Color(hex: "#ffcabe")
    static let Red200: Color = Color(hex: "#ffa795")
    static let Red300: Color = Color(hex: "#ff856b")
    static let Red400: Color = Color(hex: "#ff6342")
    static let Red50: Color = Color(hex: "#ffece8")
    static let Red500: Color = Color(hex: "#ef3d17")
    static let Red600: Color = Color(hex: "#c62604")
    static let Red700: Color = Color(hex: "#9d1c00")
    static let Red800: Color = Color(hex: "#751500")
    static let Red900: Color = Color(hex: "#4c0d00")
    
    static let ZineGray100: Color = Color(hex: "#f4f4f5")
    static let ZineGray200: Color = Color(hex: "#e4e4e7")
    static let ZineGray300: Color = Color(hex: "#d4d4d8")
    static let ZineGray400: Color = Color(hex: "#a1a1aa")
    static let ZineGray50: Color = Color(hex: "#fafafa")
    static let ZineGray500: Color = Color(hex: "#71717a")
    static let ZineGray600: Color = Color(hex: "#52525b")
    static let ZineGray700: Color = Color(hex: "#3f3f46")
    static let ZineGray800: Color = Color(hex: "#27272a")
    static let ZineGray900: Color = Color(hex: "#18181b")

    
    //MARK: #2 의미
    static let Error100: Color = Self.Red100
    static let Error200: Color = Self.Red200
    static let Error300: Color = Self.Red300
    static let Error400: Color = Self.Red400
    static let Error50: Color = Self.Red50
    static let Error500: Color = Self.Red500
    static let Error600: Color = Self.Red600
    static let Error700: Color = Self.Red700
    static let Error800: Color = Self.Red800
    static let Error900: Color = Self.Red900
    static let GraySacle_Blue100: Color = Self.BlueGray100
    static let GraySacle_Blue200: Color = Self.BlueGray200
    static let GraySacle_Blue300: Color = Self.BlueGray300
    static let GraySacle_Blue400: Color = Self.BlueGray400
    static let GraySacle_Blue50: Color = Self.BlueGray50
    static let GraySacle_Blue500: Color = Self.BlueGray500
    static let GraySacle_Blue600: Color = Self.BlueGray600
    static let GraySacle_Blue700: Color = Self.BlueGray700
    static let GraySacle_Blue800: Color = Self.BlueGray800
    static let GraySacle_Blue900: Color = Self.BlueGray900
    static let GrayScale_Black100: Color = Self.ZineGray100
    static let GrayScale_Black200: Color = Self.ZineGray200
    static let GrayScale_Black300: Color = Self.ZineGray300
    static let GrayScale_Black400: Color = Self.ZineGray400
    static let GrayScale_Black500: Color = Self.ZineGray500
    static let GrayScale_Black600: Color = Self.ZineGray600
    static let GrayScale_Black700: Color = Self.ZineGray700
    static let GrayScale_Black800: Color = Self.ZineGray800
    static let GrayScale_Black900: Color = Self.ZineGray900
    static let GrayScale_BlackBK50: Color = Self.ZineGray50
    static let Primary100: Color = Self.Blue100
    static let Primary200: Color = Self.Blue200
    static let Primary300: Color = Self.Blue300
    static let Primary400: Color = Self.Blue400
    static let Primary50: Color = Self.Blue50
    static let Primary500: Color = Self.Blue500
    static let Primary600: Color = Self.Blue600
    static let Primary700: Color = Self.Blue700
    static let Primary800: Color = Self.Blue800
    static let Primary900: Color = Self.Blue900
    static let Success100: Color = Self.Green100
    static let Success200: Color = Self.Green200
    static let Success300: Color = Self.Green300
    static let Success400: Color = Self.Green400
    static let Success50: Color = Self.Green50
    static let Success500: Color = Self.Green500
    static let Success600: Color = Self.Green600
    static let Success700: Color = Self.Green700
    static let Success800: Color = Self.Green800
    static let Success900: Color = Self.Green900
    
    //MARK: #3 응용
    static let BASIC_Background_Default: Color = Color(hex: "#f2f2f3")
    static let BASIC_Background_Error: Color = Color.ZineGray50
    static let BASIC_Background_Navigation: Color = Color(hex: "#f1f5f9")
    static let BASIC_Background_White: Color = Color.ZineGray50
    static let BASIC_Dim_High_emphasis: Color = Color(hex: "#000000b3")
    static let BASIC_Dim_Low_emphasis: Color = Color(hex: "#00000026")
    static let BASIC_Dim_Mid_emphasis: Color = Color(hex: "#00000080")
    static let BASIC_Drop_Shadow_Gray_High_emphasis: Color = Color(hex: "#000000b3")
    static let BASIC_Drop_Shadow_Gray_Low_emphasis: Color = Color(hex: "#00000026")
    static let BASIC_Drop_Shadow_Gray_Mid_emphasis: Color = Color(hex: "#00000080")
    static let BASIC_Drop_Shadow_Primary_High_emphasis: Color = Color(hex: "#4162d2b3")
    static let BASIC_Drop_Shadow_Primary_Low_emphasis: Color = Color(hex: "#4162d226")
    static let BASIC_Drop_Shadow_Primary_Mid_emphasis: Color = Color(hex: "#4162d280")
    static let BASIC_Etc_Black: Color = Color(hex: "#363943")
    static let BASIC_Etc_Blue_1: Color = Color(hex: "#5d7cfa")
    static let BASIC_Etc_Blue_2: Color = Color(hex: "#349aef")
    static let BASIC_Etc_Green_1: Color = Color(hex: "#1fc998")
    static let BASIC_Etc_Green_2: Color = Color(hex: "#94d82d")
    static let BASIC_Etc_Orange: Color = Color(hex: "#fa5252")
    static let BASIC_Etc_Pink: Color = Color(hex: "#fc1961")
    static let BASIC_Etc_Purple_1: Color = Color(hex: "#8e5ce6")
    static let BASIC_Etc_Purple_2: Color = Color(hex: "#cc5de8")
    static let BASIC_Etc_Yellow: Color = Color(hex: "#fcc216")
    static let BASIC_Stroke_Active: Color = Self.GraySacle_Blue500
    static let BASIC_Stroke_Default: Color = Self.GrayScale_Black200
    static let BASIC_Stroke_Done: Color = Self.GraySacle_Blue300
    static let BASIC_Stroke_Error: Color = Self.Red500
    static let BASIC_Text_Icon_Gray_Default: Color = Self.GrayScale_Black900
    static let BASIC_Text_Icon_Gray_High_emphasis: Color = Self.GraySacle_Blue800
    static let BASIC_Text_Icon_Gray_Low_emphasis: Color = Self.GraySacle_Blue300
    static let BASIC_Text_Icon_Gray_Mid_emphasis: Color = Self.GraySacle_Blue500
    static let BASIC_Text_Icon_Gray_Reversal: Color = Self.GraySacle_Blue50
    static let BASIC_Text_Icon_Primary_Default: Color = Self.Primary800
    static let BASIC_Text_Icon_Primary_High_emphasis: Color = Self.Primary700
    static let BASIC_Text_Icon_Primary_Low_emphasis: Color = Self.Primary200
    static let BASIC_Text_Icon_Primary_Mid_emphasis: Color = Self.Primary500
    static let BASIC_Text_Icon_Primary_Reversal: Color = Self.Primary50
    static let BASIC_Text_Icon_System_Error_Default: Color = Self.Error500
    static let BASIC_Text_Icon_System_High_emphasis_2: Color = Self.GraySacle_Blue700
    static let BASIC_Text_Icon_System_Low_emphasis_2: Color = Self.GraySacle_Blue300
    static let BASIC_Text_Icon_System_Mid_emphasis_2: Color = Self.GrayScale_Black500
    static let BASIC_Text_Icon_System_Reversal_2: Color = Self.GraySacle_Blue50
    static let BUTTON_Icon_Background_Able: Color = Self.GraySacle_Blue50
    static let BUTTON_Icon_Background_Default: Color = Self.GraySacle_Blue50
    static let BUTTON_Icon_Background_Disable: Color = Self.GraySacle_Blue100
    static let BUTTON_Icon_Background_Press: Color = Self.Primary50
    static let BUTTON_Icon_Contents_Able: Color = Self.Primary400
    static let BUTTON_Icon_Contents_Default: Color = Self.GraySacle_Blue500
    static let BUTTON_Icon_Contents_Disable: Color = Self.GraySacle_Blue300
    static let BUTTON_Icon_Contents_Press: Color = Self.Primary400
    static let BUTTON_Icon_Stroke_Default: Color = Self.GraySacle_Blue200
    static let BUTTON_Icon_Stroke_Disable: Color = Self.GraySacle_Blue50
    static let BUTTON_Icon_Stroke_Press: Color = Self.Primary100
    static let BUTTON_Light_Solid_Background_Default: Color = Self.GraySacle_Blue200
    static let BUTTON_Light_Solid_Background_Disable: Color = Self.GraySacle_Blue300
    static let BUTTON_Light_Solid_Background_Press: Color = Self.GraySacle_Blue50
    static let BUTTON_Light_Solid_Contents_Default: Color = Self.GraySacle_Blue500
    static let BUTTON_Light_Solid_Contents_Disable: Color = Self.GrayScale_Black400
    static let BUTTON_Light_Solid_Contents_Press: Color = Self.Primary600
    static let BUTTON_Outline_Background_Default: Color = Self.GraySacle_Blue50
    static let BUTTON_Outline_Background_Disable: Color = Self.GraySacle_Blue200
    static let BUTTON_Outline_Background_Press: Color = Self.GraySacle_Blue100
    static let BUTTON_Outline_Contents_Default: Color = Self.Primary500
    static let BUTTON_Outline_Contents_Disable: Color = Self.GraySacle_Blue400
    static let BUTTON_Outline_Contents_Press: Color = Self.Primary500
    static let BUTTON_Outline_Stroke_Default: Color = Self.Primary500
    static let BUTTON_Outline_Stroke_Disable: Color = Self.GraySacle_Blue400
    static let BUTTON_Outline_Stroke_Press: Color = Self.Primary300
    static let BUTTON_Solid_Background_Default: Color = Self.Blue500
    static let BUTTON_Solid_Background_Disable: Color = Self.Primary800
    static let BUTTON_Solid_Background_Press: Color = Self.Primary300
    static let BUTTON_Solid_Contents_Default: Color = Self.GrayScale_BlackBK50
    static let BUTTON_Solid_Contents_Disable: Color = Self.GraySacle_Blue400
    static let BUTTON_Solid_Contents_Press: Color = Self.GraySacle_Blue50
    static let BUTTON_Text_Contents_Gray_Default: Color = Self.GraySacle_Blue700
    static let BUTTON_Text_Contents_Gray_Disable: Color = Self.GrayScale_Black400
    static let BUTTON_Text_Contents_Gray_Press: Color = Self.GrayScale_Black500
    static let BUTTON_Text_Contents_Primary_Default: Color = Self.Primary500
    static let BUTTON_Text_Contents_Primary_Disable: Color = Self.GraySacle_Blue400
    static let BUTTON_Text_Contents_Primary_Press: Color = Self.Primary500
    
    
    
    
}
