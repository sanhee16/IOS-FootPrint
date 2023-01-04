//
//  SwiftUIExtension.swift
//  Footprint
//
//  Created by sandy on 2022/11/06.
//

import SwiftUI
import Combine

extension View {
    public func border(_ color: Color, lineWidth: CGFloat, cornerRadius: CGFloat) -> some View {
        return self
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: lineWidth).foregroundColor(color))
    }
    
    public func frame(both: CGFloat, aligment: Alignment = .center) -> some View {
        return self
            .frame(width: both, height: both, alignment: aligment)
    }
    
    func rectReader(_ binding: Binding<CGRect>, in space: CoordinateSpace) -> some View {
        self.background(GeometryReader { (geometry) -> AnyView in
            let rect = geometry.frame(in: space)
            DispatchQueue.main.async {
                binding.wrappedValue = rect
            }
            return AnyView(Rectangle().fill(Color.clear))
        })
    }
}

extension Color {
    init(hex string: String, opacity: CGFloat? = nil) {
        var string: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if string.hasPrefix("#") {
            _ = string.removeFirst()
        }
        
        // Double the last value if incomplete hex
        if !string.count.isMultiple(of: 2), let last = string.last {
            string.append(last)
        }
        
        // Fix invalid values
        if string.count > 8 {
            string = String(string.prefix(8))
        }
        
        // Scanner creation
        let scanner = Scanner(string: string)
        
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        
        if string.count == 2 {
            let mask = 0xFF
            let g = Int(color) & mask
            let gray = Double(g) / 255.0
            
            
            if let opacity = opacity {
                self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: opacity)
            } else {
                self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)
            }
        } else if string.count == 4 {
            let mask = 0x00FF
            
            let g = Int(color >> 8) & mask
            let a = Int(color) & mask
            
            let gray = Double(g) / 255.0
            let alpha = Double(a) / 255.0
            
            if let opacity = opacity {
                self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: opacity)
            } else {
                self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)
            }
        } else if string.count == 6 {
            let mask = 0x0000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask
            
            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0
            
            if let opacity = opacity {
                self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
            } else {
                self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)
            }
            
        } else if string.count == 8 {
            let mask = 0x000000FF
            let r = Int(color >> 24) & mask
            let g = Int(color >> 16) & mask
            let b = Int(color >> 8) & mask
            let a = Int(color) & mask
            
            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0
            let alpha = Double(a) / 255.0
            
            if let opacity = opacity {
                self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
            } else {
                self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
            }
            
        } else {
            self.init(.sRGB, red: 1, green: 1, blue: 1, opacity: 1)
        }
    }
    
