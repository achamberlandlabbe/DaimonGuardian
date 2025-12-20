/// obj_dustParticle Create Event

// Particle physics
// hspeed and vspeed are set by the spawner

// Lifespan (in frames at 60fps)
max_life = irandom_range(30, 90); // 0.5 to 1.5 seconds
life = max_life;

// Random dust color variation (brownish/tan)
dust_color = choose(#c4a57b, #b39668, #d4b88e, #a08060);

// Size (small particles, 2-3 pixels)
particle_size = random_range(1.5, 3);

// Depth (below vehicle but above ground)
depth = 10;