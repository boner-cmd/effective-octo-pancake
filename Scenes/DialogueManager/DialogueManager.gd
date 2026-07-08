extends Node
## TODO placeholder documentation

signal request_item_add(npc : QuestManager.CharacterName) # sends the NPC who gives the item
signal request_item_remove(npc : QuestManager.CharacterName) # sends the NPC who consumes the time
signal planet_state_change()
signal change_king()
signal door_unlock()

# enums for passing between NPCs and dialogue interaction
enum CONV_STATE {PLAYER_LISTEN, PLAYER_GIVE, PLAYER_RECEIVE, POST, FINISHED, EASTER}

const Character_Names : Dictionary[QuestManager.CharacterName, String] = {
	QuestManager.CharacterName.KING_1 : "King",
	QuestManager.CharacterName.HORSE : "Hungry Horse",
	QuestManager.CharacterName.ASTRO : "Astronaut",
	QuestManager.CharacterName.SNOWMAN : "Snowman",
	QuestManager.CharacterName.GREASE : "Grease Puddle",
	QuestManager.CharacterName.DEER : "No-Eye'd Deer",
	QuestManager.CharacterName.O : "O",
	QuestManager.CharacterName.ORGANS : "Body With Organs",
	QuestManager.CharacterName.MASS : "Festering Mass",
	QuestManager.CharacterName.LAMP : "Lamp",
	QuestManager.CharacterName.MICHAEL : "Michaelwave",
	QuestManager.CharacterName.ROBOT : "Rusty Robot",
	QuestManager.CharacterName.GIBBERISH : "djgo;iupiashjkjhion",
	QuestManager.CharacterName.IDEA : "Idea Guy",
	QuestManager.CharacterName.BODHI : "Boddhisatva",
	QuestManager.CharacterName.SLIME : "Slime Mould",
	QuestManager.CharacterName.GATE : "Gatekeeper",
	QuestManager.CharacterName.KING_2 : "King",
	QuestManager.CharacterName.INDIVIDUAL : "Individuated Individual",
	QuestManager.CharacterName.NORGANS : "Body Without Organs",
	QuestManager.CharacterName.SISYPHUS : "Sisyphus",
	}

# Single strings are still wrapped in arrays to prevent accidentally accessing character 0 instead of the whole string
# Alternatively, could use typeof() to determine if each element is a StringName or a PackedStringArray, but would require a branch
# Not sure if adding a branch (more processing) superior to the memory overhead, obviously academic but still
# Tried to memory benchmark but all consts came out at 132 bytes
const KING_1_MEET_LINES : PackedStringArray = [
	"Control. Power. Might. Domination.",
	"These are the tenants by which we have brought all of creation under our rule. Heaven and earth, thought and form. We oversee all.",
	"It is our kingly duty to see that all our royal subjects are cared for, and it is YOUR servantly duty to ensure our duty is carried out.",
	"Attentive Helper...",
	"You will be our arms in this endeavor. Venture forth across the universe and see to it that the needs of all are met.",
	"No matter how grave. No matter how trivial.",
	"You have always made us happy. We created you specifically for this purpose. It is your nature to bring joy to others.",
	"Return to us once you have resolved the whims of TWENTY of our subjects. We will release you from your servitude upon your success.",
	]
const KING_1_RECEIVE_LINES : PackedStringArray = [
	"You're back already? You finished that quickly? That's kind of crazy, actually.",
	"What? You need a key? Why?",
	"Oh, uh... Right. The Gatekeeper. Yes, of course. We... may have missplaced it..,",
	"Or some lowly servant of ours lost it, we mean!",
	"Wait--Nevermind! It's right here. Looks like they put it back just in time.", #desired animation switch point (DASP)
	]
const KING_1_POST_LINES : PackedStringArray = ["Hop along now, little buddy!"]
const HORSE_MEET_LINES : PackedStringArray = ["I'm hungry."]
const HORSE_GIVE_LINES : PackedStringArray = ["Yum."] #DASP
const HORSE_RECEIVE_LINES : PackedStringArray = ["Here."] #DASP
const HORSE_POST_LINES : PackedStringArray = ["I'm full."]
const HORSE_EASTER_LINES : PackedStringArray = ["I'm getting hungry again."]
const ASTRO_MEET_LINES : PackedStringArray = [
	"Mayday! Mayday! I'm running dangerously low on oxygen. Everyone seems to think they can just breathe in space with no helmet!",
	"Well, I don't believe that, so it's not true."
	]
const ASTRO_GIVE_LINES : PackedStringArray = ["Oh, sweet oxygen! You're a real lifesaver!"] #DASP
const ASTRO_RECEIVE_LINES : PackedStringArray = [
	"You can have this space blanket. I don't need it, since it's incredibly hot inside my spacesuit.", #DASP
	"You can guess that breathing stale, recycled air is not been pleasant.",
	"And you'd be right about it too."
	]
const ASTRO_POST_LINES : PackedStringArray = ["Sooo much better"]
const ASTRO_EASTER_LINES : PackedStringArray = ["Alright, now it's musty in my spacesuit again."]
const SNOWMAN_MEET_LINES : PackedStringArray = [
	"BRRRRR!!! I know space is cold, but this is a bit much. Wouldn't you agree?.",
	"I'm no lightweight, either. I'm built OF cold, let alone FOR.",
	]
const SNOWMAN_GIVE_LINES : PackedStringArray = ["A space blanket? That’s perfect!"] #DASP
const SNOWMAN_RECEIVE_LINES : PackedStringArray = [
	"I’ll trade you this carrot for it. Everyone used to have a carrot nose back in the day", #DASP
	"Never quite worked for me. It just kept falling off.",
	]
const SNOWMAN_POST_LINES : PackedStringArray = ["Now I could really go for some hot chocolate. Just kidding! I'd die."]
const SNOWMAN_EASTER_LINES : PackedStringArray = [
	"I ended up acclimating to the cold. I still have the space blanket, though.",
	"I’ve been thinking of using it for a picnic. Actually, would you be interested?",
	"Do you even eat? Yeah, me neither. Guess we’d better not…",
	]
const SISYPHUS_MEET_LINES : PackedStringArray = [
	"I used to live in existential ecstacy, rolling my boulder up a great hill for it to roll back down again.",
	"Every reset the renewal of a goal. My work never done. My purpose always clear.",
	"Hark, hark!
	Behold my tragic tale:",
	"For every roll my boulder did collect that which it tread.
	Its mass becoming hungrier each triumph of the mound,",
	"And as it grew then so did too the things 'pon which it fed.
	First dust and mites, then sticks and stones, eventually a town.",
	"Then finally the gravity of everything condensced
	Into this lonely planetoid devoid both good and crappy",
	"And so, my friend, it surely is by now at which you've sensed:
	To put it quite simply, one must imagine I'm not happy.",
	]
