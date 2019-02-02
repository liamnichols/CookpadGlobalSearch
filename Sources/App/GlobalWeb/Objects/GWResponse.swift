import Foundation

struct GWResponse<GWResult: Decodable>: Decodable {

    let result: GWResult

    let extra: GWExtra
}
