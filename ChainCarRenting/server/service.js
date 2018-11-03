var baas = require('./baas');
var db = require('./db')

const MAIN_ADDRESS = "ff984ea08dc56017caea6f336845d19e00e7ee7c"
const HOST_ADDRESS = "25f4724c2dac37e0cd7bd1c4410a42cacc165c2f"

async function addMoney(address, amount) {
    return await baas.transfer(MAIN_ADDRESS, address, amount);
}

async function getMoney(address) {
    var result = await baas.getWallet(address);
    return result.balance.ZIG;
}

async function makeRent(id, moneyTotal) {
    var car = db.Car.find(t => t.cid == id);
    var renting = {
        cid: parseInt(id),
        moneyTotal: parseInt(moneyTotal),
        state: 'waiting',
        beginTime: new Date()
    }
    db.Renting.push(renting);
    return db.Renting;
}

async function confirmRent(id) {
    var car = db.Car.find(t => t.cid == id);
    var renting = db.Renting.find(t => t.cid == id);
    renting.state = "renting";
    console.log(baas.USER_ADDRESS_NOI, car.address)
    await baas.transfer(baas.USER_ADDRESS_NOI, car.address, renting.moneyTotal)
    return db.Renting;
}

async function endRent(id) {
    var car = db.Car.find(t => t.cid == id)
    var renting = db.Renting.find(t => t.cid == id)

    console.log(car, renting)

    var d = new Date();
    var days = d.getDay() - renting.beginTime.getDay();
    var money = (days+1) * car.moneyCost;
    var moneyTotal = renting.moneyTotal;
    var moneyLeft = moneyTotal - money
    renting.state = "waiting";
    renting.moneyLeft = moneyLeft;
    return {
        moneyLeft,
        moneyUsage: money,
        renting: db.Renting
    }
}

async function removeRent(id) {
    var car = db.Car.find(t => t.cid == id)
    var renting = db.Renting.find(t => t.cid == id)
    var index = db.Renting.indexOf(renting);

    // var moneyLeft = await getMoney(car.address)
    await baas.transfer(car.address_noi, baas.USER_ADDRESS, renting.moneyLeft)
    await baas.transfer(car.address_noi, HOST_ADDRESS, renting.moneyUsage)

    db.Renting.splice(index, 1);
    return true
}

module.exports = {
    addMoney,
    getMoney,
    makeRent,
    confirmRent,
    endRent,
    removeRent
}
