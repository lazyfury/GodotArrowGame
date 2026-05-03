extends Node
class_name PeerGameManager



@export var start_btn:Button
@export var join_btn:Button

@onready var multiplayer_spawner: MultiplayerSpawner = $MultiplayerSpawner
@onready var multiplayer_spawner_bullet: MultiplayerSpawner = $MultiplayerSpawnerBullet

const PLAYER = preload("uid://c7jobiyjdti6j")

var players:Dictionary[int,Player] = {}

var local_player_added:bool


func hosting():
	var peer:ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var err = peer.create_server(12876)
	if err != OK:
		push_error(err)
		return
	multiplayer.multiplayer_peer = peer
	#init_plyer(str(multiplayer.get_unique_id()))
	multiplayer_spawner.spawn(multiplayer.get_unique_id())
	pass

func join():
	var peer:ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var err = peer.create_client("127.0.0.1",12876)
	if err != OK:
		push_error(err)
		return
	multiplayer.multiplayer_peer = peer
	pass

func _on_peer_connected(id:int):
	print("加入房间",id)
	if multiplayer.is_server():
		if not players.has(id):
			multiplayer_spawner.spawn_function = init_plyer
			multiplayer_spawner.spawn(id)
	pass

	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#init_plyer()
	multiplayer_spawner.spawn_function = init_plyer
	multiplayer.peer_connected.connect(_on_peer_connected)
	
	start_btn.pressed.connect(func():
		hosting()
	)
	join_btn.pressed.connect(func():
		join()
	)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
var init_offset:Vector2 = Vector2.ZERO
func init_plyer(id:int)->Node2D:
	var player = PLAYER.instantiate()
	player.name = "%d" % id
	player.spawner = $MultiplayerSpawnerBullet
	#player.global_position = init_position.global_position + init_offset
	init_offset += Vector2(40,0)
	#player_panent.add_child(player)
	players.set(id,player)
	local_player_added = true
	print("init:spawner %d in %d " % [id,multiplayer.get_unique_id()])
	return player

func get_local_player()->Player:
	if not multiplayer.has_multiplayer_peer():
		return null
	if players.has(multiplayer.get_unique_id()):
		return players.get(multiplayer.get_unique_id())
	return null