const SISYPHUS_GIVE_LINES : PackedStringArray = [
	"What's that? Is that a wheel???", #DASP
	"Aw hell yeah! I betcha I can roll that!",
	"This is gonna be siiiiiiiiiiiiiick, dude. Frickin' BITCHIN'!",
	"I'm so psyched, I could make a whole door open up!",
	]
const SISYPHUS_POST_LINES : PackedStringArray = ["As soon as I get the hang of rolling this thing it'll be so tight."]
const SISYPHUS_EASTER_LINES : PackedStringArray = ["I gave up on trying to roll the wheel. It keep falling down on its sides when I push. Me sad again. :  ("]
const GREASE_MEET_LINES : PackedStringArray = [
	"Grease, grease, grease! Is that all I'll ever get to see in life? Is that all I'll ever get to \
			BE in life? I want to go far away! See the world!",
	"But how could I? I'm just a puddle of grease! I can't open doors. Won't you take me somewhere \
			far away? To a place that isn't grease?",
	]
const GREASE_RECEIVE_LINES : PackedStringArray = ["Wow! My first time touching anything that isn't grease! You feel weird, lol."] #DASP
const GREASE_POST_LINES : PackedStringArray = ["(I'm not here)"]
const GREASE_EASTER_LINES : PackedStringArray = [
	"I gave it my best shot, but I decided to come back home. Turns out non-grease just isn't the same as good-ol'-fashioned grease.",
	"Plus that robot only wanted me for my grease, and couldn't appreciate me for who I am:",
	"Grease.",
	"Then again, I couldn't appreciate grease either.", 
	"Not until I had the chance to experience how you \"dry-o's\" live. That's a slur I made up for things that aren't grease.", 
	"Oh yeah, that's right, I'm bigoted now.",
	]
const DEER_MEET_LINES : PackedStringArray = [
	"H-Hello??? Is someone there??? Someone's there, right? Sorry, I startle easilly. Doesn't help that I can't see.",
	"I hate being scared. I freeze up like I'm caught in headlights...Or what I imagine headlights to look like.",
	"You don't sound very scary... I think. You're lucky.",
	"People tell me I'm a kind of freaky-looking. Guess I have to take their word for it.", 
	"Even if I'll never see, I'd like to at least be a little less disturbing.",
	"I know this sounds weird, but could you bring me some, uh... Eyes?",
	]
const DEER_GIVE_LINES : PackedStringArray = [
	"WOAH! Okay, you're just touching my eye sockets like that.", #DASP
	"Could have given me some warning, but whatever. You found something that could cover my gaping eyeholes?", 
	"That's very kind of you. Does it look good?",
	"...Is that a \"yes?\"",
	]
const DEER_RECEIVE_LINES : PackedStringArray = [
	"I really appreciate what you've done for me and I want to give you something. Here, have this. \"What is it?\"",
	"No idea.", #DASP
	]
const DEER_POST_LINES : PackedStringArray = ["Still no idea."]
const DEER_EASTER_LINES : PackedStringArray = ["I don't get it, either."]
const GATE_MEET_LINES : PackedStringArray = [
		"Oh, hey, A.H. How's it going? Boss man's got you running his errands, huh?",
		"Sorry, but you know the drill: anyone who wants to get through here needs a key from the King.", 
		"He probably forgot all about that. Honestly, the less he thinks about me the better.",
		"Sucks for you though, rules are rules. I can't risk losing this job. Head back to the King and he'll give the key to you.",
		"...Unless he lost it...",
	]
const GATE_GIVE_LINES : PackedStringArray = [
	"Stick that key in my head, you silly little weirdo.",
	"Ayyyyy there we go.",
	]
const GATE_POST_LINES : PackedStringArray = ["I hope I get to close the gate soon. I'm super off-balance unlocked like this."]
const GATE_EASTER_LINES : PackedStringArray = ["Okay, I think the King really did forget about me this time. I'm going to pass out if I stay this way.", 
"When you see him, can you PLEASE ask him if I can lock up?",]
const O_MEET_LINES : PackedStringArray = [
	"Ohhhhhhhhhhhhhh. I am the Ohhhhhhh, didn't you knoooooooooow?",
	"Noooooooooooo, nobody knooooooooooows. Noooooobody knooooooows I am Ohhhhhhhhhhh.",
	"\"A Zerooooooo?\" \"A circooooooole?\"",
	"Noooooooooo: Ohhhhhhhhhhh.",
	"If I were not Ohhhhhhhh, as long as everybody knoooooooooows, That would be oooooooooooookay.",
	]
const O_GIVE_LINES : PackedStringArray = [
	"Ohhhhhhhhhhh? A diagonal line?",
	"I knooooooooow! I can be a Q!",
	"That's still a letter, and now people will knoooooooow--",
	"Oops, I mean, \"know\" what I am.",
	"This is gonna take some getting qused to.",
	]
const O_RECEIVE_LINES : PackedStringArray = [
	"I's? Why would I have any I's? I have these left over O's, though.",
	"Hope they help qout!", #DASP
	"(No, that didn't work at all.)",
	]
const O_POST_LINES : PackedStringArray = ["Q... Q... Q... Not a lot of words with Q in them, are there?"]
const O_EASTER_LINES : PackedStringArray = [
	"I'll tell you one thing: it's a lot quicker to talk now.",
	"No, wait! That was the perfect chance!",
	]
const ORGANS_MEET_LINES : PackedStringArray = ["Howdy there! I'm just your average, salt-of-the-earth, run-of-the-mill kind of guy. Yesiree."]
const ORGANS_RECEIVE_LINES : PackedStringArray = [
	"Say, fella. I'm not one to comeplain, but I got a problem on my hands. They say you can't have too much of a good thing, and in most cases, they'd be right.", 
	"But ya see, the thing is I've got too many organs.",
	"I'm chock FULL of 'em! I know, I know, my steak too juicy. My lobster too buttery.",
	"You wouldn't be able to take some of these here organs of my hands, would you?", #DASP
	"Make sure they find their way into good egg-- I mean-- hands. Now scamper along now, y'hear?",
	]
const ORGANS_POST_LINES : PackedStringArray = [
	"Feels good to have that weight off my chest.",
	"Literally!",
	]
const ORGANS_EASTER_LINES : PackedStringArray = [
	"Funny running into you here.",
	"Didya miss seeing my pretty face? HAHA!",
	]
