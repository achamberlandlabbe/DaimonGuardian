saving = false;//boolean to know if currently saving and exiting step event
loading = false;//boolean to know if currently loading and exiting step event

savebuff = -1;//save buffer
loadbuff = -1;//load buffer
saveid = -1;//save buffer id
loadid = -1;//load buffer id

savName = game_project_name + ".txt";

#region FIRST LOADING
var _filename = global.saveDir + "/" + savName;
if file_exists(_filename){
	var _buffer = buffer_load(_filename);
	var _json = buffer_read(_buffer, buffer_string);
	buffer_delete(_buffer);
	var _struct = json_parse(_json);
	var _structNames = struct_get_names(_struct);
	for (var i = 0; i < array_length(_structNames); i++){
		var _k = _structNames[i];
		var _v = _struct[$ _k];
		if struct_exists(global.saveData, _k)
			struct_set(global.saveData, _k, _v);
	}
	loader();
}
finishedFirstLoading = true;
#endregion