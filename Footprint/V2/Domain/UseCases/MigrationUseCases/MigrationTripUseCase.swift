//
//  MigrationTripUseCase.swift
//  Footprint
//
//  Created by sandy on 1/21/25.
//

import Foundation

class MigrationTripUseCase {
    let migrationRepository: MigrationRepository
    let updateTripUseCase: UpdateTripUseCase
    
    let tripIcons: [TripIcon] = [
        TripIcon.ic_concept_01_smile, TripIcon.ic_concept_02_prank, TripIcon.ic_concept_03_lol, TripIcon.ic_concept_04_unhappy, TripIcon.ic_concept_05_disapointed, TripIcon.ic_concept_06_mad, TripIcon.ic_concept_07_like, TripIcon.ic_concept_08_dislike, TripIcon.ic_concept_09_noHand, TripIcon.ic_concept_10_star, TripIcon.ic_concept_11_heart, TripIcon.ic_concept_12_clover, TripIcon.ic_concept_13_square, TripIcon.ic_concept_14_circle, TripIcon.ic_concept_15_triangle, TripIcon.ic_concept_16_diamond, TripIcon.ic_concept_17_tripRoad, TripIcon.ic_concept_18_earthStar, TripIcon.ic_concept_19_car, TripIcon.ic_concept_20_bus, TripIcon.ic_concept_21_bicycle, TripIcon.ic_concept_22_metro, TripIcon.ic_concept_23_plane, TripIcon.ic_concept_24_amusementPark, TripIcon.ic_concept_25_confetti, TripIcon.ic_concept_26_movie, TripIcon.ic_concept_27_restaurantDishes, TripIcon.ic_concept_28_iceCream, TripIcon.ic_concept_29_coffee, TripIcon.ic_concept_30_bread, TripIcon.ic_concept_31_cocktail, TripIcon.ic_concept_32_champagne, TripIcon.ic_concept_33_walking, TripIcon.ic_concept_34_running, TripIcon.ic_concept_35_yoga, TripIcon.ic_concept_36_fitnessShaker, TripIcon.ic_concept_37_fitnessBicycle, TripIcon.ic_concept_38_athleticsRunning, TripIcon.ic_concept_39_golfHole, TripIcon.ic_concept_40_soccerField, TripIcon.ic_concept_41_bookmark, TripIcon.ic_concept_42_paperEdit, TripIcon.ic_concept_43_tags, TripIcon.ic_concept_44_awardRibbonStar, TripIcon.ic_concept_45_rankingStarsRibbon, TripIcon.ic_concept_46_fire, TripIcon.ic_concept_47_music, TripIcon.ic_concept_48_spaceAstronaut, TripIcon.ic_concept_49_house, TripIcon.ic_concept_50_officeOutdoors, TripIcon.ic_concept_51_stampsImage, TripIcon.ic_concept_52_camera, TripIcon.ic_concept_53_accountingBillStack, TripIcon.ic_concept_54_shoppingCart, TripIcon.ic_concept_55_medical, TripIcon.ic_concept_56_capsule, TripIcon.ic_concept_57_bandageLeg, TripIcon.ic_concept_58_cloudSnow, TripIcon.ic_concept_59_cloud, TripIcon.ic_concept_60_umbrella, TripIcon.ic_concept_61_sun, TripIcon.ic_concept_62_nightMoon, TripIcon.ic_concept_63_natural, TripIcon.ic_concept_64_google, TripIcon.ic_concept_65_instagram, TripIcon.ic_concept_66_facebook, TripIcon.ic_concept_67_youtube]
    
    init(migrationRepository: MigrationRepository, updateTripUseCase: UpdateTripUseCase) {
        self.migrationRepository = migrationRepository
        self.updateTripUseCase = updateTripUseCase
    }
    
    func execute() -> Result<Void, DBError> {
        let result = self.migrationRepository.loadV1Trips()

        switch result {
        case .success(let list):
            if list.isEmpty {
                return .success(Void())
            }
            
            for item in list {
                let _ = self.updateTripUseCase.execute(
                    id: item.id,
                    title: item.title,
                    content: item.intro,
                    iconId: (tripIcons.randomElement() ?? .ic_concept_01_smile).rawValue,
                    footprintIds: item.footprintIds,
                    startAt: item.fromDate,
                    endAt: item.toDate
                )
            }
            return .success(Void())
            
        case .failure(let failure):
            return .failure(failure)
        }
    }
}

