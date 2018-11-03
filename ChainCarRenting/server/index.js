const startTime = new Date();

const Koa = require('koa2')
const axios = require('axios')
const app = new Koa();
const Router = require('koa-router')
const router = new Router()
const chalk = require('chalk')
const serve = require("koa-static")
const mount = require('koa-mount');

const service = require('./service')
const baas = require('./baas')
const db = require('./db')

const json = require('koa-json');
const bodyParser = require('koa-bodyparser');

app.use(bodyParser());
app.use(json());
app.use(async (ctx, next) => {
    console.log(ctx.request, ctx.request.body)
    await next()
    console.log(ctx.response)
})

router.post('/api/addMoney', async (ctx) => {
    const body = ctx.request.body;
    const address = body.address;
    const amount = body.amount;
    var txId = await service.addMoney(address, amount);
    var money = await service.getMoney(address);
    ctx.status = 200;
    ctx.body = {
        txId,
        money
    }
});

router.post('/api/getMoney', async (ctx) => {
    const body = ctx.request.body;
    const address = body.address;
    var money = await service.getMoney(address);
    ctx.status = 200;
    ctx.body = {
        money: money
    }
});

router.post('/api/rentStatus', async (ctx) => {
    const body = ctx.request.body;
    const id = body.id;
    let car = db.Car.find(t => t.cid == id);
    let info = db.Renting.find(t => t.cid == id);
    ctx.status = 200;
    const obj = Object.assign(car, info); 
    ctx.body = obj;
})

router.get('/api/allRent', async (ctx) => {
    ctx.status = 200;
    ctx.body = db.Renting;
})

router.get('/api/openDoor', async (ctx) => {
    await axios.default.get('http://172.20.10.11:5000/on')
    ctx.status = 200;
    ctx.body = "opened"
})

router.get('/api/closeDoor', async (ctx) => {
    await axios.default.get('http://172.20.10.11:5000/off')
    ctx.status = 200;
    ctx.body = "closed"
})

router.post('/api/endRent', async (ctx) => {
    const body = ctx.request.body;
    const id = body.cid;
    var result = await service.endRent(id)
    ctx.status = 200
    ctx.body = result
})

router.post('/api/makeRent', async (ctx) => {
    const body = ctx.request.body;
    const id = body.cid;
    const moneyTotal = body.moneyTotal
    var result = await service.makeRent(id, moneyTotal)
    ctx.status = 200;
    ctx.body = result
})

router.post('/api/confirmRent', async (ctx) => {
    const body = ctx.request.body;
    const id = body.id;
    var result = await service.confirmRent(id);
    ctx.status = 200;
    ctx.body = result;
})

router.post('/api/removeRent', async (ctx) => {
    const body = ctx.request.body;
    const id = body.id
    var result = await service.removeRent(id);
    ctx.status = 200;
    ctx.body = result;
})

router.get('/api/text', async (ctx) => {
    const textfiller = require('./textfiller');
    ctx.status = 200;
    ctx.body = textfiller
})

app.use(router.routes())
app.use(mount('/', serve(__dirname + '/public')));

app.listen('3000', async () => {
    console.log(chalk.default.green('Koa is listening on 3000...'));
    console.log(chalk.default.blue('Start time:', startTime.toLocaleString()));
});