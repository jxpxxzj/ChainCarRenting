package main

import (
	"fmt"
	"encoding/json"
	"math/big"
	"strconv"
	"github.com/ziggurat/zigledger/core/chaincode/shim"
	pb "github.com/ziggurat/zigledger/protos/peer"
)

const (
	// wallet base
	Transfer			string = "transfer"
	GetWallet			string = "getWallet"
	GetTransaction		string = "getTransaction"

	// text and assign
	GenerateText		string = "generateText"
	CreateSign			string = "createSign"
	UpdateText			string = "updateText"
	GenerateKey			string = "generateKey"

	// assert management
	AddCar				string = "addCar"
	EditCar				string = "editCar"
	RemoveCar			string = "removeCar"
)

type assetChaincode struct {
}

type tranState struct {
	Sender	string	`json:"sender"`
	Address	string	`json:"address"`
	Amount	*big.Int	`json:"amount"`
}

type text struct {
	Car 		string 	`json:"car"`
	BeginTime 	int64	`json:"beginTime"`
	EndTime		int64	`json:"endTime"`
	HostSign	string	`json:"hostSign"`
	RenterSign	string	`json:"renterSign"`
}

type sign struct {
	TextTxId	string	`json:"textTxId"`
	Assigner	string	`json:"assigner"`
}

func main() {
	err := shim.Start(new(assetChaincode))
	if err != nil {
		fmt.Printf("Error starting assetChaincode: %s", err)
	}
}

func (t *assetChaincode) Init(stub shim.ChaincodeStubInterface) pb.Response {
	fmt.Println("assetChaincode Init.")
	return shim.Success([]byte("Init success."))
}

func (t *assetChaincode) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	fmt.Println("assetChaincode Invoke.")
	function, args := stub.GetFunctionAndParameters()

	switch function {
	case Transfer:
		return t.transfer(stub, args)
	case GetWallet:
		return t.getWallet(stub, args)
	case GetTransaction:
		return t.getTransaction(stub, args)
	case GenerateText:
		return t.generateText(stub, args)
	case UpdateText:
		return t.updateText(stub, args)
	// case GenerateKey:
	// 	return t.generateKey(stub, args)
	case CreateSign:
		return t.assignKey(stub, args)
	}

	return shim.Error("invaild invoke function name")
}

func (t *assetChaincode) transfer(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	address := args[0]
	amount := big.NewInt(0)
	_, good := amount.SetString(args[1], 10)
	if !good {
		return shim.Error("Expecting integer value for amount")
	}

	err := stub.Transfer(address, "ZIG", amount)

	if err != nil {
		shim.Error("ERROR WHILE TRANSFER")
	}

	txId := stub.GetTxID()
	sender, err := stub.GetSender()

	if err != nil {
		shim.Error("ERROR WHILE GETSENDER")
	}

	tx := &tranState{sender, address, amount}
	txJson, err := json.Marshal(tx)

	if err != nil {
		shim.Error("ERROR WHILE MARSHAL")
	}

	err = stub.PutState(txId, txJson)

	if err != nil {
		shim.Error(err.Error())
	}

	return shim.Success([]byte(txId))
}

func (t* assetChaincode) getTransaction(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	txId := args[0]

	bytedata, err := stub.GetState(txId)

	if err != nil {
		shim.Error("ERROR WHILE GETSTATE")
	}

	return shim.Success(bytedata)
}

// query
func (t *assetChaincode) getWallet(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	address := args[0]

	wallet, err := stub.GetAccount(address)

	if err != nil {
		return shim.Error("error while fetch wallet")
	}

	bytedata, err := json.Marshal(wallet)

	if err != nil {
		return shim.Error("ERROR WHILE MARSHAL")
	}

	return shim.Success(bytedata)
}

// arg1: car id
// arg2: begin time
// arg3: end time
// sender: init wallet
func (t *assetChaincode) generateText(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	sender, err := stub.GetSender()
	if err != nil {
		return shim.Error("INVALID SENDER")
	}

	err = stub.Transfer(sender, "ZIG", big.NewInt(1))

	if err != nil {
		return shim.Error("TRANSFER FAILED")
	}

	txId := stub.GetTxID()

	car := args[0] //arg0
	beginTime, err := strconv.ParseInt(args[1], 10, 64) //arg1
	if err != nil {
		return shim.Error("PARSE INT FAILED")
	}

	endTime, err := strconv.ParseInt(args[2], 10, 64) //arg2
	if err != nil {
		return shim.Error("PARSE INT FAILED")
	}

	text := &text{car, beginTime, endTime, "", ""}
	textJson, err := json.Marshal(text)

	if err != nil {
		return shim.Error("JSON MARSHAL FAILED")
	}

	err = stub.PutState(txId, textJson)

	if err != nil {
		return shim.Error("PUTSTATE FAILED")
	}

	return shim.Success([]byte(txId))
}

// arg[0]: textId
// arg[1]: signerType
// arg[2]: signKey
func (t *assetChaincode) updateText(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	// get stub.GetSender() as signer
	// singer, err := stub.GetSender()
	// if err != nil {
	//	return shim.Error("INVAILD SENDER")
	//}

	// get GetState(textId) as text
	textId := args[0]
	textByte, err := stub.GetState(textId)
	var text text
	json.Unmarshal(textByte, &text)

	singerType := args[1]
	signKey := args[2]

	if singerType == "host" {
		text.HostSign = signKey
	}
	if singerType == "renter" {
		text.RenterSign = signKey
	}

	textJson, err := json.Marshal(text)
	if err != nil {
		return shim.Error("JSON MARSHAL ERROR")
	}

	err = stub.PutState(textId, textJson)

	if err != nil {
		return shim.Error("PUTSTATE ERROR")
	}

	return shim.Success([]byte(textId))
}

// arg[0]: text transaction id
// sender: user
func (t *assetChaincode) assignKey(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	sender, err := stub.GetSender()
	if err != nil {
		return shim.Error("INVALID SENDER")
	}

	err = stub.Transfer(sender, "ZIG", big.NewInt(1))

	if err != nil {
		return shim.Error("TRANSFER FAILED")
	}

	txId := stub.GetTxID()

	textTxId := args[0]

	assign := &assign{textTxId, sender}
	assignJson, err := json.Marshal(assign)
	if err != nil {
		return shim.Error("JSON MARSHAL ERROR")
	}

	err = stub.PutState(txId, assignJson)

	if err != nil {
		return shim.Error("PUTSTATE FAILED")
	}

	// updateText

	return shim.Success([]byte(txId))
}