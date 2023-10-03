import Foundation

import RxCocoa
import RxSwift

struct RegisterMyBodyInfoViewModel: ViewModelType {
    let realmProvider: RealmProviderProtocol
    let workoutdataManager: WorkoutDoneDataManager
    let bodyInfoDataManager: BodyInfoDataManager
    init(realmProvider: RealmProviderProtocol) {
        self.realmProvider = realmProvider
        let realmManager = RealmManager(realm: try! realmProvider.makeRealm())
        self.workoutdataManager = WorkoutDoneDataManager(realmManager: realmManager)
        self.bodyInfoDataManager = BodyInfoDataManager(realmManager: realmManager)
    }

    struct Input {
        let loadView: Driver<Void>
        let weightInputText: Driver<String>
        let skeletalMusleMassInputText: Driver<String>
        let fatPercentageInputText: Driver<String>
        let saveButtonTapped: Driver<BodyInputData>
        let selectedDate: Driver<Int>
    }
    struct Output {
        let weightOutputText: Driver<String>
        let skeletalMusleMassOutputText: Driver<String>
        let fatPercentageOutputText: Driver<String>
        let saveData: Driver<Bool>
        let readWeightData: Driver<String>
        let readSkeletalMusleMassData: Driver<String>
        let readFatPercentageData: Driver<String>
    }
    /// id 값(string) -> Date(string)으로 변경
    func convertIDToDateString(dateInt: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        if let date = dateFormatter.date(from: String(dateInt)) {
            dateFormatter.dateFormat = "yyyy.MM.dd"
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
    
    /// 올바른 표기인지 확인
    func checkValidInputData(weight: Double, skeletalMusleMass: Double, fatPercentage: Double) -> Bool {
        if weight > 200 || skeletalMusleMass > 100 || fatPercentage > 100 {
            return false
        } else {
             return true
        }
    }
    
    func hasBodyInfoData(id: Int) -> Bool {
        return bodyInfoDataManager.readBodyInfoData(id: id) == nil ? false : true
    }
    
    func hasWorkoutDoneData(id: Int) -> Bool {
        return workoutdataManager.readWorkoutDoneData(id: id) == nil ? false : true
    }
    
    func transform(input: Input) -> Output {
        // 텍스트필드 입력 값 - 몸무게
        let weightText = input.weightInputText.map { value in
            return value
        }
        // 텍스트필드 입력 값 - 골격근량
        let skeletalMusleMassText = input.skeletalMusleMassInputText.map { value in
            return value
        }
        // 텍스트필드 입력 값 - 체지방량
        let fatPercentageText = input.fatPercentageInputText.map { value in
            return value
        }
        
        enum BodyInfoType {
            case weight
            case skeletalMusleMass
            case fatPercentage
            
            func getBodyInfoType(workoutDataManager: WorkoutDoneDataManager?, id: Int) -> Double? {
                switch self {
                case .weight:
                    return workoutDataManager?.readWorkoutDoneData(id: id)?.bodyInfo?.weight
                case .skeletalMusleMass:
                    return workoutDataManager?.readWorkoutDoneData(id: id)?.bodyInfo?.skeletalMuscleMass
                case .fatPercentage:
                    return workoutDataManager?.readWorkoutDoneData(id: id)?.bodyInfo?.fatPercentage
                }
            }
        }
        
        func readBodyInfoData(bodyInfoType: BodyInfoType, workoutDoneManager: WorkoutDoneDataManager) -> Driver<String> {
            return Driver<String>.combineLatest(input.loadView, input.selectedDate, resultSelector: { (_, date) in
                if hasBodyInfoData(id: date) {
                    let bodyData = bodyInfoType.getBodyInfoType(workoutDataManager: workoutDoneManager, id: date)
                    if let doubleBodyData = bodyData {
                        return String(doubleBodyData)
                    } else {
                        return ""
                    }
                } else {
                    return ""
                }
            })
        }
        
        // 골격근량 데이터 확인(read)
        let readSkeletalMusleMassData = readBodyInfoData(bodyInfoType: .skeletalMusleMass, workoutDoneManager: workoutdataManager)
        // 몸무게 데이터 확인(read)
        let readWeightData = readBodyInfoData(bodyInfoType: .weight, workoutDoneManager: workoutdataManager)
        /// 체지방량 데이터  확인(read)
        let readFatPercentageData = readBodyInfoData(bodyInfoType: .fatPercentage, workoutDoneManager: workoutdataManager)

        /// 데이터 입력(update or create)
        let inputData = Driver<Bool>.combineLatest(input.saveButtonTapped, input.selectedDate, resultSelector: { (inputData, id) in
            let convertData = self.convertIDToDateString(dateInt: id)
            guard let dateValue = convertData else { return false }
            let weightDouble = Double(inputData.weight ?? "")
            let fatPercentageDouble = Double(inputData.fatPercentage ?? "")
            let skeletalMusleMassDouble = Double(inputData.skeletalMusleMass ?? "")
            if self.checkValidInputData(weight: weightDouble ?? 0, skeletalMusleMass: skeletalMusleMassDouble ?? 0, fatPercentage: fatPercentageDouble ?? 0) {
                /// 형식이 맞는 경우
                /// 데이터가 존재하는 경우
                
                if hasWorkoutDoneData(id: id) {
                    /// workoutDone 데이터 존재하는 경우 - update
                    guard let workOutDoneData = workoutdataManager.readWorkoutDoneData(id: id) else { return false }
                    bodyInfoDataManager.updateBodyInfoData(
                        workoutDoneData: workOutDoneData,
                        weight: Double(inputData.weight ?? ""),
                        skeletalMuscleMass: Double(inputData.skeletalMusleMass ?? ""),
                        fatPercentage: Double(inputData.fatPercentage ?? ""))
                }
                /// 데이터가 존재하지 않는 경우 - create
                else {
                    bodyInfoDataManager.createBodyInfoData(
                        weight: Double(inputData.weight ?? ""),
                        skeletalMusleMass: Double(inputData.skeletalMusleMass ?? ""),
                        fatPercentage: Double(inputData.fatPercentage ?? ""),
                        date: dateValue,
                        id: id)
                }
                return true
            }
            /// 형식이 맞지 않는 경우
            else {
                return false
            }
        })
        return Output(
            weightOutputText: weightText,
            skeletalMusleMassOutputText: skeletalMusleMassText,
            fatPercentageOutputText: fatPercentageText,
            saveData: inputData,
            readWeightData: readWeightData,
            readSkeletalMusleMassData: readSkeletalMusleMassData,
            readFatPercentageData: readFatPercentageData)
    }
}
