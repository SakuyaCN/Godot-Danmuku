extends Reference

class_name EventDanmu

var userCls:UserInfo#用户信息
var fansCls:FansModel#用户粉丝排
var chatCls:ChatModel#聊天信息

func loadEvent(msg):
	var user = msg.info[2]
	userCls = UserInfo.new(user[0],user[1])
	var fans = msg.info[3]
	var chat = JSON.parse(msg.info[0][15].extra).result
	chatCls = ChatModel.new(chat.content,chat.send_from_me,chat.font_size,chat.color)
	print("%s 发送弹幕：%s" %[userCls.uname,chatCls.content])
	if fans.size() > 0:
		fansCls = FansModel.new(fans[3],fans[1],fans[2])
	
class UserInfo:
	var id#UUID
	var uname#昵称
	
	func _init(_id,_uname):
		id = _id
		uname = _uname

class FansModel:
	var fansCard#牌子名称
	var fansMaster#谁的牌子
	var fansRoomId#牌子所属房间号
	
	func _init(_fansRoomId,_fansCard,_fansMaster):
		fansRoomId = _fansRoomId
		fansCard = _fansCard
		fansMaster = _fansMaster

class ChatModel:
	var send_from_me:bool#是否来自本人
	var font_size#弹幕大小
	var content#聊天内容
	var color#颜色
	
	func _init(_content,_font_size,_send_from_me,_color):
		content = _content
		font_size = _font_size
		send_from_me = _send_from_me
		color = _color