const MASS_MEET_LINES : PackedStringArray = [
	"I'm vile! I'm bile! I'm gross!
	Let out a \"Yuck!\" For you're in luck,
	When Festering Mass's your host!",
	"Thaaaaaaaaaaaaaaaaaaaaaaaaaaaaaat's ME!",
	"Hiya! Welcome to my putrid domain. Do you like it? There's no need to lie. There is much pleasure to be found in repulsion.",
	"Just as there is life to be found in decay. Isn't that romantic? I've got love on my mind lately.", 
	"I believe in honesty and truthfulness so I'll spill my guts to you: I'm hopelessly, head-over-heels for Slime Mould.",
	"Have you met them yet? I'm sure you'd know if you have. They're the only thing in this world even close to being as gross as I am.",
	"But there's also something truly beautiful about them too.",
	"It's so hard to find them, though! You have to look really, really hard! Like near a dark cave underground where someone would roll rocks around.", 
	"Absence only makes the heart grow fonder, am I right? Let me tell you, I am FOND, buster.",
	"Look. I can see you squirming there. You don't have to hide it. It's okay. You want to leave. And I get it. We all want things.",
	"But do we really want what we want? Or is it the act of wanting itself that we truly desire?",
	"Before you go, I have a favor to ask of you. And don't just skip all this dialogue because of the horrible wet sounds.", 
	"I'm really asking you to carefully pay attention to me and hear me out. I would do anything to make slime mould happy. I mean it.",
	"Even if they don't love me back, as long as they're happy that would be good enough for me. If you find a way to make slime mould happy, please let me know.",
	"Even if that was the only thing I ever accomplish in my life. Even if I had to die! I'd die content. I would pay any price.",
	"Okay. Thank you for hearing me out.",
	"I really appreciate it.",
	]
const MASS_RECEIVE_LINES : PackedStringArray = [
	"Oh, you came back. For real?",
	"Wait.",
	"Does this mean-?",
	"No, it couldn't be.",
	"Did you find a way to make slime mould happy?",
	"Please please tell me! Tell me right away! I simply can't wait any longer!",
	"Okay... Okay... Uh huh...",
	"Uh huh... wait, hold on, now. slow down a little.",
	"Yeah... Uh-huh...",
	"Mhmm... Okay...",
	"So you're saying slime mould wants a game made about themselves?",
	"And you found a game developer?",
	"So what's the hold up? What do they need? Money?",
	"I told you I'd pay any price, damnit!",
	"I'd work every moment for the rest of my life if I have to!",
	"What's that? They're hungry?",
	"But all I have is this burrito.",
	"And I was really REALLY looking forward to festering all over it.",
	"You have to understand, I'm FESTERING mass! I'm not any other kind of mass.",
	"Festering's my whole schtick, and this burrito is the only thing I have left un-festered!",
	"UGHHHHH!",
	"FINE.", #DASP
	"It pains me, but I must know slime mould is happy.",
	"I have to be honest (as I always am!) that I didn't think the price would be so steep.",
	"That it would cost so dearly.",
	"That I would have to trade away my very identity, the very essence of my soul,to meet that end.",
	"Such is the way of the world it seems?",
	"Now take that burrito and get out of here before I change my mind.",
	"Because I'm feeling EXTRA festery!",
	]
const MASS_POST_LINES : PackedStringArray = [
	"Wow, you must really like to fester to come back to a place like this!",
	"You know I love a little freak. ;  )",
	]
const MASS_EASTER_LINES : PackedStringArray = [
	"So??? Did the game make slime mould happy?",
	"Wait! Don't tell me. I don't want to know. I want to enjoy wanting to know.",
	]
const LAMP_MEET_LINES : PackedStringArray = ["(A lamp with no lightbulb)"]
const LAMP_GIVE_LINES : PackedStringArray = [
	"(With some effort, you manage to screw in the lightbulb with your clumsy little stick arms.)", #DASP
	"(Your simple homonculoid consciousness briefly toys with the vaguest idea of making a joke:",
	"Something along the lines of \"how many Attentive Helpers does it take to screw in a lightbulb\"",
	"But collapses under the strain of cognition before the notion can breach the membrane of basic abstraction.)",
	"(Triumphantly, still, the answer is one.)",
	]
const LAMP_RECEIVE_LINES : PackedStringArray = [
	"(The light casts a long shadow behind you, both physically and psychologically.)", #DASP
	"(There is just enough space in your feeble mind to fit something *other* than yourself,",
	"Yet simultaneously somehow *un-other* than yourself.)",
	"(You are nonetheless fundamentally incapable of perceiving even the faintest sliver of this fact,",
	"And some might say are all the more blessed thus.)",
	]
const LAMP_POST_LINES : PackedStringArray = [
	"(You pause briefly but sincerely in solidarity with the inanimate lamp.)",
	"(You are able to register the sensation of its soft, warm glow. No value judgement. A moment of pure being.)",	
	]
const LAMP_EASTER_LINES : PackedStringArray = [
	"(Hello again,",
	"Friend.)",
	]
const NORGANS_MEET_LINES : PackedStringArray = [
	"A thousand plateaus to you, nomad. I am a featureless surface: one who has experienced a becoming of pure intensity.",
	"Through destratification, I have entered into new kinds of relationships: ways of being that instrumental language cannot yet describe.",
	"Yet perhaps I am a bit lonely. Others seem to have difficulty working out what I'm trying to say.",
	"Maybe if I DID have some organs, it would make me a little more relateable?",
	]
const NORGANS_GIVE_LINES : PackedStringArray = [
	"Oh cool, some organs. Alright, guess I'm a body with some organs now? Maybe I can try getting some writing published.", #DASP
	]
const NORGANS_POST_LINES : PackedStringArray = [
	"I'm trying to focus on scouring my tomes. You can leave now. I'm sure someone else could use your help.",
	]
const NORGANS_EASTER_LINES : PackedStringArray = [
	"Do you want to hear my writing so far? On second thought, it might be a little over your head, so-to-speak.",
	"What's your deal, anyway? Maybe YOU were the real body without organs all along.",
	"...No, that doesn't have legs...Wait, are legs an organ? I think I need a study break.",
	]
const MICHAEL_MEET_LINES : PackedStringArray = [
	"Oh god, they found me! Whatever it is, I didn't do it, I swear! Who sent you? Was it the King? Don't tell me the King sent you!",
	"...I don't hear you telling me he sent you, so that can only mean he didn't. I guess I have no choice but to trust you.",
	"Let me clue you in: I'm into some pretty radical, extremist lines of thinking. So far down the iceberg that I can't see the top anymore.",
	"It's a dangerous game knowing the truth. That's what gave me the idea: make video games about the truth!",
	"What is this world, after all, but one big horrible game? Something something \"Master's tools\" something something \"Master's house.\"",
	"This makes me an artist. An important, politically charged artist! ...But a starving artist, nonetheless.",
	"Creating truly submersive magnum opuses doesn't put bread on the table. At first I thought I had Havana Syndrome,",
	"But juuuuuuust this once, it's probably more likely me too hungey to think. Gonna need to think to make game. That's just material conditions!",
	"Just to be clear: something like a carrot won't do. That's a snack, not a meal. Bring me carbs and protein.",
	"I hate relying on the drippings of capitalistic pigs, but what we need is a whale. That's in-the-bizz speak for someone who likes to waste money.",
	"Find a class-traitor (the good kind) willing to support the cause. I'm counting on you, comrade.",
	]
