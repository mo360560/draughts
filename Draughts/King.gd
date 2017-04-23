extends "res://Stone.gd"

func _ready():
	black = preload("res://king_black.png")
	white = preload("res://king_white.png")
	pass

func legal_move(target_square):
	if (target_square == null):
		return false
	if (target_square.stone != null):
		return false
	if self.is_jump_correct(target_square):
				board.delete_stone(Vector2((target_square.get_pos().x + current_square.get_pos().x) / 2, (target_square.get_pos().y + \
						current_square.get_pos().y) / 2))
				return true
	if abs(int(target_square.get_pos().x / square_size) - \
		int(current_square.get_pos().x / square_size)) != 1 or \
		abs(int(target_square.get_pos().y / square_size) - int(current_square.get_pos().y / square_size)) != 1:
			return false
	if board.can_anyone_jump():
		print('możesz przeskoczyć')
		return false
	return true
	
func is_jump_correct(target_square):
	return (target_square.stone == null and \
		abs(int(target_square.get_pos().x / square_size) - \
		int(current_square.get_pos().x / square_size)) == 2 and \
		board.squares[(int(target_square.get_pos().x / square_size) + int(current_square.get_pos().x / square_size)) / 2 ][(int(target_square.get_pos().y / square_size) + \
		int(current_square.get_pos().y / square_size)) / 2 ].stone != null and \
		board.squares[(int(target_square.get_pos().x / square_size) + int(current_square.get_pos().x / square_size)) / 2 ][(int(target_square.get_pos().y / square_size) + \
		int(current_square.get_pos().y / square_size)) / 2].stone.color != current_square.stone.color) and \
		(abs(int(target_square.get_pos().y / square_size) - \
		int(current_square.get_pos().y / square_size)) == 2)