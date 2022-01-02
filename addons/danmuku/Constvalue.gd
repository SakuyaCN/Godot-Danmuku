extends Node

var SELF_ENTER= "SELF_ENTER" # 自身加入直播间
var POPULAR_TOTAL= "POPULAR_TOTAL" # 人气
var INTERACT_WORD= "INTERACT_WORD" # 互动词
var ENTER_ROOM= "ENTER_ROOM" # 进入直播间
var FOLLOW_ROOM= "FOLLOW_ROOM" # 关注直播间
var SHARE_ROOM= "SHARE_ROOM" # 分享直播姬
var DANMU_MSG= "DANMU_MSG" # 弹幕消息
var SEND_GIFT= "SEND_GIFT" # 发送礼物（散装）
var COMBO_SEND= "COMBO_SEND" # 发送礼物（打包）
var LIVE_INTERACTIVE_GAME = "LIVE_INTERACTIVE_GAME" #Liwu
var ALL= "ALL" # 所有消息都会触发
var OTHER= "OTHER" # 其他类型

enum SocketCode{
	WS_OP_HEARTBEAT = 2, #心跳
	WS_OP_HEARTBEAT_REPLY= 3, #心跳回应 
	WS_OP_MESSAGE= 5, #弹幕,消息等
	WS_OP_USER_AUTHENTICATION= 7,#用户进入房间
	WS_OP_CONNECT_SUCCESS= 8, #进房回应
	WS_PACKAGE_HEADER_TOTAL_LENGTH= 16,#头部字节大小
	WS_PACKAGE_OFFSET= 0,
	WS_HEADER_OFFSET= 4,
	WS_VERSION_OFFSET= 6,
	WS_OPERATION_OFFSET= 8,
	WS_SEQUENCE_OFFSET= 12,
	WS_BODY_PROTOCOL_VERSION_NORMAL= 0,#普通消息
	WS_BODY_PROTOCOL_VERSION_BROTLI= 3,#brotli压缩信息
	WS_HEADER_DEFAULT_VERSION= 1,
	WS_HEADER_DEFAULT_OPERATION= 1,
	WS_HEADER_DEFAULT_SEQUENCE= 1,
	WS_AUTH_OK= 0,
	WS_AUTH_TOKEN_ERROR= -101
}

#编码
func encode(json:String,op):
	var data = json.to_utf8()
	var packetLen = 16 + data.size()
	var header = [0, 0, 0, 0, 0, 16, 0, 1, 0, 0, 0, op, 0, 0, 0, 1]
	writeInt(header, 0, 4, packetLen)
	header.append_array(data)
	return header

#写入字节
func writeInt(buffer, start, lens, value):
	var i = 0
	while(i < lens):
		buffer[start + i] = value / pow(256, lens - i - 1)
		i += 1

#读取字节
func readInt(buffer, start, lens):
	var result = 0
	var i = lens - 1
	while(i >= 0):
		result += pow(256, lens - i - 1) * buffer[start + i]
		i-=1
	return result as int

#解码
func decode(buffer:PoolByteArray):
	var v = buffer.subarray(16,buffer.size()-1)
	var data = v.decompress(1024*1024,File.COMPRESSION_DEFLATE)
	var last = data.size()
	if last > 0:
		var packetLen = readInt(data, 0, 4)
		var body = data.subarray(16, packetLen-1).get_string_from_utf8()
		return JSON.parse(body).result
