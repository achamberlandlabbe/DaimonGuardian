image_angle = irandom(359);

var scale = random_range(0.5, 1.5);
image_xscale = scale;
image_yscale = scale;

var sprite_array = [spr_tree1, spr_tree2]; // Add all your tree sprites here
sprite_index = sprite_array[irandom(array_length(sprite_array) - 1)];