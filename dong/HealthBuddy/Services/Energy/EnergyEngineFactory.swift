import Foundation

/// 能量引擎工厂 - Phase 1 返回公式引擎，未来可切换为 CoreML
enum EnergyEngineFactory {
    static func create() -> EnergyEngineProtocol {
        // TODO: Phase future - 尝试加载 CoreML 模型，失败则回退公式
        // if let mlEngine = try? CoreMLEnergyEngine() { return mlEngine }
        return FormulaEnergyEngine()
    }
}
