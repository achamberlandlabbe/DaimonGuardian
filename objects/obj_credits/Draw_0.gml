var _credits = @"

Deathrig



Published and Developed by Hyperreality Entertainment


- Game Design -


Alexandre Chamberland Labbe


- Programming -


Alexandre Chamberland Labbe


- Visual Assets -


Alexandre Chamberland Labbe




- Music -





- SFX -



- Fonts -

Brian J. Bonislawsky

Steve Matteson


- Tools -


Input Library: Juju Adams, Alynne Keith, and friends


- Testers -


y-zo studio


- Specials thanks to -


Our families and friends, for their support

And you, for playing our game!


- Made with GameMaker -
";

//remplacer quand on pourra Marquez par Márquez

//var _yscale = string_height_ext(_credits, _sep*_scale, string_width(_credits))/sprite_get_height(spr_CreditsCapsule);
//var _xscale = string_width_ext(_credits, _sep*_scale, string_width(_credits))/sprite_get_width(spr_CreditsCapsule);

saveAlign(fa_center, fa_top); //custom fonction tu peux remplacer par draw_set_halign(fa_center) et draw_set_valign(fa_top), sinon je te passerai la fonction
draw_set_alpha(1);
saveFont(_font); //custom fonction aussi
_limit = _limitBase - string_height_ext(_credits, _sep*_scale, string_width(_credits));
txt(_credits, room_width/2, y, _scale, , c_white, , _sep);

loadFont(); //custom
loadAlign(); //custom