import Foundation

class HelloMessage: IMessage {

    let p2pVersion: Int
    let clientId: String
    let capabilities: [Capability]
    let port: Int
    let peerId: Data

    init(peerId: Data, port: UInt32, capabilities: [Capability]) {
        self.p2pVersion = 4
        self.clientId = "EthereumKit"
        self.capabilities = capabilities
        self.port = Int(port)
        self.peerId = peerId
    }

    required init(data: Data) throws {
        let rlpList = try RLP.decode(input: data).listValue()

        guard rlpList.count > 4 else {
            throw MessageDecodeError.notEnoughFields
        }

        p2pVersion = try rlpList[0].intValue()
        clientId = try rlpList[1].stringValue()
        capabilities = try rlpList[2].listValue().map{ Capability(name: try $0.listValue()[0].stringValue(), version: try $0.listValue()[1].intValue()) }
        port = try rlpList[3].intValue()
        peerId = rlpList[4].dataValue
    }

    func encoded() -> Data {
        let toEncode: [Any] = [
            p2pVersion,
            clientId,
            capabilities.map{ $0.toArray() },
            port,
            peerId
        ]

        return RLP.encode(toEncode)
    }

    func toString() -> String {
        return "HELLO [version: \(p2pVersion); clientId: \(clientId); capabilities: \(capabilities.map { $0.toString() }.joined(separator: ", ")); peerId: \(peerId.toHexString()); port: \(port)]"
    }

}
