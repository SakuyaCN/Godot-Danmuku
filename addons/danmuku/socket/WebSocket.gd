extends Node

export var websocket_url = "wss://broadcastlv.chat.bilibili.com:2245/sub"
export var roomid = 139

var _client = WebSocketClient.new()
var heart_timer:Timer

#人气值
var pop = 0

signal popValueSet(pop)
signal dmSend(bean)
signal gifSend(bean)
signal comboSend(bean)

func _init():
	heart_timer = Timer.new()
	heart_timer.wait_time = 30
	heart_timer.connect("timeout",self,"_heart_packet")

func _ready():
	add_child(heart_timer)
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	_client.connect("data_received", self, "_on_data")
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)

func _closed(was_clean):
	print("Closed, clean: ", was_clean)
	set_process(false)

func _connected(proto = ""):
	var body = Constvalue.encode(to_json({"roomid": roomid }), 7)
	_client.get_peer(1).put_packet(body)

func _on_data():
	var buffer = _client.get_peer(1).get_packet()
	var ver = Constvalue.readInt(buffer, 6, 2)
	var op = Constvalue.readInt(buffer, 8, 4)
	match ver:
		1:#心跳包发送
			match op:
				Constvalue.SocketCode.WS_OP_CONNECT_SUCCESS:
					_heart_packet()
					heart_timer.start()
				Constvalue.SocketCode.WS_OP_HEARTBEAT_REPLY:
					pop = BliUtils.getPopularity(buffer)
					emit_signal("popValueSet",pop)
		2:#房间消息
			if op == Constvalue.SocketCode.WS_OP_MESSAGE:
				var data = Constvalue.decode(buffer)
				match data.cmd:
					Constvalue.INTERACT_WORD:#加入
						pass
					Constvalue.DANMU_MSG:#弹幕
						var bean = EventDanmu.new()
						bean.loadEvent(data)
						emit_signal("dmSend",bean)
					Constvalue.LIVE_INTERACTIVE_GAME:#礼物
						var bean = EventGif.new()
						bean.loadEvent(data)
						emit_signal("gifSend",bean)
					Constvalue.COMBO_SEND:#礼物连击
						var bean = EventGifCombo.new()
						bean.loadEvent(data)
						emit_signal("comboSend",bean)

func _process(delta):
	_client.poll()

#发送心跳包
func _heart_packet():
	var body = Constvalue.encode(to_json({}), 2)
	_client.get_peer(1).put_packet(body)
	print("发送心跳包")