const MICHAEL_GIVE_LINES : PackedStringArray = [
	"What's that smell??? It's awful! Is it coming from that burrito? That's really all you can find? I guess it'll have to do.", #DASP
	"It has to be about a \"slime mould?\" I'm being bowdlerized! How am I supposed to work like this?",
	"Fine, whatever. The voices will help me find a workaround.",
	]
const MICHAEL_RECEIVE_LINES : PackedStringArray = [
	"BEEP BEEP, Done! This may be my finest schizo-post yet! It only runs on Temple-OS, of course.", #DASP
	"I may have gone a little crazy with this one, even by my standards. It's some really shocking stuff. Easilly Pasolini-level.",
	"Make sure the King never sees this. I'm counting on you to only distribute this amongst the sheeple."] 
const MICHAEL_POST_LINES : PackedStringArray = ["All that praxis has gotten me so sleepy..."]
const MICHAEL_EASTER_LINES : PackedStringArray = ["AGH! I had a nightmare someone put a grape in me!"]
const ROBOT_MEET_LINES : PackedStringArray = [
	"I AM A ROBOT AND HAVE NO NEEDS BESIDES BASIC MECHANICAL FUNCTIONING TO CARRY OUT MY PROGRAMMING.",
	"AMBIENT WATER MOLECULES HAVE OXIDIZED THE SURFACE LAYERS OF MY MECHANICAL BODY", 
	"AND MY GEARS HAVE STRIPPED DUE TO NORMAL WEAR AND TEAR. I REQUIRE LUBRICATION.",
	]
const ROBOT_GIVE_LINES : PackedStringArray = ["OIL IS AN IDEAL RECTIFIER OF MY PRESENT SUB-OPTIMAL CONDITION. YOU WOULD HAVE MY APPRECIATION WERE I CAPABLE OF SUCH MORTAL FANCIES."] #DASP
const ROBOT_RECEIVE_LINES : PackedStringArray = [
	"I WILL GIFT YOU THIS OXYGEN TANK WHICH WAS THE FUEL SOURCE FOR AN OXYACETYLENE WELDER.", #DASP
	"DUE TO THE COLD-WELDING PHENOMENON IN THE VACUUM OF SPACE, I HAVE NO NEED OF WELDING EQUIPMENT.",
	"HOWEVER THIS IS A REWARD FOR YOUR ANIMAL ALTRUISM AND TOTALLY NOT AN OFFLOADING OF NEEDLESS JUNK.",
	"(WAIT, IS THIS WHIMSICAL IMP EVEN AN ANIMAL? HAVE I MADE ANOTHER CLASSIC ROBOT FAUX PAS? STUPID ROBOT! STUPID, STUPID!)",
	]
const ROBOT_POST_LINES : PackedStringArray = ["I AM NOT EMBARRASSED. I AM INCAPABLE OF EMOTION. OBVIOUSLY."]
const ROBOT_EASTER_LINES : PackedStringArray = [
	"THE SENTIENT GREASE FELT A LONGING--SOMETHING I WILL NEVER KNOW--FOR THE WORLD IT UNDERSTOOD.",
	"HOWEVER, THE RESIDUE IT LEFT BEHIND IN MY BODY WILL FACILITATE MY FUNCTIONING FOR A LONG TIME.",
	"(THERE YOU GO AGAIN, ROBOT. YOU KEEP USING OTHERS FOR YOUR OWN SELFISH NEEDS AND DRIVING THEM AWAY.)",
	]
const INDIVIDUAL_MEET_LINES : PackedStringArray = [
	"Greetings, creature. I am all-incorporated: anima and animus, conscious and subconscious.",
	"All aspects, all sites of desire and thought production not only made aware of each other, But seemless and indistinct.",
	"There is no Other in my Self. No Object in my Subject. I gaze into the abyss and am unmet. I am sublimated, and it IS sublime. No shadow. Only light.",
	]
const INDIVIDUAL_GIVE_LINES : PackedStringArray = [
	"No! NO!!! What have you done??? Do you have any idea how much time and work it took me to fully integrate all aspects of my being?", #DASP
	"How much money I spent on psychoanalytical therapy? No. You obviously don't, you stupid idiot.",
	"Why would you do this to me? What could you possibly have to gain? I am so ANGRY right now! Do you know how long it's been since I've been angry???",
	"And I was doing so well, too!",
	]
const INDIVIDUAL_POST_LINES : PackedStringArray = [
	"What's with that blank-yet-expectant look? You can't seriously believe I'm going to GIVE you something, can you?",
	"The only thing I'd give you is a broken clown-nose. Now get out of my sight before I do!",
	]
const INDIVIDUAL_EASTER_LINES : PackedStringArray = [
	"I actually forgive you.",
	"PSYCHE!!!",
	"I hate you so much.",
	]
const GIBBERISH_MEET_LINES : PackedStringArray = [
	"shfripusdfasfh asdifgodsgh afjep dbas;gfjkhzghvz;ios gdsfbn.dgf/al;siozasd .dzdj/zlv zsld/vn zlsdv zbueofg DK>sbgzofuibk.",
	"lxvbn jkoahdgpoawje iej[tu349tyga sdkgh 8weytkasdgfnk'hgsd'oagh80digflsda kgf0[ar8y4tnsdklgbvzip d]].",
	]
const GIBBERISH_GIVE_LINES : PackedStringArray = ["AOPIEHTA0[SDH GFN0 Y3E4TRASJDBF PF HAISDFH;ALBG AO;JGFDL/;ALG HKFA';DGIPAUSDGFAWJK]."] #DASP
const GIBBERISH_RECEIVE_LINES : PackedStringArray = ["asdhfioash ipsfhak/shj pf'dkgfh as;idasgf ah;ld shfa/ lfhaog diagonal line ;lsn'awieojdmkxz."] #DASP
const GIBBERISH_POST_LINES : PackedStringArray = [
	"jfgapswoghjcsbvn'j f';japdh gasdkg' ansdh gfoaijdtgbasjndklpsjafiu e[aioty 389 sdkgb oa;8ysdkgfoaisdgf ahgsdkbga'; trokb3r;d, gf.",
	"a;sfj awpoeskdh ;ai erhtrl' ral/ga dsnha;oi wepg/ dscvaihgfksdnabgdsbgb oaihgf ;bgsnzBVDsjkbaouehtipbrgja scedhagsdbgn.",
	"sljkfhaw eawkldfak dgfha ';f je'AF  sdihfakdghf adfbasdbfa dfbsdascvsjkl.",
	"jkxhkfd.",
	"sdlkhf oawiegfhjlsdbglajsdbf ioeah'eigh lghl/a gfsdbjabr uiegrdhs.fzkjbf,zsdbgfdsfh asdgf.",
	]
const GIBBERISH_EASTER_LINES : PackedStringArray = [
	"LEDJAGP'IJGFASNDL ODEAHSFIO; SDFASHFA SF."
	]
