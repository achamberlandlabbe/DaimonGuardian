if (saving or loading) exit;

if global.doSave{
	global.doSave = false;
	
	var _struct = global.saveData;
	var _json = json_stringify(_struct);
	
	buffer_async_group_begin(global.saveDir);//Internal dir name
	buffer_async_group_option("slottitle", global.saveSlot);//Slot title name
	buffer_async_group_option("showdialog", 0);//Since it's autosave, don't show on PS
	
	savebuff = buffer_create(1, buffer_grow, 1);
	buffer_write(savebuff, buffer_string, _json);
	
	buffer_save_async(savebuff, savName, 0, buffer_get_size(savebuff));
	saveid = buffer_async_group_end();
	 
	saving = true;
}

if (saving or loading) exit;

if global.doLoad{
	global.doLoad = false;
	
	loadbuff = buffer_create(128, buffer_grow, 1);
	buffer_seek(loadbuff, buffer_seek_end, 0);
	buffer_seek(loadbuff, buffer_seek_start, 0);
	
	buffer_async_group_begin(global.saveDir);
	buffer_async_group_option("slottitle", global.saveSlot);//Slot title name
	buffer_async_group_option("showdialog", 0);//Don't show dialogs since it's autoload
	
	buffer_load_async(loadbuff, savName, 0, -1);// Say what we want to load and into which buffer
	
	loadid = buffer_async_group_end();// Actually start loading now
    
	loading = true;
}

if (saving or loading) exit;