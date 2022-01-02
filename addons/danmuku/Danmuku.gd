tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("DanmukuSocket", "Node", load("res://addons/danmuku/socket/WebSocket.gd"), load("res://addons/danmuku/icon.png"))


func _exit_tree():
	remove_custom_type("DanmukuSocket")