//    func hexToString() -> String {
//        let r: CGFloat = 0
//        let g: CGFloat = 0
//        let b: CGFloat = 0
//        let a: CGFloat = 0
//
//        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
//
//        return String(format: "#%06x", rgb)
//    }
    
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if a != Float(1.0) {
            return String(format: "#%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
    
    var uiColor: UIColor {
        get { UIColor(cgColor: cgColor!) }
    }
    public static let greenTint1: Color = Color(hex: "#4B8A67")
    public static let greenTint2: Color = Color(hex: "#69BC8D")
    public static let greenTint3: Color = Color(hex: "#D5E5DF")
    public static let greenTint4: Color = Color(hex: "#4B8A67", opacity: 0.3)
    public static let greenTint5: Color = Color(hex: "#4B8A67", opacity: 0.1)
    
    public static let pin0: Color = Color(hex: "#000000")
    public static let pin1: Color = Color(hex: "#FC1961")
    public static let pin2: Color = Color(hex: "#FA5252")
    public static let pin3: Color = Color(hex: "#8D5DE8")
    public static let pin4: Color = Color(hex: "#CC5DE8")
    public static let pin5: Color = Color(hex: "#5C7CFA")
    public static let pin6: Color = Color(hex: "#339AF0")
    public static let pin7: Color = Color(hex: "#20C997")
    public static let pin8: Color = Color(hex: "#94D82D")
    public static let pin9: Color = Color(hex: "#FCC419")
    
    public static let clearSky90: Color = Color(hex: "#78D7FF", opacity: 0.9)
    public static let fewClouds90: Color = Color(hex: "#76A5FF", opacity: 0.9)
    public static let scatteredClouds90: Color = Color(hex: "#4971FF", opacity: 0.9)
    public static let brokenClouds90: Color = Color(hex: "#42339B", opacity: 0.9)
    public static let showerRain90: Color = Color(hex: "#53FFC1", opacity: 0.9)
    public static let rain90: Color = Color(hex: "#FFB629", opacity: 0.9)
    public static let thunderStorm90: Color = Color(hex: "#907DFF", opacity: 0.9)
    public static let snow90: Color = Color(hex: "#FFFFFF", opacity: 0.9)
    public static let mist90: Color = Color(hex: "#B9B9B9", opacity: 0.9)
    public static let unknown90: Color = Color(hex: "#76A5FF", opacity: 0.9)
    
    public static let clearSky60: Color = Color(hex: "#78D7FF", opacity: 0.4)
    public static let fewClouds60: Color = Color(hex: "#76A5FF", opacity: 0.4)
    public static let scatteredClouds60: Color = Color(hex: "#4971FF", opacity: 0.4)
    public static let brokenClouds60: Color = Color(hex: "#42339B", opacity: 0.4)
    public static let showerRain60: Color = Color(hex: "#53FFC1", opacity: 0.4)
    public static let rain60: Color = Color(hex: "#FFB629", opacity: 0.4)
    public static let thunderStorm60: Color = Color(hex: "#907DFF", opacity: 0.4)
    public static let snow60: Color = Color(hex: "#FFFFFF", opacity: 0.4)
    public static let mist60: Color = Color(hex: "#B9B9B9", opacity: 0.4)
    public static let unknown60: Color = Color(hex: "#76A5FF", opacity: 0.4)
    
    public static let mint100: Color = Color(hex: "#1ED8C5")
    public static let orange100: Color = Color(hex: "#FF752F")
    
    public static let lightblue100: Color = Color(hex: "#78D7FF")
    public static let lightblue80: Color = Color(hex: "#78D7FF", opacity: 0.8)
    public static let lightblue60: Color = Color(hex: "#78D7FF", opacity: 0.6)
    public static let lightblue01: Color = Color(hex: "#C7EEFF")
    public static let lightblue02: Color = Color(hex: "#B9EAFF")
    public static let lightblue03: Color = Color(hex: "#E4F7FF")
    
    public static let darkblue100: Color = Color(hex: "#1875FF")
    public static let darkblue80: Color = Color(hex: "#1875FF", opacity: 0.8)
    public static let darkblue60: Color = Color(hex: "#1875FF", opacity: 0.6)
    
    public static let blue100: Color = Color(hex: "#15B9FF")
    public static let blue80: Color = Color(hex: "#15B9FF", opacity: 0.8)
    public static let blue60: Color = Color(hex: "#15B9FF", opacity: 0.6)
    
    public static let red100: Color = Color(hex: "#FF4C24")
    public static let red80: Color = Color(hex: "#FF4C24", opacity: 0.8)
    public static let red60: Color = Color(hex: "#FF4C24", opacity: 0.6)
    
    public static let yellow100: Color = Color(hex: "#FFD027")
    public static let yellow80: Color = Color(hex: "#FFD027", opacity: 0.8)
    public static let yellow60: Color = Color(hex: "#FFD027", opacity: 0.6)
    
    public static let gray100: Color = Color(hex: "#454545")
    public static let gray90: Color = Color(hex: "#454B52")
    public static let gray60: Color = Color(hex: "#454545", opacity: 0.6)
    public static let gray50: Color = Color(hex: "#454545", opacity: 0.5)
    public static let gray30: Color = Color(hex: "#454545", opacity: 0.3)
    public static let lightGray01: Color = Color(hex: "#E8E8E8")
    public static let lightGray02: Color = Color(hex: "#EAEDF0")
    public static let lightGray03: Color = Color(hex: "#F8F8F8")
    public static let lightGray04: Color = Color(hex: "#FEFEFE")
    
    public static let dim: Color = Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.6)
}

