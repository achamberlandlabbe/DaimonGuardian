/// obj_staffExplosion Create Event
image_speed = 0;
image_alpha = 0.7;
duration = 5;
timer = 0;
explosion_damage = 0; // Damage will be set when created
hit_enemies = ds_list_create();

playSFX(snd_explosion, random_range(0.9, 1.1), 1, 1);