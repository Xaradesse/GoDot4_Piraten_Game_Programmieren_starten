extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Rufen Sie die Schwerkraft aus den Projekteinstellungen ab, um sie mit RigidBody-Knoten zu synchronisieren.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animSprite = $AnimatedSprite2D

var hasSword = false

var isAttacking = false
var toggleAttack =  false

func checkAttack():
	if Input.is_action_just_pressed("ui_attack"):
		isAttacking = true
		$AttackArea/CollisionShape2D.disabled = false
		animSprite.play("attack1")
		if(animSprite.flip_h):
			$AttackArea/CollisionShape2D.position.x *= -1
			toggleAttack = true

func _physics_process(delta):
	
	var swordExtra = "_nos"
	
	if(hasSword):
		swordExtra = "_hs"
		
	if(isAttacking == false):
		
		# Fügen Sie die Schwerkraft hinzu.
		if not is_on_floor():
			velocity.y += gravity * delta

			if(velocity.y > 0):
			#fall_hs  true
			#fall_nos false		
				animSprite.play("fall" + swordExtra)
			else:
				animSprite.play("jump" + swordExtra)
		else:
			if(velocity.x == 0):
				animSprite.play("idle" + swordExtra)
			else:
				animSprite.play("run" + swordExtra)

		# Griffsprung.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Ermitteln Sie die Eingaberichtung und handhaben Sie die Bewegung/Verzögerung.
		# Als bewährte Vorgehensweise sollten Sie UI-Aktionen durch benutzerdefinierte Gameplay-Aktionen ersetzen.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
			# Prüfung, ob Character nach links oder rechts geht und dann entsprechend Flip_h true/false
			if(velocity.x < 0):
				animSprite.flip_h = true
			else:
				animSprite.flip_h = false
			
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		if(hasSword):
			checkAttack()

	move_and_slide()


func _on_animated_sprite_2d_animation_finished():
	isAttacking = false
	$AttackArea/CollisionShape2D.disabled = true
	if(toggleAttack):
		$AttackArea/CollisionShape2D.position.x *= -1
		toggleAttack = false