extension UIColor {
    convenience init(hex: String, opacity: CGFloat? = nil) {
        var hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if hex.hasPrefix("#") {
            _ = hex.removeFirst()
        }
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        if let opacity = opacity {
            self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: opacity)
        } else {
            self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
        }
    }
    public static let lightblue03: UIColor = UIColor(hex: "#E4F7FF")
    
    public static let greenTint1: UIColor = UIColor(hex: "#4B8A67")
    public static let greenTint2: UIColor = UIColor(hex: "#69BC8D")
    public static let greenTint3: UIColor = UIColor(hex: "#D5E5DF")
    public static let greenTint4: UIColor = UIColor(hex: "#4B8A67", opacity: 0.3)
    public static let greenTint5: UIColor = UIColor(hex: "#4B8A67", opacity: 0.1)
    
    public static let pin0: UIColor = UIColor(hex: "#000000")
    public static let pin1: UIColor = UIColor(hex: "#FC1961")
    public static let pin2: UIColor = UIColor(hex: "#FA5252")
    public static let pin3: UIColor = UIColor(hex: "#8D5DE8")
    public static let pin4: UIColor = UIColor(hex: "#CC5DE8")
    public static let pin5: UIColor = UIColor(hex: "#5C7CFA")
    public static let pin6: UIColor = UIColor(hex: "#339AF0")
    public static let pin7: UIColor = UIColor(hex: "#20C997")
    public static let pin8: UIColor = UIColor(hex: "#94D82D")
    public static let pin9: UIColor = UIColor(hex: "#FCC419")
    
    public static let clearSky60: UIColor = UIColor(hex: "#78D7FF", opacity: 0.4)
    public static let fewClouds60: UIColor = UIColor(hex: "#76A5FF", opacity: 0.4)
    public static let scatteredClouds60: UIColor = UIColor(hex: "#4971FF", opacity: 0.4)
    public static let brokenClouds60: UIColor = UIColor(hex: "#42339B", opacity: 0.4)
    public static let showerRain60: UIColor = UIColor(hex: "#53FFC1", opacity: 0.4)
    public static let rain60: UIColor = UIColor(hex: "#FFB629", opacity: 0.4)
    public static let thunderStorm60: UIColor = UIColor(hex: "#907DFF", opacity: 0.4)
    public static let snow60: UIColor = UIColor(hex: "#FFFFFF", opacity: 0.4)
    public static let mist60: UIColor = UIColor(hex: "#B9B9B9", opacity: 0.4)
    public static let unknown60: UIColor = UIColor(hex: "#76A5FF", opacity: 0.4)
    
    public static let mint100: UIColor = UIColor(hex: "#1ED8C5")
    public static let orange100: UIColor = UIColor(hex: "#FF752F")
    
    public static let lightblue100: UIColor = UIColor(hex: "#78D7FF")
    public static let lightblue80: UIColor = UIColor(hex: "#78D7FF", opacity: 0.8)
    public static let lightblue60: UIColor = UIColor(hex: "#78D7FF", opacity: 0.6)
    public static let darkblue100: UIColor = UIColor(hex: "#1875FF")
    public static let darkblue80: UIColor = UIColor(hex: "#1875FF", opacity: 0.8)
    public static let darkblue60: UIColor = UIColor(hex: "#1875FF", opacity: 0.6)
    public static let blue100: UIColor = UIColor(hex: "#15B9FF")
    public static let blue80: UIColor = UIColor(hex: "#15B9FF", opacity: 0.8)
    public static let blue60: UIColor = UIColor(hex: "#15B9FF", opacity: 0.6)
    public static let red100: UIColor = UIColor(hex: "#FF4C24")
    public static let red80: UIColor = UIColor(hex: "#FF4C24", opacity: 0.8)
    public static let red60: UIColor = UIColor(hex: "#FF4C24", opacity: 0.6)
    public static let yellow100: UIColor = UIColor(hex: "#FFD027")
    public static let yellow80: UIColor = UIColor(hex: "#FFD027", opacity: 0.8)
    public static let yellow60: UIColor = UIColor(hex: "#FFD027", opacity: 0.6)
    
    public static let gray100: UIColor = UIColor(hex: "#454545")
    public static let gray90: UIColor = UIColor(hex: "#454B52")
    public static let gray60: UIColor = UIColor(hex: "#454545", opacity: 0.6)
    public static let gray50: UIColor = UIColor(hex: "#454545", opacity: 0.5)
    public static let gray30: UIColor = UIColor(hex: "#454545", opacity: 0.3)
    public static let lightGray01: UIColor = UIColor(hex: "#E8E8E8")
    public static let lightGray02: UIColor = UIColor(hex: "#EAEDF0")
    public static let lightGray03: UIColor = UIColor(hex: "#F8F8F8")
    
    public static let dim: UIColor = .init(red: 0, green: 0, blue: 0, alpha: 0.6) //UIColor(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.6)
}

extension Font {
    public static let kr45b: Font = .system(size: 45, weight: .bold, design: .default)
    public static let kr45r: Font = .system(size: 45, weight: .regular, design: .default)
    
    public static let kr40b: Font = .system(size: 40, weight: .bold, design: .default)
    public static let kr40r: Font = .system(size: 40, weight: .regular, design: .default)
    