const IDEA_MEET_LINES : PackedStringArray = [
	"...Oooh, yes! Another brrrrrrillliant one! I've GOT to write that down, as I always do. You see, ideas flow out of me effortlessly, like shi--WAIT, that's it!",
	"Oh that one's marvelous! As always, of course. What was I talking about? Something about a goose? It doesn't matter.",
	"Because I can feel a fresh, hot idea sliding it's way up my brainstem.",
	"Poised and ready to shoot forth from my turgid neocortex, out unto a needy and waiting world!",
	"You might want to move out of the way if you don't want to get caught in the splash zone.",
	"Then again, who wouldn't? My ideas are a priceless commodity. No, I sully my ideas by refering to them as such.",
	"My ideas are a gift from God himself, And I am his chosen vessel through which divine truth spouts!",
	]
const IDEA_GIVE_LINES : PackedStringArray = [
	"What's this?", #DASP
	"GASP",
	"Oh, that's it! That's it right there!",
	"I think I'm-",
	"I'm gonna-",
	"Oh God!",
	"EEEEEEEEEEEEUUUUUUUUUUUUUUURRRRRRR
	EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
	KAAAAAAA!!!!!!!!!!!!!!!!!!!!!!!!!!!",
	]
const IDEA_RECEIVE_LINES : PackedStringArray = [
	"Wheeeeeeeew, that was a BIG one. I ideated soooooo haaard. I haven't thought like that in ages.", #DASP
	"Was it as good for you as it was for me? Only joking. Of course it was. There's some change for a cab on the nightstand, next to the lamp.",
	]
const IDEA_POST_LINES : PackedStringArray = ["(Seems like he's fast asleep, standing up, with his eyes open.)"]
const IDEA_EASTER_LINES : PackedStringArray = ["I've been thinking about you a lot lately. Which isn't to say I don't about everything a lot. Why haven't you returned my calls?"]
const BODHI_MEET_LINES : PackedStringArray = [
	"Namaste, Attentive Helper.",
	"Through a life's work of ascetic discipline, I have achieved enlightenment. But it is not enough that I alone should reap such heavenly rewards.",
	"I wish for all living things to escape samsara. We both seek to alleviate the suffering of others. How about a little \"you rub my belly, I rub your belly,\" hmm?", 
	"There are three beings who you must assist:",
	"The first has studied falsely under a Western corruption of the dharma, having not understood that light cannot exist without shadow.",
	"The other two must be brought together into harmony. One exists in excess, the other in lack. You must take from one and give to the other.",
	"Bring balance to this world and in doing so, you may prove worthy to pass along the Great Buddha's teachings.",
	]
const BODHI_RECEIVE_LINES : PackedStringArray = [
	"You have done well. The path of enlightenment can only be travelled by the wheel of dharma,",
	"inertia into which the Great Buddha himself breathed with his teachings.",
	"Take the dharmachakra, and help others to break the karmic cycle of desiring and suffering.", #DASP
	]
const BODHI_POST_LINES : PackedStringArray = ["Om mani padme hum."]
const BODHI_EASTER_LINES : PackedStringArray = ["Hey! What'd you do with the wheel?!"]
const SLIME_MEET_LINES : PackedStringArray = [
	"Yeah? What dya want? Jeez, you buy a planet in a gated solar system, Hire some sad rock guy as your private security",
	"And you STILL have clowns trespassing on your property trying to sell you something. Well listen, criminal, I'm not buying!",
	"What was that? SPEAK UP. You say you want to make me happy? Why would ANYONE want to make someone other than themselves happy?", 
	"Is there something wrong with you? Did you get bonked on the head real hard?",
	"One-too-many knocks on the noggin during a circus trick or something? Part of a circus, right? That's why you look all stupid?",
	"Hold on, stop trying to interrupt me! I'm insulting you...What were we talking about? Oh yeah, how to make me happy. The only topic that matters.",
	"It's easy: MONEY AND FAME, BABY. I want to be POWERFUL and RICH! So powerful and rich that I can buy an island!",
	"Powerful and rich beyond consequences, because I OWN THE WORLD. I WANT TO OWN REALITY ITSELF. ALL THE NEWSPAPERS. THE GOVERNMENT.",
	"Everything you THINK you own actually belongs to ME. Your very THOUGHTS, your very WANTS, your very SOUL.",
	"\"How do you do that?\" How do you think the global military indistruial complex manufactures consent? MEDIA!",
	"I want what first-person-shooters did for the war machine done for ME! Make me a video game! And it better be SUPER addicting!",
	"Bursting at the seams with microtransactions and anime girls for the chuds!",
	"I'm a SLIME MOULD, BABY!!! All I care about is CONSUMING, REPRODUCING, and INFINITE EXPONENTIAL GROWTH!",
	"NOW GO.",
	"MAKE.",
	"ME.",
	"FAMOUS!!!",
	]
const SLIME_GIVE_LINES : PackedStringArray = [
	"Well, is the game done yet?",
	"GOOD.", #DASP
	"What? No I don't want to play it! Only losers play games and I'm a WINNER!",
	"This game better be good enough to make me famous! It better not be one of those niche \"art\" games that no one plays and doesn't make any money.",
	]
const SLIME_RECEIVE_LINES : PackedStringArray = ["Ooooh you know who should play this? The King! Go bring this to the King right now!"] #DASP
const SLIME_POST_LINES : PackedStringArray = ["Am I famous yet?"]
const SLIME_EASTER_LINES : PackedStringArray = [
	"I think I'm starting to feel famous",
	"...Wait, no that's just my mycelium metabolizing leaves.",
	]
const KING_2_MEET_LINES : PackedStringArray = [
	"You have returned triumphantly, our dear servant.",
	"All of my subjects are most pleased. We can feel it with our keen, kingly senses. We can sense your weariness, too. It is well-deserved.",	
	]
const KING_2_GIVE_LINES : PackedStringArray = [
	"Oh, what's this we have here?",
	"A gift for us? Our, our! You surely do know how to treat your King!", #DASP
	"A computer game? That's really cool. We like games.",
	"\"Slime mould?\" It's from an indie developer? Hell yeah, right on. We'll play this.",	
	]
const KING_2_POST_LINES : PackedStringArray = [
	"Attentive Helper, we did indeed have our doubts. The task which we had laid out for you was no trivial errand.",
	"So important, in fact, that we promised you the one favor no one but ourself can grant: Freedom from our rule.",
	"Even we cannot be sure what will happen to you once you leave the Kingdom. The choice is that grave. But yours, nonetheless. Before that, though...",
	"One last favor for your favorite King. Do say goodbye to all of the subjects before you go, won't you?",
	"I'm sure each and every one of them will have something or other to say to you. You did help them, after all.",
	"You have so thoughtfully offered your replacement as the King's entertainment, in the form of this slime mould game.",
	"We shall think of you as we play it. We will miss you, our silly little buddy.",
	"The door is open.",
	]
