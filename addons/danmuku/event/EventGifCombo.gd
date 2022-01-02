extends Reference

class_name EventGifCombo

var giftName #礼物名称
var combo_num #礼物数量
var uid #Uid
var uname #	用户名
var giftId #	礼物Id
var action #动作 (一般为"投喂")

func loadEvent(event):
	var data = event.data
	giftName = data.gift_name#	礼物名称
	combo_num = data.combo_num#	礼物数量
	uid = data.uid#	Uid
	uname = data.uname#	用户名
	giftId = data.gift_id#	礼物Id
