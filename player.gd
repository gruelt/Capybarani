extends CharacterBody2D

# Variables de mouvement
var gravity = 900
var jump_force = -500
var boost_factor = 1.1  # Multiplicateur si on saute au bon moment

# Variables de rotation
var rotation_speed = 5.0
var lateral_push = 400
var tucked_multiplier = 2.5 # Vitesse de rotation quand on est "groupé"

func start(pos):
	position = pos
	#$CollisionShape2D.disabled = false


func _physics_process(delta):
	# 1. Gestion de la Gravité
	if not is_on_floor():
		
		velocity.y += gravity * delta
		#velocity.x = 0
	
	# 2. Gestion du Saut et du Timing
	if is_on_floor():
		var bounce_direction = sin(rotation)
		print(bounce_direction)
		# On applique la vélocité horizontale
		velocity.x = (velocity.x/2 ) + bounce_direction * lateral_push
		print(rotation_degrees)
		#velocity.x = rotation_degrees  *2
		if Input.is_action_pressed("jump"): # "Espace" par défaut
			
			# Saut boosté si on appuie pile au contact
			if jump_force > -200  :
				jump_force= -300
			jump_force *= boost_factor 
			velocity.y = jump_force * boost_factor
		else:
			# Saut automatique normal au contact du trampoline
			jump_force /= boost_factor 
			velocity.y = jump_force

	# 3. Gestion des Rotations et du mode "Groupé"
	var current_rot_speed = rotation_speed
	
	$AnimatedSprite2D.animation = "jump"
	
	# Si on appuie sur "Bas", on tourne plus vite
	if Input.is_action_pressed("group"):
		current_rot_speed *= tucked_multiplier
		$AnimatedSprite2D.animation = "groupe"

	# Rotation gauche/droite
	if Input.is_action_pressed("left"):
		rotation -= current_rot_speed * delta
	if Input.is_action_pressed("right"):
		rotation += current_rot_speed * delta

	move_and_slide()
