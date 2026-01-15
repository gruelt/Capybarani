extends CharacterBody2D

# Variables de mouvement
var gravity = 900
var jump_force = -500
var boost_factor = 1.5  # Multiplicateur si on saute au bon moment

# Variables de rotation
var rotation_speed = 5.0
var tucked_multiplier = 2.5 # Vitesse de rotation quand on est "groupé"

func _physics_process(delta):
	# 1. Gestion de la Gravité
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# 2. Gestion du Saut et du Timing
	if is_on_floor():
		if Input.is_action_just_pressed("jump"): # "Espace" par défaut
			# Saut boosté si on appuie pile au contact
			velocity.y = jump_force * boost_factor
		else:
			# Saut automatique normal au contact du trampoline
			velocity.y = jump_force

	# 3. Gestion des Rotations et du mode "Groupé"
	var current_rot_speed = rotation_speed
	
	# Si on appuie sur "Bas", on tourne plus vite
	if Input.is_action_pressed("down"):
		current_rot_speed *= tucked_multiplier
		scale = Vector2(0.7, 0.7) # Effet visuel "groupé"
	else:
		scale = Vector2(1, 1) # Taille normale

	# Rotation gauche/droite
	if Input.is_action_pressed("left"):
		rotation -= current_rot_speed * delta
	if Input.is_action_pressed("right"):
		rotation += current_rot_speed * delta

	move_and_slide()
