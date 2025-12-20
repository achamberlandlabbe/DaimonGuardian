/// obj_dustParticle Draw Event

// Calculate alpha based on remaining life (fade out)
var alpha = life / max_life;

// Draw small circle/point for dust particle
draw_set_color(dust_color);
draw_set_alpha(alpha);
draw_circle(x, y, particle_size, false);

// Reset alpha
draw_set_alpha(1);