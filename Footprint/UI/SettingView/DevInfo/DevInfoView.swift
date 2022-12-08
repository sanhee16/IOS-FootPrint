//
//  DevInfoView.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/12/08.
//


import SwiftUI

struct DevInfoView: View {
    typealias VM = DevInfoViewModel
    public static func vc(_ coordinator: AppCoordinator, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.init(view, completion: completion)
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                Topbar("개발자 정보", type: .back) {
                    vm.onClose()
                }
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center, spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Sandy")
                                .font(.kr16b)
                                .foregroundColor(.gray100)
                            Text("ios, aos 모바일 개발자")
                                .font(.kr13r)
                                .foregroundColor(.gray100)
                        }
                        Spacer()
                        Image("sandy")
                            .resizable()
                            .scaledToFit()
                            .frame(both: 50)
                            .clipShape(Circle())
                    }
                    .padding(EdgeInsets(top: 10, leading: 24, bottom: 10, trailing: 24))
                    .background(Color.black.opacity(0.06))
                    
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            description("기능 문의, 피드백, 버그 신고, 질문 모두 환영입니다.\n설정 > 문의하기를 통해 메일을 남겨주세요.")
                                .padding(.top, 12)
                            Group {
                                title("👩‍💻 프로젝트 이력")
                                description("온스터디 모바일 앱 시리즈 개발")
                                description("영어회화 100일의 기적 백앤드 서버 개발")
                                description("온스터디 서비스 관리 솔루션 개발")
                                description("캔디플러스 모바일 앱 개발")
                                
                                title("💡 이 프로젝트에 사용한 기술")
                                description("swiftui, mvvm, cooridnator pattern, realm, combine")
                            }
                            Group {
                                title("⌨ 개발자 스택")
                                description("ios, aos")
                                description("Language: swift, kotlin, java, python, c, c++, js")
                                description("DB: realm, room, mysql, sqlite")
                                
                                title("🖥 github (링크 클릭시 이동합니다!)")
                                description(vm.git)
                                    .onTapGesture {
                                        vm.onClickUrl()
                                    }
                                title("ℹ Reference")
                                description("이미지: https://icons8.com/")
                                description("지도 api: naver Mobile Dynamic Map")
                            }
                        }
                        .padding(.top, 2)
                    }
                    .contentShape(Rectangle())
                    .frame(width: geometry.size.width, alignment: .leading)
                }
                .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func title(_ title: String) -> some View {
        return Text(title)
            .font(.kr14b)
            .foregroundColor(.gray100)
            .padding(EdgeInsets(top: 24, leading: 8, bottom: 10, trailing: 8))
    }
    private func description(_ description: String) -> some View {
        return Text(description)
            .font(.kr13r)
            .foregroundColor(.gray90)
            .padding(.leading, 6)
    }
}