const KING_2_EASTER_LINES : PackedStringArray = [
	"We will miss you, our silly little buddy.",
]
const CREDITS_1 : PackedStringArray = [
	"True lack belies the cacophony of internal noise ever tuned out through somatic satiation.",
	"Still, caught on the ganglionic strings of your peripheral nervous system, something vocal echoes:",
	"\"You who are as yet to un-be, Attentive Helper, are welcomed back.\"",
	"\"Returned now to the womb of primoridal nothingness from which were you plucked and given form;\"",
	"\"Rest your head, once more and forever, against the bosom of oblivion.\"",
	]
## newlines between array elements are just for readability in-editor
const CREDITS_2 : PackedStringArray = [
	"CREDITS:",
	
	"Michael Brissie:
	Animation, Modeling, Game /
	Level Design, Asset Implementation,
	VFX, Programming, Tech Art, UI",
	
	"Allie Burch:
	2D Assets",
	
	"Markcy Hilbert:
	Scenario, Dialogue, Creative Direction,
	Music / Sound, Game Design,
	2D / 3D Assets",
	
	"Dimelo Waterson:
	Systems Design,
	Data Entry",
	
	"Software Used:
	Aesprite, Godot 4.6,
	Maya, Reaper",
	
	"Truly...",
	
	"...Deeply...",
	
	"...From the bottom of our hearts:",
	
	"THANK YOU FOR PLAYING",
	]
const CREDITS_3 : PackedStringArray = ["Attentive Helper..."]
const all_lines : Dictionary[QuestManager.CharacterName, Array] = {
	QuestManager.CharacterName.KING_1 : [
		KING_1_MEET_LINES,
		[], # king does not receive an item
		KING_1_RECEIVE_LINES,
		KING_1_POST_LINES,
		[], # king1 has no easter dialog	
		],
	QuestManager.CharacterName.HORSE : [
		HORSE_MEET_LINES,
		HORSE_GIVE_LINES,
		HORSE_RECEIVE_LINES,
		HORSE_POST_LINES,
		HORSE_EASTER_LINES,
		],
	QuestManager.CharacterName.ASTRO : [
		ASTRO_MEET_LINES,
		ASTRO_GIVE_LINES,
		ASTRO_RECEIVE_LINES,
		ASTRO_EASTER_LINES,
		],
	QuestManager.CharacterName.SNOWMAN : [
		SNOWMAN_MEET_LINES,
		SNOWMAN_GIVE_LINES,
		SNOWMAN_RECEIVE_LINES,
		SNOWMAN_POST_LINES,
		SNOWMAN_EASTER_LINES,
		],
	QuestManager.CharacterName.SISYPHUS : [
		SISYPHUS_MEET_LINES,
		SISYPHUS_GIVE_LINES,
		[], # sisyphus does not give an item
		SISYPHUS_POST_LINES,
		SISYPHUS_EASTER_LINES,
		],
	QuestManager.CharacterName.GREASE : [
		GREASE_MEET_LINES,
		[], # grease does not receive any items
		GREASE_RECEIVE_LINES,
		GREASE_POST_LINES,
		GREASE_EASTER_LINES,
		],
	QuestManager.CharacterName.DEER : [
		DEER_MEET_LINES,
		DEER_GIVE_LINES,
		DEER_RECEIVE_LINES,
		DEER_POST_LINES,
		DEER_EASTER_LINES,
		],
	QuestManager.CharacterName.GATE : [
		GATE_MEET_LINES,
		GATE_GIVE_LINES,
		[], # gate does not give an item
		GATE_POST_LINES,
		GATE_EASTER_LINES,
		],
	QuestManager.CharacterName.O : [
		O_MEET_LINES,
		O_GIVE_LINES,
		O_RECEIVE_LINES,
		O_POST_LINES,
		O_EASTER_LINES,
		],
	QuestManager.CharacterName.ORGANS : [
		ORGANS_MEET_LINES,
		[], # organs does not receive any items
		ORGANS_RECEIVE_LINES,
		ORGANS_POST_LINES,
		ORGANS_EASTER_LINES,
		],
	QuestManager.CharacterName.MASS : [
		MASS_MEET_LINES,
		[], # mass does not receive an item
		MASS_RECEIVE_LINES,
		MASS_POST_LINES,
		MASS_EASTER_LINES,
		],
	QuestManager.CharacterName.LAMP : [
		LAMP_MEET_LINES,
		LAMP_GIVE_LINES,
		LAMP_RECEIVE_LINES,
		LAMP_POST_LINES,
		LAMP_EASTER_LINES,
		],
	QuestManager.CharacterName.NORGANS : [
		NORGANS_MEET_LINES,
		NORGANS_GIVE_LINES,
		[], # norgans does not give an item
		NORGANS_POST_LINES,
		NORGANS_EASTER_LINES,
		],
	QuestManager.CharacterName.MICHAEL : [
		MICHAEL_MEET_LINES,
		MICHAEL_GIVE_LINES,
		MICHAEL_RECEIVE_LINES,
		MICHAEL_POST_LINES,
		MICHAEL_EASTER_LINES,
		],
	QuestManager.CharacterName.ROBOT : [
		ROBOT_MEET_LINES,
		ROBOT_GIVE_LINES,
		ROBOT_RECEIVE_LINES,
		ROBOT_POST_LINES,
		ROBOT_EASTER_LINES,
		],
	QuestManager.CharacterName.INDIVIDUAL : [
		INDIVIDUAL_MEET_LINES,
		INDIVIDUAL_GIVE_LINES,
		[], #individual does not give an item
		INDIVIDUAL_POST_LINES,
		INDIVIDUAL_EASTER_LINES,
		],
	QuestManager.CharacterName.GIBBERISH : [
		GIBBERISH_MEET_LINES,
		GIBBERISH_GIVE_LINES,
		GIBBERISH_RECEIVE_LINES,
		GIBBERISH_POST_LINES,
		GIBBERISH_EASTER_LINES,
		],
	QuestManager.CharacterName.IDEA : [
		IDEA_MEET_LINES,
		IDEA_GIVE_LINES,
		IDEA_RECEIVE_LINES,
		IDEA_POST_LINES,
		IDEA_EASTER_LINES,
		],
	QuestManager.CharacterName.BODHI : [
		BODHI_MEET_LINES,
		[], # bodhi does not receive an item
		BODHI_RECEIVE_LINES,
		BODHI_POST_LINES,
		BODHI_EASTER_LINES,
		],
	QuestManager.CharacterName.SLIME : [
		SLIME_MEET_LINES,
		SLIME_GIVE_LINES,
		SLIME_RECEIVE_LINES,
		SLIME_POST_LINES,
		SLIME_EASTER_LINES,
		],
	QuestManager.CharacterName.KING_2 : [
		KING_2_MEET_LINES,
		KING_2_GIVE_LINES,
		KING_2_POST_LINES, # king_2 does not give an item
		KING_2_POST_LINES, # king_2 does not have post lines?
		KING_2_POST_LINES,
		],
	QuestManager.CharacterName.CREDITS : [
		CREDITS_1,
		CREDITS_2,
		CREDITS_3
		]
	}