    public static let kr30b: Font = .system(size: 30, weight: .bold, design: .default)
    public static let kr30r: Font = .system(size: 30, weight: .regular, design: .default)
    
    public static let kr26b: Font = .system(size: 26, weight: .bold, design: .default)
    public static let kr26r: Font = .system(size: 26, weight: .regular, design: .default)
    
    public static let kr20b: Font = .system(size: 20, weight: .bold, design: .default)
    public static let kr20r: Font = .system(size: 20, weight: .regular, design: .default)
    
    public static let kr19b: Font = .system(size: 19, weight: .bold, design: .default)
    public static let kr19r: Font = .system(size: 19, weight: .regular, design: .default)
    
    public static let kr18b: Font = .system(size: 18, weight: .bold, design: .default)
    public static let kr18r: Font = .system(size: 18, weight: .regular, design: .default)
    
    public static let kr16b: Font = .system(size: 16, weight: .bold, design: .default)
    public static let kr16r: Font = .system(size: 16, weight: .regular, design: .default)
    
    public static let kr15b: Font = .system(size: 15, weight: .bold, design: .default)
    public static let kr15r: Font = .system(size: 15, weight: .regular, design: .default)
    
    public static let kr14b: Font = .system(size: 14, weight: .bold, design: .default)
    public static let kr14r: Font = .system(size: 14, weight: .regular, design: .default)
    
    public static let kr13b: Font = .system(size: 13, weight: .bold, design: .default)
    public static let kr13r: Font = .system(size: 13, weight: .regular, design: .default)
    
    public static let kr12b: Font = .system(size: 12, weight: .bold, design: .default)
    public static let kr12r: Font = .system(size: 12, weight: .regular, design: .default)
    
    public static let kr11b: Font = .system(size: 11, weight: .bold, design: .default)
    public static let kr11r: Font = .system(size: 11, weight: .regular, design: .default)
    
    public static let kr10b: Font = .system(size: 10, weight: .bold, design: .default)
    public static let kr10r: Font = .system(size: 10, weight: .regular, design: .default)
    
    public static let kr9r: Font = .system(size: 9, weight: .regular, design: .default)
}

extension UIFont {
    public static let kr30b: UIFont = .systemFont(ofSize: 30, weight: .bold)
    public static let kr30r: UIFont = .systemFont(ofSize: 30, weight: .regular)
    
    public static let kr26b: UIFont = .systemFont(ofSize: 26, weight: .bold)
    public static let kr26r: UIFont = .systemFont(ofSize: 26, weight: .regular)
    
    public static let kr20b: UIFont = .systemFont(ofSize: 20, weight: .bold)
    public static let kr20r: UIFont = .systemFont(ofSize: 20, weight: .regular)
    
    public static let kr19b: UIFont = .systemFont(ofSize: 19, weight: .bold)
    public static let kr19r: UIFont = .systemFont(ofSize: 19, weight: .regular)
    
    public static let kr18b: UIFont = .systemFont(ofSize: 18, weight: .bold)
    public static let kr18r: UIFont = .systemFont(ofSize: 18, weight: .regular)
    
    public static let kr16b: UIFont = .systemFont(ofSize: 16, weight: .bold)
    public static let kr16r: UIFont = .systemFont(ofSize: 16, weight: .regular)
    
    public static let kr15b: UIFont = .systemFont(ofSize: 15, weight: .bold)
    public static let kr15r: UIFont = .systemFont(ofSize: 15, weight: .regular)
    
    public static let kr14b: UIFont = .systemFont(ofSize: 14, weight: .bold)
    public static let kr14r: UIFont = .systemFont(ofSize: 14, weight: .regular)
    
    public static let kr13b: UIFont = .systemFont(ofSize: 13, weight: .bold)
    public static let kr13r: UIFont = .systemFont(ofSize: 13, weight: .regular)
    
    public static let kr12b: UIFont = .systemFont(ofSize: 12, weight: .bold)
    public static let kr12r: UIFont = .systemFont(ofSize: 12, weight: .regular)
    
    public static let kr11b: UIFont = .systemFont(ofSize: 11, weight: .bold)
    public static let kr11r: UIFont = .systemFont(ofSize: 11, weight: .regular)
    
    public static let kr10b: UIFont = .systemFont(ofSize: 10, weight: .bold)
    public static let kr10r: UIFont = .systemFont(ofSize: 10, weight: .regular)
    
    public static let kr9r: UIFont = .systemFont(ofSize: 9, weight: .regular)
}


extension UIImage {
    func resizeImageTo(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
