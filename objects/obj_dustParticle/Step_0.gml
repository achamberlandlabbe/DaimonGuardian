/// obj_dustParticle Step Event

// Apply friction (dust slows down in air)
hspeed *= 0.92;
vspeed *= 0.92;

// Slight upward drift (dust billows up slightly)
vspeed -= 0.05;

// Decrease life
life--;

// Destroy when life runs out
if (life <= 0) {
    instance_destroy();
}