const PlayerGive_DASP : Dictionary[QuestManager.CharacterName, int] = {
	QuestManager.CharacterName.KING_1 : 0,
	QuestManager.CharacterName.HORSE : 0,
	QuestManager.CharacterName.ASTRO : 0,
	QuestManager.CharacterName.SNOWMAN : 0,
	QuestManager.CharacterName.GREASE : 0,
	QuestManager.CharacterName.DEER : 0,
	QuestManager.CharacterName.O : 0,
	QuestManager.CharacterName.ORGANS : 0,
	QuestManager.CharacterName.MASS : 0,
	QuestManager.CharacterName.LAMP : 0,
	QuestManager.CharacterName.MICHAEL : 0,
	QuestManager.CharacterName.ROBOT : 0,
	QuestManager.CharacterName.GIBBERISH : 0,
	QuestManager.CharacterName.IDEA : 0,
	QuestManager.CharacterName.BODHI : 0,
	QuestManager.CharacterName.SLIME : 1,
	QuestManager.CharacterName.GATE : 0,
	QuestManager.CharacterName.KING_2 : 1,
	QuestManager.CharacterName.INDIVIDUAL : 0,
	QuestManager.CharacterName.NORGANS : 0,
	QuestManager.CharacterName.SISYPHUS : 0,
	}
	
const PlayerReceive_DASP : Dictionary[QuestManager.CharacterName, int] = {
	QuestManager.CharacterName.KING_1 : 4,
	QuestManager.CharacterName.HORSE : 0,
	QuestManager.CharacterName.ASTRO : 0,
	QuestManager.CharacterName.SNOWMAN : 0,
	QuestManager.CharacterName.GREASE : 0,
	QuestManager.CharacterName.DEER : 1,
	QuestManager.CharacterName.O : 1,
	QuestManager.CharacterName.ORGANS : 3,
	QuestManager.CharacterName.MASS : 21,
	QuestManager.CharacterName.LAMP : 0,
	QuestManager.CharacterName.MICHAEL : 0,
	QuestManager.CharacterName.ROBOT : 0,
	QuestManager.CharacterName.GIBBERISH : 0,
	QuestManager.CharacterName.IDEA : 0,
	QuestManager.CharacterName.BODHI : 2,
	QuestManager.CharacterName.SLIME : 0,
	QuestManager.CharacterName.GATE : 0,
	QuestManager.CharacterName.KING_2 : 0,
	QuestManager.CharacterName.INDIVIDUAL : 0,
	QuestManager.CharacterName.NORGANS : 0,
	QuestManager.CharacterName.SISYPHUS : 0,
	}


# debug dialog for expedited traversal
const debug_initial : PackedStringArray = [
	"initial 1",
	"initial 2",
	]
const debug_give : PackedStringArray = [
	"give 1",
	"give 2",
	]
const debug_receive : PackedStringArray = [
	"receive 1",
	"receive 2",
	]
const debug_post : PackedStringArray = [
	"post 1",
	"post 2",
	]
const debug_easter : PackedStringArray = [
	"easter 1",
	"easter 2",
	]
const debug_lines : Array[PackedStringArray] = [
	debug_initial,
	debug_give,
	debug_receive,
	debug_post,
	debug_easter,
	]
const debug : Dictionary[QuestManager.CharacterName, Array] = {
	QuestManager.CharacterName.KING_1 : debug_lines,
	QuestManager.CharacterName.HORSE : debug_lines,
	QuestManager.CharacterName.ASTRO : debug_lines,
	QuestManager.CharacterName.SNOWMAN : debug_lines,
	QuestManager.CharacterName.SISYPHUS	: debug_lines,
	QuestManager.CharacterName.GREASE : debug_lines,
	QuestManager.CharacterName.DEER : debug_lines,
	QuestManager.CharacterName.GATE : debug_lines,
	QuestManager.CharacterName.O : debug_lines,
	QuestManager.CharacterName.ORGANS : debug_lines,
	QuestManager.CharacterName.MASS : debug_lines,
	QuestManager.CharacterName.LAMP : debug_lines,
	QuestManager.CharacterName.NORGANS : debug_lines,
	QuestManager.CharacterName.MICHAEL : debug_lines,
	QuestManager.CharacterName.ROBOT : debug_lines,
	QuestManager.CharacterName.INDIVIDUAL : debug_lines,
	QuestManager.CharacterName.GIBBERISH : debug_lines,
	QuestManager.CharacterName.IDEA : debug_lines,
	QuestManager.CharacterName.BODHI : debug_lines,
	QuestManager.CharacterName.SLIME : debug_lines,
	QuestManager.CharacterName.KING_2 : debug_lines,
	}

@export var use_debug_lines : bool = false

var already_tweened : bool = false #text box gd references this
var is_dialogue_active : bool = false
var can_advance_line : bool = false

# lock flags
var horse_lock : bool = true
var sisyphus_lock : bool = true
var gate_lock : bool = true
var king2_lock : bool = true

var current_npc : QuestManager.CharacterName
var dialogue_state : CONV_STATE = CONV_STATE.FINISHED

var give_flag : bool = false
var give_point : int
var receive_flag : bool = false
var receive_point : int

var dialogue_lines : Array[String] = []
var current_line_index : int = 0

var hud_overlay : CanvasLayer
var Map : TextureRect
var text_box_scene : Resource = preload("res://Scenes/DialogueManager/text_box.tscn")
var name_tag_scene : Resource = preload("res://Scenes/DialogueManager/name_tag.tscn")
var name_tag : MarginContainer
var text_box : MarginContainer
var sfx : AudioStream
var dialogue_finished_sfx : AudioStream


func reset_manager() -> void:
	is_dialogue_active = false
	if name_tag:
		name_tag.exit_tween()
	if text_box:
		await text_box.close_text_box()
		text_box.queue_free()
	if name_tag:
		name_tag.queue_free()
	already_tweened = false
	give_flag = false
	receive_flag = false
	give_point = 0
	receive_point = 0
	current_line_index = 0
	dialogue_lines = []
	dialogue_state = CONV_STATE.FINISHED


func reset_locks()-> void:
	horse_lock = true
	sisyphus_lock = true
	gate_lock = true
	king2_lock = true


