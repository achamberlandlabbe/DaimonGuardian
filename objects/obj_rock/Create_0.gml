image_angle = irandom(359);

var scale = random_range(0.5, 1.5);
image_xscale = scale;
image_yscale = scale;

var sprite_array = [spr_rock1, spr_rock2, spr_rock3, spr_rock4, spr_rock5]; 
sprite_index = sprite_array[irandom(array_length(sprite_array) - 1)];