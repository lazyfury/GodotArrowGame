extends Node2D
class_name Player

class PlayerProfile:
	var name:String
	
class PlayerState:
	var star:int
	
signal 子弹已发射(projetile:Projectile2D)
signal 子弹跟踪归位

var phantom_camera_2d: PhantomCamera2D
var camera_shake_2d: CameraShake2D

@onready var launcher: WeaponController = $Tower/Launcher
@onready var ability_cold_d_own: AbilityColdDOwn = $Tower/Launcher/AbilityColdDOwn
@onready var tower: Node2D = $Tower
const FIRE_PROJECTILE_2D = preload("uid://dfhb5ms6nrxly")

@export var spawner:MultiplayerSpawner

var profile:PlayerProfile
var state:PlayerState

func _enter_tree() -> void:
	set_multiplayer_authority(int(name))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	phantom_camera_2d = get_tree().get_first_node_in_group("PhantomCamera2D")
	camera_shake_2d = get_tree().get_first_node_in_group("CameraShake2D")
	launcher.phantom_camera_2d = phantom_camera_2d
	launcher.camera_shake_2d = camera_shake_2d
	
	launcher.connect("子弹已发射",子弹已发射.emit)
	launcher.connect("子弹跟踪归位",子弹跟踪归位.emit)
	launcher.connect("实例化子弹",func(dir,power):
		spawn_bullet.rpc(get_multiplayer_authority(),dir,power)
	)
	
	#print("实例化子弹 %d in %d" % [id,get_multiplayer_authority()])
	if multiplayer.has_multiplayer_peer() and multiplayer.multiplayer_peer is not OfflineMultiplayerPeer:
		spawner.spawn_function = func(data):
			var projectile = FIRE_PROJECTILE_2D.instantiate()
			projectile.setup(data['dir'],data['power'])
			projectile.set_multiplayer_authority(1)
			return projectile
			
	pass # Replace with function body.

@rpc("authority","call_local")
func spawn_bullet(id:int,dir:Vector2,power:float):
	if multiplayer.is_server() and get_multiplayer_authority():
		spawner.spawn({
			"dir":dir,
			"power":power
		})
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