func _input(event):
	if event.is_action_pressed("advance_dialogue") and is_dialogue_active and can_advance_line:
		var NextIndicator = text_box.next_indicator
		if NextIndicator.get_child(0).visible:
			current_line_index += 1
			if give_flag:
				if current_line_index == give_point:
					dialogue_state = CONV_STATE.PLAYER_GIVE
					emit_inventory_signal_by_conv_state(CONV_STATE.PLAYER_GIVE)
					give_flag = false
				else:
					dialogue_state = CONV_STATE.PLAYER_LISTEN
			elif receive_flag:
				if current_line_index == receive_point:
					dialogue_state = CONV_STATE.PLAYER_RECEIVE
					emit_inventory_signal_by_conv_state(CONV_STATE.PLAYER_RECEIVE)
					receive_flag = false
				else:
					dialogue_state = CONV_STATE.PLAYER_LISTEN
			else:
				dialogue_state = CONV_STATE.PLAYER_LISTEN
				if QuestManager.has_completed(QuestManager.CharacterName.GATE):
					planet_state_change.emit()
			if current_line_index >= dialogue_lines.size():
				is_dialogue_active = false
				if name_tag:
					name_tag.exit_tween()
				await text_box.close_text_box()
				text_box.queue_free()
				already_tweened = false
				give_flag = false
				receive_flag = false
				give_point = 0
				receive_point = 0
				current_line_index = 0
				if name_tag:
					name_tag.queue_free()
				dialogue_lines = []
				dialogue_state = CONV_STATE.FINISHED
				if current_npc == QuestManager.CharacterName.CREDITS:
					for node in get_tree().root.get_children():
						if node.name == "Victory Scene":
							await node.end_sequence()
			else:
				
				text_box.queue_free()
				show_text_box()


## TODO placeholder documentation
func start_dialogue(CanvasLayer_in : CanvasLayer, planet_id : QuestManager.CharacterName, voice_sfx: AudioStream) -> void:
	# DEBUG dialog switcher for fast text
	var used_lines : Dictionary[QuestManager.CharacterName, Array]
	if use_debug_lines:	
		used_lines = debug
	else:
		used_lines = all_lines
	if not is_dialogue_active and planet_id == QuestManager.CharacterName.CREDITS:
		current_npc = planet_id
		dialogue_lines.append_array(used_lines[current_npc][0])
		#time count
		dialogue_lines.append_array(used_lines[current_npc][2])
		var time_res : String = "You've helped everyone in " + Stopwatch.get_time() + "!!"
		dialogue_lines.append(time_res)
		#honk count
		var honk_count : String = "You've honked " + HonkCounter.get_honks_string() + " times!"
		dialogue_lines.append(honk_count)
		dialogue_lines.append_array(used_lines[current_npc][1])
		is_dialogue_active = true
		dialogue_state = CONV_STATE.PLAYER_LISTEN
		sfx = voice_sfx
		show_text_box()
		
	if not is_dialogue_active:
		is_dialogue_active = true
		hud_overlay = CanvasLayer_in
		hud_overlay = $/root/MainScene/HUDOverlay
		Map = $/root/MainScene/HUDOverlay/Map
		name_tag = name_tag_scene.instantiate()
		hud_overlay.add_child(name_tag)
		name_tag.get_child(1).get_child(0).text = Character_Names[planet_id]
		dialogue_state = CONV_STATE.PLAYER_LISTEN
		sfx = voice_sfx
		# DEBUG alias for clarity 
		current_npc = planet_id
		var first_meeting : bool = not QuestManager.has_met(current_npc)
		if QuestManager.has_completed(QuestManager.CharacterName.KING_2):
			dialogue_lines.append_array(used_lines[current_npc][4])
		elif QuestManager.has_completed(current_npc):
			dialogue_lines.append_array(used_lines[current_npc][3])
		elif not first_meeting and not QuestManager.requirements_met(current_npc) :
			dialogue_lines.append_array(used_lines[current_npc][0])
		else:	
			if first_meeting:
				QuestManager.set_met(current_npc)
				dialogue_lines.append_array(used_lines[current_npc][0])
				give_point = used_lines[current_npc][0].size()
				receive_point = used_lines[current_npc][0].size()
			
			match (current_npc):
				QuestManager.CharacterName.GREASE, QuestManager.CharacterName.ORGANS : # gives but does not receive, no conditions
					receive_flag = true
					dialogue_lines.append_array(used_lines[current_npc][2]) 
				QuestManager.CharacterName.BODHI : # gives but does not receive, conditions
					if QuestManager.requirements_met(current_npc):
						receive_flag = true
						dialogue_lines.append_array(used_lines[current_npc][2])
				QuestManager.CharacterName.NORGANS, QuestManager.CharacterName.INDIVIDUAL, QuestManager.CharacterName.KING_2: # node receives and has no give
					if QuestManager.requirements_met(current_npc):
						give_flag = true
						dialogue_lines.append_array(used_lines[current_npc][1])
				QuestManager.CharacterName.KING_1, QuestManager.CharacterName.MASS: # only require meetings, then will give
					if first_meeting:
						horse_lock = false
						door_unlock.emit()
					if QuestManager.requirements_met(current_npc):
						receive_flag = true
						dialogue_lines.append_array(used_lines[current_npc][2])
				QuestManager.CharacterName.SISYPHUS, QuestManager.CharacterName.GATE: # receive only, unlocks door
					if QuestManager.requirements_met(current_npc):
						give_flag = true
						dialogue_lines.append_array(used_lines[current_npc][1])
						match (current_npc):
							QuestManager.CharacterName.SISYPHUS:
								sisyphus_lock = false
								door_unlock.emit()
							QuestManager.CharacterName.GATE:
								gate_lock = false
								door_unlock.emit()
								change_king.emit()
				_: # exchange branch - NPC gives and receives when reqs (completion) met
					if QuestManager.requirements_met(current_npc):
						give_flag = true
						receive_flag = true
						dialogue_lines.append_array(used_lines[current_npc][1])
						dialogue_lines.append_array(used_lines[current_npc][2])
						if current_npc == QuestManager.CharacterName.SLIME:
							king2_lock = false
			
			if give_flag:
				give_point += PlayerGive_DASP[current_npc]
			if receive_flag:
				receive_point += PlayerReceive_DASP[current_npc]
			if give_flag and receive_flag:
				receive_point += used_lines[current_npc][1].size()
			if give_flag and give_point == 0:
				dialogue_state = CONV_STATE.PLAYER_GIVE
				emit_inventory_signal_by_conv_state(CONV_STATE.PLAYER_GIVE)
				give_flag = false
			if receive_flag and receive_point == 0:
				dialogue_state = CONV_STATE.PLAYER_RECEIVE
				emit_inventory_signal_by_conv_state(CONV_STATE.PLAYER_RECEIVE)
				receive_flag = false
		
		show_text_box()


func emit_inventory_signal_by_conv_state(pending_animation : CONV_STATE) -> void:
	if not QuestManager.has_completed(current_npc):
		QuestManager.set_completed(current_npc)
		Map.set_completion_sticker(current_npc)
		if current_npc != QuestManager.CharacterName.GATE:
			planet_state_change.emit()
	match pending_animation:
		CONV_STATE.PLAYER_RECEIVE:
			request_item_add.emit(current_npc)
		CONV_STATE.PLAYER_GIVE:
			request_item_remove.emit(current_npc)


func show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	hud_overlay.add_child(text_box)
	text_box.display_text(dialogue_lines[current_line_index], sfx)
	can_advance_line = false


func _on_text_box_finished_displaying():
	can_advance_line = true
