system.create_file('autokey.log', str(store.get_global_value('modifierPressed')))

if store.get_global_value('modifierPressed') == True:
    keyboard.send_keys('<ctrl>+b')
    store.set_global_value('modifierPressed', False)
else:
    keyboard.send_keys("<left>")
