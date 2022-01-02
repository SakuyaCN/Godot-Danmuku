extends Reference

class_name EventGif

var giftName #礼物名称
var num #礼物数量
var uid #Uid
var uname #	用户名
var giftId #	礼物Id
var action #动作 (一般为"投喂")
var type #	瓜子类型; "silver"=银瓜子,"gold"=金瓜子
var price #价格

func loadEvent(event):
	var data = event.data
	giftName = data.gift_name#	礼物名称
	num = data.gift_num#	礼物数量
	uid = data.uid#	Uid
	uname = data.uname#	用户名
	price = data.price
	giftId = data.gift_id#	礼物Id
	type = data.type#	瓜子类型; "silver"=银瓜子,"gold"=金瓜子
	print("%s 送出礼物：%s" %[uname,giftName])
	
