let axios = require('axios')

const CHAIN_NAME = 'test1'
const CHAINCODE_NAME = 'test27'
const API_KEY = '5af5908c292d370012e7f64b'
const USER_ADDRESS = 'icbda6cc538e90190230df486c948b84c4c66f7fd'
const USER_ADDRESS_NOI = 'cbda6cc538e90190230df486c948b84c4c66f7fd'

const INVOKE_URL = `https://baas.ziggurat.cn/public-api/call/${CHAIN_NAME}/${CHAINCODE_NAME}/invoke?apikey=${API_KEY}`
const QUERY_URL = `https://baas.ziggurat.cn/public-api/call/${CHAIN_NAME}/${CHAINCODE_NAME}/query?apikey=${API_KEY}`
const BLOCK_URL = `https://baas.ziggurat.cn/public-api/chain/${CHAIN_NAME}/blocks?apikey=${API_KEY}`

async function findTxId(sender, address) {
    try {
        var blocks = await axios.default.get(BLOCK_URL, {
            headers: {
                "Content-Type": "applicaton/json"
            }
        });
        for(const element of blocks.data) {
            const tran = element.transactions[0];
            if (tran.sender.indexOf(sender) > -1) {
                if (tran.args[1] == address) {
                    return element.transactions[0].id;
                }
            }
        };
    } catch (error) {
        console.log("failed to fetch tx id")
        return ""
    }
}

async function transfer(sender, address, amount) {
    const req = {
        func: 'transfer',
        params: [address, String(amount)],
        account: sender
    }
    let result = null;
    try {
        result = await axios.default.post(INVOKE_URL, req)
    } catch (error) {
        console.log(error)
    }
    // const txId = await findTxId(sender,address)
    return "txId"
}

async function getWallet(address) {
    const req = {
        func: 'getWallet',
        params: [address]
    }
    const result = await axios.default.post(QUERY_URL, req);
    console.log(result.data)
    return JSON.parse(result.data.payloads[0])
}

async function getTransaction(txId) {
    const req = {
        func: 'getTransaction',
        params: [txId]
    }
    const result = await axios.default.post(QUERY_URL, req);
    return result.data.payloads;
}

module.exports = {
    transfer,
    getWallet,
    getTransaction,
    USER_ADDRESS,
    USER_ADDRESS_NOI
}