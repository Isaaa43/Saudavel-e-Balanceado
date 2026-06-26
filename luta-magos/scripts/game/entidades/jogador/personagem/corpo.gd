class_name MeshCorpo
extends Node3D

# -- Cabeca --

@onready var cabeca_pivot: Node3D = $Cabeca/CabecaPivot
@onready var skeleton_3d: Skeleton3D = $Rig_Sapo/Armature/Skeleton3D

var camera : Camera3D :
	set(_cam):
		camera = _cam
		set_process(true)
		set_physics_process(true)

var cabeca_rot: float = 0.0

var bone_head_idx: int
var bone_head_base_rot : Quaternion

# -- Shaders --

@onready var frogger_skinned: MeshInstance3D = $Rig_Sapo/Armature/Skeleton3D/Frogger_Skinned

var _material_outline: ShaderMaterial
var mesh_instance_3d: MeshInstance3D



func _ready() -> void:
	bone_head_idx = skeleton_3d.find_bone("Head")
	bone_head_base_rot = skeleton_3d.get_bone_pose_rotation(bone_head_idx)
	
	mesh_instance_3d = frogger_skinned
	_material_outline = mesh_instance_3d.material_overlay
	
	set_process(false)
	set_physics_process(false)


func _process(delta: float) -> void:
	_process_camera(delta)

func esconder_mesh() -> void:
	mesh_instance_3d.hide()


# Shaders
# -----------------------------------------------------------------------------


# Cabeca
# -----------------------------------------------------------------------------
func _process_camera(_delta: float) -> void:
	# rodar a cabeca
	cabeca_rot = remap(camera.rotation.x, -PI/2, PI/2, -PI/6, PI/6)
	## hack para rotacionar o bone de cabeca
	#cabeca_pivot.rotation.x = cabeca_rot 
	cabeca_pivot.rotation.z = -cabeca_rot 

func _physics_process(_delta: float) -> void:
	# Get the current bone rotation
	var current_rot = skeleton_3d.get_bone_pose_rotation(bone_head_idx)

	# Convert cabeca_pivot's rotation to quaternion and combine with base rotation
	var pivot_rot = cabeca_pivot.quaternion
	var target_rot = bone_head_base_rot * pivot_rot  # Apply base rotation first, then pivot

	# Smoothly rotate towards it
	var new_rot = current_rot.slerp(target_rot, 0.1)
	skeleton_3d.set_bone_pose_rotation(bone_head_idx, new_rot)
