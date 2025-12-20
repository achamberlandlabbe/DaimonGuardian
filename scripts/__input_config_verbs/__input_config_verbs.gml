function __input_config_verbs()
{
    return {
        keyboard_and_mouse:
        {
            // Menu navigation - both WASD and arrow keys
            up: [input_binding_key(vk_up), input_binding_key("W")],
            down: [input_binding_key(vk_down), input_binding_key("S")],
            left: [input_binding_key(vk_left), input_binding_key("A")],
            right: [input_binding_key(vk_right), input_binding_key("D")],
            
            // System controls
            accept: [input_binding_key(vk_enter), input_binding_key(vk_space), input_binding_mouse_button(mb_left)],
            back: [input_binding_key(vk_backspace), input_binding_mouse_button(mb_right)],
            pause: input_binding_key(vk_escape),
            rigBuild: input_binding_key("R"),
            start: input_binding_key(vk_enter),
            attack: input_binding_mouse_button(mb_left),  // Left click for attack
            
            // Other existing bindings
            sell: input_binding_key(vk_delete),
            confirm:[input_binding_key(vk_lalt), input_binding_key(vk_ralt)],
            run: input_binding_key(vk_space),
            shoot: [input_binding_key(vk_enter), input_binding_key(vk_space)],
            speed_credit: [input_binding_key("Q"), input_binding_key("E"), input_binding_key("R")],
            restart: input_binding_key("R"),
            previous: [input_binding_key("Q"), input_binding_key(vk_pagedown)],
            next: [input_binding_key("E"), input_binding_key(vk_pageup)]
        },
        
        gamepad:
        {
            // Menu navigation
            up: [input_binding_gamepad_axis(gp_axislv, true), input_binding_gamepad_button(gp_padu)],
            down: [input_binding_gamepad_axis(gp_axislv, false), input_binding_gamepad_button(gp_padd)],
            left: [input_binding_gamepad_axis(gp_axislh, true), input_binding_gamepad_button(gp_padl)],
            right: [input_binding_gamepad_axis(gp_axislh, false), input_binding_gamepad_button(gp_padr)],
            
            // Twin-stick aiming (right stick)
            aim_up: input_binding_gamepad_axis(gp_axisrv, true),
            aim_down: input_binding_gamepad_axis(gp_axisrv, false),
            aim_left: input_binding_gamepad_axis(gp_axisrh, true),
            aim_right: input_binding_gamepad_axis(gp_axisrh, false),
            
            cursorUp: [input_binding_gamepad_axis(gp_axisrv, true)],
            cursorDown: [input_binding_gamepad_axis(gp_axisrv, false)],
            cursorLeft: [input_binding_gamepad_axis(gp_axisrh, true)],
            cursorRight: [input_binding_gamepad_axis(gp_axisrh, false)],
            
            altLeft: [input_binding_gamepad_axis(gp_axisrh, true), input_binding_gamepad_button(gp_shoulderl), input_binding_gamepad_button(gp_shoulderlb)],
            altRight: [input_binding_gamepad_axis(gp_axisrh, false), input_binding_gamepad_button(gp_shoulderr), input_binding_gamepad_button(gp_shoulderrb)],
            
            accept: input_binding_gamepad_button(gp_face1),
            back: [input_binding_gamepad_button(gp_face2), input_binding_gamepad_axis(gp_shoulderr, false)],
            pause: input_binding_gamepad_button(gp_start),
            rigBuild: input_binding_gamepad_button(gp_face4),
            attack: input_binding_gamepad_button(gp_shoulderrb),  // RT for attack
            home: [input_binding_gamepad_button(gp_home), input_binding_gamepad_button(gp_guide)],
            start: input_binding_gamepad_button(gp_start),
            sell: input_binding_gamepad_button(gp_face4),
            confirm: input_binding_gamepad_button(gp_face1),
            run: input_binding_gamepad_button(gp_stickl),
            shoot: [input_binding_gamepad_button(gp_face1), input_binding_gamepad_button(gp_shoulderlb), input_binding_gamepad_button(gp_shoulderrb)],
            
            restart: input_binding_gamepad_button(gp_face4),
            next: input_binding_gamepad_button(gp_shoulderr),
            previous: input_binding_gamepad_button(gp_shoulderl),
            
            //Buttons for credits or direct calls
            btn_A: input_binding_gamepad_button(gp_face1),
            btn_B: input_binding_gamepad_button(gp_face2),
            btn_X: input_binding_gamepad_button(gp_face3),
            btn_Y: input_binding_gamepad_button(gp_face4),
            btn_LB: input_binding_gamepad_button(gp_shoulderl),
            btn_RB: input_binding_gamepad_button(gp_shoulderr),
            btn_LT: input_binding_gamepad_button(gp_shoulderlb),
            btn_RT: input_binding_gamepad_button(gp_shoulderrb),
            btn_LS: input_binding_gamepad_button(gp_stickl),
            btn_RS: input_binding_gamepad_button(gp_stickr),
            btn_upA: input_binding_gamepad_button(gp_padu),
            btn_downA: input_binding_gamepad_button(gp_padd),
            btn_leftA: input_binding_gamepad_button(gp_padl),
            btn_rightA: input_binding_gamepad_button(gp_padr),
            
            speed_credit: [input_binding_gamepad_button(gp_face3), input_binding_gamepad_button(gp_face4),
                input_binding_gamepad_button(gp_shoulderl), input_binding_gamepad_button(gp_shoulderr),
                input_binding_gamepad_button(gp_shoulderlb), input_binding_gamepad_button(gp_shoulderrb),
                input_binding_gamepad_button(gp_stickl), input_binding_gamepad_button(gp_stickr)]
        },
        
        touch:
        {
            up: input_binding_virtual_button(),
            down: input_binding_virtual_button(),
            left: input_binding_virtual_button(),
            right: input_binding_virtual_button(),
            
            accept: input_binding_virtual_button(),
            cancel: input_binding_virtual_button(),
            
            pause: input_binding_virtual_button(),
            rigBuild: input_binding_virtual_button()
        }
    };
}