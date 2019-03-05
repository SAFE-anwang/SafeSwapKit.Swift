import Foundation

class BlockHeadersMessage: IMessage {

    var requestId: Int
    var bv: BInt
    var headers: [BlockHeader]

    required init(data: Data) throws {
        let rlpList = try RLP.decode(input: data).listValue()

        guard rlpList.count > 2 else {
            throw MessageDecodeError.notEnoughFields
        }

        self.requestId = try rlpList[0].intValue()
        self.bv = try rlpList[1].bIntValue()

        var headers = [BlockHeader]()
        for rlpHeader in try rlpList[2].listValue() {
            headers.append(try BlockHeader(rlp: rlpHeader))
        }

        self.headers = headers
    }

    func encoded() -> Data {
        return Data()
    }

    func toString() -> String {
        return "HEADERS [requestId: \(requestId); bv: \(bv); headers: [\(headers.map{ $0.toString() }.joined(separator: ","))]]"
    }

}
