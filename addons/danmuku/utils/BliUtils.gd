extends Node

#获取人气值
func getPopularity(buffer):
	var packetLen = Constvalue.readInt(buffer, 0, 4) - 16
	var pop = Constvalue.readInt(buffer, 16, packetLen)
	return pop as int
