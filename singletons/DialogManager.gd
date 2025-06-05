extends Node


@onready var text_box_scene = preload("res://scenes/textBox.tscn")

signal done

var dialog_lines: Array[String] = []
var current_line_index = 0

var text_box
var text_box_positon: Vector2

var is_active = false
var can_advance_line = false

var sfx: AudioStream

func start_dialog(position: Vector2, lines: Array[String], speech_sfx: AudioStream):
	print("STARING")
	if is_active:
		return
	
	dialog_lines = lines
	text_box_positon = position
	
	sfx = speech_sfx
	
	_show_text_box()
	is_active = true

func _show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(text_box)
	text_box.global_position = text_box_positon
	text_box.display_text(dialog_lines[current_line_index], sfx)
	can_advance_line = false


func _on_text_box_finished_displaying():
	can_advance_line = true


func _unhandled_input(event):
	if (event.is_action_pressed("advance_dialog") && is_active && can_advance_line):
		text_box.queue_free()
		
		current_line_index += 1
		if current_line_index >= dialog_lines.size():
			is_active = false
			current_line_index = 0
			print("emitting signal...")
			DialogManager.emit_signal("done")
			return
			
		_show_text_box()
