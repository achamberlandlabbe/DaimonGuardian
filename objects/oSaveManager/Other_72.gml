// oSaveManager Async - Save/Load Event

var ident = async_load[? "id"];

if (ident == saveid and saving)
{
	buffer_delete(savebuff);
	saving = false;
}
else if (ident == loadid and loading)
{
	buffer_seek(loadbuff, buffer_seek_end, 0);
	var buffer_size = buffer_tell(loadbuff);
	if buffer_size > 1{
		buffer_seek(loadbuff, buffer_seek_start, 0);
		var _json = buffer_read(loadbuff, buffer_string);
		buffer_delete(loadbuff);
		var _struct = json_parse(_json);
		var _structNames = struct_get_names(_struct);
		for (var i = 0; i < array_length(_structNames); i++){
			var _k = _structNames[i];
			var _v = _struct[$ _k];
			if struct_exists(global.saveData, _k)
				struct_set(global.saveData, _k, _v);
		}
		loader();
		loading = false;
		
	}
}