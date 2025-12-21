/// obj_tutorial Create Event
depth = -10003; // Above upgrade menu (-10002)
current_screen = 0;
total_screens = 6; // Changed from 5 to 6

//Story text

"Having secured the Golden Fleece, Jason and the surviving\n  
Argonauts returned to his homeland of Iolcus, hoping to reclaim\n
the throne from his usurping uncle, Pelias." 

"However, after Medea — the powerful sorceress and priestess of\n 
Hecate - helped Jason’s cause by tricking Pelias’s daughters\n 
into killing their father, Jason and Medea were exiled from\n  
Iolcus for their role in Pelias’s death."

"They settled in Corinth, where they lived for several years\n
and had children together. Yet, over time, Jason's ambitions\n 
grew, and desiring to improve his status and secure his future,\n 
he abandonned Medea to marry Glauce, the daughter of King Creon\n 
of Corinth."

"Enraged by Jason’s betrayal, Medea slaughtered their children\n 
and called upon her patron goddess to place a terrible curse on\n 
Jason and the rest of his lineage: that they be forever hunted\n 
by the denizens of the underworld, until the last of Jason’s\n 
descendants is dead."

"Two weeks later, as the new moon rises over the island of\n 
Lemnos, shadows creep across the thinned veil into the world of\n 
the livings, hungering for the lives of Euneus and Nebrophonus,\n 
the twin boys fathered by Jason years before, on his brief time\n
with queen Hypsipyle."

"Panicked, the Queen and her children seeked refuge in the\n 
nearby temple of Hephaestus, and beseeched the god to protect\n 
them. Hearing the queen's plea, Hephaestus commands you, a\n 
daimon in hisf service, to intervene."

// Tutorial text for each screen
tutorial_text = [
    "Fly around using WASD/left joystick, and aim the Daimon's\n targetable attacks using the right joystick/mouse",
    
    "Collect anima droped by enemies to increase your strenght\n and stand within the barrier to recharge it",
    
    "Survive the night, while never allowing the barrier to fail.",

    "Press " + get_button_name("accept") + " to start"
];

// Pause game during tutorial
global.isPaused = true;