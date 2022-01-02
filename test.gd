extends Control

onready var danmuku = $DanmukuSocket

# Called when the node enters the scene tree for the first time.
func _ready():
	danmuku.connect("popValueSet",self,"_popValueSet")
	danmuku.connect("dmSend",self,"_dmSend")
	danmuku.connect("gifSend",self,"_gifSend")
	danmuku.connect("comboSend",self,"_comboSend")

func _popValueSet(_pop):
	$pop.text = "当前人气：%s" %_pop
	
func _dmSend(bean:EventDanmu):
	$msg.text += "%s 发送弹幕：%s\n" %[bean.userCls.uname,bean.chatCls.content]
	
func _gifSend(bean:EventGif):
	$gift.text += "%s 送出礼物：%s x %s \n" %[bean.uname,bean.giftName,bean.num]
	
func _comboSend(bean:EventGifCombo):
	$gift.text += "%s 礼物连击：%s x %s \n" %[bean.uname,bean.giftName,bean.combo_num]
