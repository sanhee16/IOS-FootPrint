//
//  CategoryIcon.swift
//  Footprint
//
//  Created by sandy on 10/24/24.
//

import Foundation

enum CategoryIcon: Int {
    case athleticsRunning = 0
    case bagDollar
    case baggage
    case bandage
    case beer
    case bicycle
    case capsule
    case cloud
    case coffee
    case controller
    case diamond
    case disableHeart
    case donut
    case drool
    case education
    case feet
    case fitness
    case fitnessShaker
    case flower
    case forkSpoon
    case gift
    case grumpy
    case heart
    case iceCream
    case island
    case laughing
    case leaf
    case lightbulb
    case love
    case mask
    case medical
    case paint
    case peaceHand
    case plane
    case planet
    case prayingHand
    case rocket
    case running
    case sad
    case shocked
    case shoppingCart
    case smile
    case snow
    case soccerField
    case star
    case sun
    case swimming
    case syringe
    case thumbsUp
    case umbrella
    case walking
    case yoga
    
    var imageName: String {
        switch self {
        case .athleticsRunning: return "ic_category_athleticsRunning"
        case .bagDollar: return "ic_category_bagDollar"
        case .baggage: return "ic_category_baggage"
        case .bandage: return "ic_category_bandage"
        case .beer: return "ic_category_beer"
        case .bicycle: return "ic_category_bicycle"
        case .capsule: return "ic_category_capsule"
        case .cloud: return "ic_category_cloud"
        case .coffee: return "ic_category_coffee"
        case .controller: return "ic_category_controller"
        case .diamond: return "ic_category_diamond"
        case .disableHeart: return "ic_category_disableHeart"
        case .donut: return "ic_category_donut"
        case .drool: return "ic_category_drool"
        case .education: return "ic_category_education"
        case .feet: return "ic_category_feet"
        case .fitness: return "ic_category_fitness"
        case .fitnessShaker: return "ic_category_fitnessShaker"
        case .flower: return "ic_category_flower"
        case .forkSpoon: return "ic_category_forkSpoon"
        case .gift: return "ic_category_gift"
        case .grumpy: return "ic_category_grumpy"
        case .heart: return "ic_category_heart"
        case .iceCream: return "ic_category_iceCream"
        case .island: return "ic_category_island"
        case .laughing: return "ic_category_laughing"
        case .leaf: return "ic_category_leaf"
        case .lightbulb: return "ic_category_lightbulb"
        case .love: return "ic_category_love"
        case .mask: return "ic_category_mask"
        case .medical: return "ic_category_medical"
        case .paint: return "ic_category_paint"
        case .peaceHand: return "ic_category_peaceHand"
        case .plane: return "ic_category_plane"
        case .planet: return "ic_category_planet"
        case .prayingHand: return "ic_category_prayingHand"
        case .rocket: return "ic_category_rocket"
        case .running: return "ic_category_running"
        case .sad: return "ic_category_sad"
        case .shocked: return "ic_category_shocked"
        case .shoppingCart: return "ic_category_shoppingCart"
        case .smile: return "ic_category_smile"
        case .snow: return "ic_category_snow"
        case .soccerField: return "ic_category_soccerField"
        case .star: return "ic_category_star"
        case .sun: return "ic_category_sun"
        case .swimming: return "ic_category_swimming"
        case .syringe: return "ic_category_syringe"
        case .thumbsUp: return "ic_category_thumbsUp"
        case .umbrella: return "ic_category_umbrella"
        case .walking: return "ic_category_walking"
        case .yoga: return "ic_category_yoga"
        }
    }
}
