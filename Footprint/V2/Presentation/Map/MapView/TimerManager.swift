//
//  TimerManager.swift
//  Footprint
//
//  Created by sandy on 11/26/24.
//

import Foundation

class TimerManager {
    private var timer: Task<Void, Never>? = nil
    var task: (() -> ())? = nil
    
    init() {
        
    }
    
    func setTask(task: @escaping () -> Void) {
        self.task = task
    }
    
    // 타이머를 시작하는 함수
    func startTimer() {
        timer = Task {
            // 2초 대기
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            // 특정 함수 실행
            if !Task.isCancelled {
                task?()
            }
        }
    }

    // 타이머를 종료하는 함수
    func stopTimer() {
        timer?.cancel()
        timer = nil
        print("타이머가 종료되었습니다.")
    }

    // 타이머를 재실행하는 함수
    func restartTimer() {
        stopTimer() // 기존 타이머 종료
        startTimer() // 새로운 타이머 시작
    }
}
