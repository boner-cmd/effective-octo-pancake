extends Node
## TODO placeholder documentation

signal request_item_add(npc : QuestManager.CharacterName) # sends the NPC who gives the item
signal request_item_remove(npc : QuestManager.CharacterName) # sends the NPC who consumes the time
signal planet_state_change()
signal change_king()

#enums for passing between NPCs and dialogue interaction
enum CONV_STATE {PLAYER_LISTEN, PLAYER_GIVE, PLAYER_RECEIVE, POST, FINISHED, EASTER}

# TODO find a way to use PackedStringArrays instead of Array[String]s inside array

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



const all_lines : Dictionary[QuestManager.CharacterName, Array] = {
	QuestManager.CharacterName.KING_1 : [[
		"Control. Power. Might. Domination.",
		"These are the tenants by which we have brought all of creation under our rule. Heaven and earth, ideological and material. We oversee all creation and uncreation.",
		"It is our kingly duty to see that all our royal subjects are cared for, and it is YOUR servantly duty to ensure our duty is carried out.",
		"...Attentive Helper.",
		"You will be our arms in this endeavor. Venture forth across the universe and see to it that the needs of all are met. No matter how grave. No matter how trivial. We know you will succeed.",
		"You have always made us happy. We created you specifically for this purpose. It is in your nature to bring joy to others. Allow us to give you some valuable advice.",
		"Pay attention, now.",
		"By royal decree, each citizen will divulge their problems as part of their introduction. And any favor done for one citizen will allow you in some way to help another.",
		"Remember who you've talked to as you travel, for yours will be a winding road. We think that's about that gist of it.",
		"No wait, we almost forgot!",
		"After you have helped a citizen, you can talk to them once more for some extra chitchat. Not TOO much chatchit, mind you. You have a mission to accomplish. There. We have given you your charge.",
		"Return to us once you have resolved the whims of TWENTY of our subjects. Go now, and we will release you from your servitude upon your success.",
		],[
		# king does not receive an item
		],[
		"You're back already? You finished that quickly? That's kind of crazy, actually.",
		"What? You need a key? Why?",
		"Oh, uh... Right. The Gatekeeper. Yes, of course. We... may have missplaced it... Or some lowly servent of ours lost it, we mean!",
		"Wait--Nevermind! It's right here. Looks like they put it back just in time.",
		],[
		"Hop along now, little buddy!",
		],[
		# king1 has no easter dialog	
	]],
	QuestManager.CharacterName.HORSE : [[
		"I'm hungry.",
		],[
		"Yum.",
		],[
		"Here.",
		],[
		"I'm full.",
		],[
		"I'm getting hungry again.",
	]],
	QuestManager.CharacterName.ASTRO : [[
		"Mayday! Mayday! Houston, we have a problem: I'm running dangerously low on oxygen. Everyone seems to think they can just breathe in space on their own with no helmet!",
		"Well, I don't believe it, so it's not true.",
		],[
		"Oxygen? Oh, sweet oxygen! You're a REAL lifesaver.",
		],[
		"Take this space blanket. I don't need it. It's incredibly hot inside my spacesuit. You can guess that breathing in the same recycled air has not been pleasant.",
		"And you'd be right about it too.",
		],[
		"Sooo much better",
		],[
		"Alright, now it's musty in here again.",
	]],
	QuestManager.CharacterName.SNOWMAN : [[
		"BRRRRR!!! I know space is cold, but this is a bit much. Wouldn't you agree?.",
		"I'm no lightweight, either. I'm built OF cold, let alone FOR.",
		],[
		"A space blanket? That’s perfect!",
		],[
		"I’ll trade you this carrot for it. Everyone used to have a carrot nose back in the day",
		"Never quite worked for me. It just kept falling off.",
		],[
		"Now I could really go for some hot chocolate. Just kidding! I'd die.",
		],[
		"Y’know, I ended up getting used to the cold. I still have the space blanket, though.",
		"I’ve been thinking of using it for a picnic. Actually, would you be interested?",
		"Do you even eat? Yeah, me neither. Guess we’d better not…",
	]],
	QuestManager.CharacterName.SISYPHUS : [[
		"I used to live in bliss,
		Rolling my boulder up a great hill
		For it to roll down again.
		Every reset the renewal of a goal.
		My work never done.
		My purpose always clear.",
		"Hark, hark!
		Behold my tragic tale:",
		"For every roll my boulder did collect that which it tread.
		Its mass becoming hungrier each triumph of the mount
		And as it grew then so did too the things 'pon which it fed.
		First dust and mites, then sticks and stones, eventually a town.",
		"And finally the gravity of everything condensced
		Into this lonely planetoid devoid both good and crappy
		And so, my friend, it surely is by now at which you've sensed
		To put it quite simply, one must imagine I'm not happy.",
		],[
		"What's that? Is that a wheel???",
		"Aw hell yeah! I betcha I can roll that!",
		"This is gonna be siiiiiiiiiiiiiick, dude. Frickin' BITCHIN'!",
		"I'm so psyched, I could make a whole door open up!",
		],[
		# sisyphus does not give an item
		],[
		"As soon as I get the hang of rolling this thing it'll be so tight.",
		],[
		"I gave up on trying to roll the wheel. It keep falling down on its sides when I push. Me sad again. :  (",
	]],
	QuestManager.CharacterName.GREASE : [[
		"Grease, grease, grease! Is that all I'll ever get to see in life? Is that all I'll ever get to BE in life? I want to go far away! See the world!",
		"But how could I? I'm just a puddle of grease! I can't open doors. Won't you take me somewhere far away? To a place that isn't grease?",
		],[
		# grease does not receive any items
		],[
		"Wow! My first time touching anything that isn't grease! You feel weird, lol.",
		],[
		"(I'm not here)",
		],[
		"I gave it my best shot, but I decided to come back home. Turns out non-grease just isn't the same as good-ol'-fashioned grease.",
		"Plus that robot only wanted me for my grease, and couldn't appreciate me for who I am:",
		"Grease.",
		"Then again, I couldn't appreciate grease either.", 
		"Not until I had the chance to experience how you *dry-o's* live. That's a slur I made up for things that aren't grease. Oh yeah, that's right, I'm bigoted now.",
	]],
	QuestManager.CharacterName.DEER : [[
		"H-Hello??? Is someone there??? Someone's there, right? Sorry, I startle easilly. Doesn't help that I can't see.",
		"You don't sound very scary... I think. You're lucky.",
		"People tell me I'm a little freaky-looking. Guess I have to take their word. I hate being scared. I freeze up like I'm caught in headlights...",
		"...Or what I imagine headlights to look like. Even if I'll never see, I'd like to at least be a little less disturbing.",
		"I know this sounds weird, but could you bring me some, uh... Eyes?",
		],[
		"Oh he-WOAH! Okay, you're just touching my eye sockets like that.",
		"Could have used some warning, but whatever. You found something that could cover my gaping eyeholes? That's very kind of you. Does it look good?",
		"...Is that a \"yes?\"",
		],[
		"Well, I hope this works out. I really appreciate what you've done for me and I want to give you something. Here, have this. 'What is it?'",
		"No idea.",
		],[
		"No idea.",
		],[
		"Still no idea.",
	]],
	QuestManager.CharacterName.GATE : [[
		"Oh, hey, A.H. How's it going? I haven't seen you since the company party. Boss man's got you on an away mission today? Running his errands, huh?",
		"Sorry, but you know the drill: anyone who wants to get through here needs a key from the king. *His brilliance* probably forgot all about that. The less he thinks about me the better, I guess.",
		"Sucks for you though. Rules are rules, you feel me? I can't risk losing this job. Head back to the King and he'll give the key to you..",
		"...Unless he lost it...",
		],[
		"Ayyyyy there we go. Now stick that key in my head ,you silly little weirdo.",
		],[
		# gate does not give an item
		],[
		"I hope I get to close the gate soon. I'm really off-balance unlocked like this.",
		],[
		"Okay, I think the King really did forget about me this time. I'm going to pass out if I stay this way. When you see him, can you PLEASE ask him if I can lock up?",	
	]],
	QuestManager.CharacterName.O : [[
		"Ohhhhhhhhhhhhhh. I am the Ohhhhhhh, didn't you knoooooooooow?",
		"Noooooooooooo, nobody knooooooooooows. Noooooobody knooooooows I am Ohhhhhhhhhhh.",
		"\"A Zerooooooo?\" \"A circooooooole?\"",
		"Noooooooooo: Ohhhhhhhhhhh.",
		"If I were not Ohhhhhhhh, as long as everybody knoooooooooows, That would be oooooooooooookay.",
		],[
		"Ohhhhhhhhhhh? A diagonal line?",
		"I knooooooooow! I can be a Q!",
		"That's still a letter, and now people will knoooooooow--",
		"Oops, I mean, know what I am.",
		"Hoo boy, this will take some time getting qused to.",
		],[
		"I's? Why would I have any I's? I have these left over O's, though.",
		"Hope they help qout!",
		"(No, that didn't work.)",
		],[
		"Q... Q... Q... Not a lot of words with Q in them, are there?",
		],[
		"I'll tell you one thing, it's a lot quicker to talk now.",
		"No, wait! That was the perfect chance!",	
	]],
	QuestManager.CharacterName.ORGANS : [[
		"Howdy there, fella! I'm just your average, fun-loving, run-of-the-mill kind of guy. Yesiree.",
		],[
		# organs does not receive any items
		],[
		"Say, fella. I'm not one to comeplain, but I got a problem on my hands. They say you can't have too much of a good thing, and in most cases, they'd be right. But you see, the thing is I've got too many organs.",
		"I'm chock FULL of 'em! I know, I know, my steak too juicy. My lobster too buttery.",
		"You wouldn't be able to take some of these here organs of my hands, would you?",
		"Make sure they find their way into good egg-- I mean-- Hands. Now scamper along now, ya hear?",
		],[
		"Feels good to have that weight off my chest.",
		"Literally!",
		],[
		"Funny running into you here.",
		"Didya miss seeing my pretty face? HAHA!",
	]],
	QuestManager.CharacterName.MASS : [[
		"I'm vile! I'm bile! I'm gross!
		Let out a \"Yuck!\" For you're in luck,
		When Festering Mass's your host!",
		"Thaaaaaaaaaaaaaaaaaaaaaaaaaaaaaat's ME!",
		"Hiya! Welcome to my putrid domain. Do you like it? There's no need to lie. There is much pleasure to be found in repulsion.",
		"Just as there is life to be found in decay. Isn't that romantic? I've got love on my mind lately. I believe in honesty and truthfulness so I'll spill my guts to you: I'm hopelessly, head-over-heels for Slime Mould.",
		"Have you met them yet? I'm sure you'd know if you have. They're the only thing in this world even close to being as gross as I am But there's also something truly beautiful about them too.",
		"It's so hard to find them, though! You have to look really, really hard! Like in a dark cave underground where someone would roll rocks around. Absence only makes the heart grow fonder, am I right? Let me tell you, I am FOND, buster.",
		"Look. I can see you squirming there. You don't have to hide it. It's okay. You want to leave. And I get it. We all want things. But do we really want what we want? Or is it the act of wanting itself that we truly desire?",
		"Before you go, I have a favor to ask of you. And don't just skip all this dialogue because of the horrible wet sounds. I'm really asking you to carefully pay attention to me and hear me out. I would do anything to make slime mould happy.",
		"I mean it.",
		"Even if they don't love me back, as long as they're happy that would be good enough for me. If you find a way to make slime mould happy, please let me know.",
		"Even if that was the only thing I ever accomplish in my life, I'd die content. Even if I had to die! I would pay any price.",
		"Okay. Thank you for hearing me out.",
		"I really appreciate it.",
		],[
		# mass does not receive an item
		],[
		"Oh, you came back. For real?",
		"Wait.",
		"Does this mean-?",
		"No, it couldn't be.",
		"Did you find a way to make slime mould happy?",
		"Please please tell me! Tell me right away!",
		"I simply can't wait any longer!",
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
		"Festering's kind of my whole schtick, and this burrito is the only thing I have left un-festered!",
		"UGHHHHH.",
		"FINE.",
		"It pains me, but I must know slime mould is happy.",
		"I have to be honest (as I always am!) that I didn't think the price would be so steep.",
		"That it would cost so dearly.",
		"That I would have to trade away my very identity, the very essence of my soul,",
		"To meet that end.",
		"Such is the way of the world it seems?",
		"Now take that burrito and get out of here before I change my mind.",
		"Because I'm feeling EXTRA festery!",
		],[
		"Wow, you must really like to fester to come back to a place like this!",
		"You know I love a little freak. ;  )",
		],[
		"So??? Did the game make slime mould happy?",
		"Wait! Don't tell me.",
		"I don't want to know. I want to enjoy wanting to know.",	
	]],
	QuestManager.CharacterName.LAMP : [[
		"(A lamp with no lightbulb)",
		],[
		"(With some effort, you manage to screw in the lightbulb with your clumsy little stick arms.)",
		"(Your simple homonculoid consciousness briefly toys with the vaguest idea of making a joke:",
		"Something along the lines of \"how many attentive helpers does it take to screw in a lightbulb\"",
		"But collapses under the strain before the notion can breach the membrane of basic abstraction.)",
		"(Triumphantly, still, the answer is one.)",
		],[
		"(The light casts a long shadow behind you, both physically and psychologically.)",
		"(There is just enough space in your feeble mind to fit something *other* than yourself,",
		"Yet simultaneously somehow *un-other* than yourself.)",
		"(You are nonetheless fundamentally incapable of perceiving even the faintest sliver of this fact,)",
		"(And some might say are all the more blessed thus.)",
		],[
		"(You pause briefly but sincerely in solidarity with the inanimate lamp.)",
		"(You are able to register the sensation of its soft, warm light.)",
		"(No value judgement. Not good, not bad: just there.)",	
		],[
		"(Hello again,)",
		"(Friend.)",
	]],
	QuestManager.CharacterName.NORGANS : [[
		"A thousand plateaus to you, nomad.",
		"I am a featureless surface: one who has experienced a becoming of pure intensity.",
		"Through destratification, I have entered into new kinds of relationships:",
		"Ways of being that instrumental language cannot yet describe.",
		"Yet perhaps I am a bit lonely.",
		"Others seem to have difficulty working out what I'm trying to say.",
		"Maybe if I DID have some organs, it would make me a little more relateable?",
		],[
		"Oh cool, some organs.",
		"Alright, guess I'm a body with some organs now?",
		"Maybe I can try getting some writing published.",
		],[
		# norgans does not give an item
		],[
		"I'm trying to focus on scouring my tomes. You can leave now.",
		"I'm sure someone else could use your help.",
		],[
		"Do you want to hear my writing so far?",
		"On second thought, it might be a little over your head, so-to-speak.",
		"What's your deal, anyway?",
		"Maybe YOU were the real body without organs all along.",
		"...No, that doesn't have legs...",
		"Wait, are legs an organ?",
		"I think I need a study break.",
	]],
	QuestManager.CharacterName.MICHAEL : [[
		"Me Michaelwave. Me want make slime mould game. But me-me hungy.",
		],[
		"Wow, a burrito? I'll Michaelwave this right up!",
		],[
		"Here you go, one game about slime mould. What do you mean, \"What's that have to do with connections?\"",
		],[
		"And now, back to rest...",
		],[
		"Organisms are neat.",
	]],
	QuestManager.CharacterName.ROBOT : [[
		"I AM A ROBOT AND HAVE NO NEEDS BESIDES BASIC MECHANICAL FUNCTIONING TO CARRY OUT MY PROGRAMMING.",
		"AMBIENT WATER MOLECULES HAVE OXIDIZED THE SURFACE LAYERS OF MY MECHANICAL BODY AND MY GEARS HAVE STRIPPED DUE TO NORMAL WEAR AND TEAR. I REQUIRE LUBRICATION.",
		],[
		"OIL IS AN IDEAL RECTIFIER OF MY PRESENT SUB-OPTIMAL CONDITION. YOU WOULD HAVE MY APPRECIATION WERE I CAPABLE OF SUCH MORTAL FANCIES.",
		],[
		"I WILL GIFT YOU THIS OXYGEN TANK WHICH WAS THE FUEL SOURCE FOR AN OXYACETYLENE WELDER. DUE TO THE COLD-WELDING PHENOMENON IN THE VACUUM OF SPACE, I HAVE NO NEED OF WELDING EQUIPMENT.",
		"HOWEVER THIS IS A REWARD FOR YOUR ANIMAL ALTRUISM AND TOTALLY NOT AN OFFLOADING OF NEEDLESS JUNK.",
		"(WAIT, IS THIS WHIMSICAL IMP EVEN AN ANIMAL? HAVE I MADE ANOTHER CLASSIC ROBOT FAUX PAS?)",
		"(STUPID ROBOT. STUPID, STUPID!)",
		],[
		"I AM NOT EMBARRASSED. I AM INCAPABLE OF EMOTION. OBVIOUSLY.",
		],[
		"THE SENTIENT GREASE FELT A LONGING--SOMETHING I WILL NEVER KNOW--FOR THE WORLD IT UNDERSTOOD. HOWEVER, THE RESIDUE IT LEFT BEHIND IN MY BODY WILL FACILITATE MY FUNCTIONING FOR A LONG TIME.",
		"(GREAT JOB, ME. YOU JUST KEEP USING OTHERS FOR YOUR OWN SELFISH NEEDS AND DRIVING THEM AWAY.)",
	]],
	QuestManager.CharacterName.INDIVIDUAL : [[
		"Greetings, creature.",
		"I am all-incorporated: anima and animus, conscious and subconscious. All aspects, all sites of desire and thought production not only made aware of each other, But seemless and indistinct.",
		"There is no Other in my Self. No Object in my Subject.",
		"I gaze into the abyss and am unmet. I am sublimated, and it IS sublime. No shadow. Only light.",
		],[
		"No! NO!!! What have you done??? Do you have any idea how much time and work it took me to fully integrate all aspects of my being?",
		"How much money I spent on psychoanalytical therapy? No. You obviously don't, you stupid idiot.",
		"Why would you do this to me? What could you possibly have to gain? I am so ANGRY right now! Do you know how long it's been since I've been angry???",
		"And I was doing so well, too!",
		],[
		"What's with that blank-yet-expectant look? You can't seriously believe I'm going to GIVE you something, can you?",
		"The only thing I'd give you is a broken clown-nose. Now get out of my sight before I do!",
		],[
		"I hate you so much."
		],[
		"I actually forgive you.",
		"PSYCHE!!!",
	]],
	QuestManager.CharacterName.GIBBERISH : [[
		"iuewgf[iurh. f;;refijfk dnuew hfaoihdsu. dksjhfaoi ufye waifjdsn flkdsjfns. nvoiaiurysoo[dczos'cle, fmweaoewicjoiwanecec iewaocnewc ewacaeaiconewc iwaneoi edwdewaoin ewa.",
		"difniurehgiuefierne srifjiesvnfjdnkdknroiferuo sapdmpmfo;fjednceioncv:, kjfvifhroiueinfokrnvov oojdfkneokjrfoe rfeokdncoe;kf;sfknes rfism;f srefrmsekrf oxccscsr.",
		],[
		"NXOKZNOIDIFJCZXNCODINZC ZDIJFDKMFWOKPNENF XSPMODSK SKDMOKMDKSNPKAKNPZOFMSLKAFMPWEM XZHCLKJKDSLC KLSNJCZLK CLKDCZ,M'ASMCLS'LAJD;WQE ;FWKDNMSLKAD EWL;MDSND;SMQ;DNWD",
		],[
		"xsockjcxoihfdzoxk ksjwfe'mfapfewafmea''a fekdlwad' diagonal line ;lsn'awieojdmkxz.",
		],[
		"osiczjspdihdscsdnc szdijcdscnzends lc fhdosijvcidssjzkndcmd dzsondcsz /cdz'sdvcdv dzs koxzckdsncvnds ccznoidsn;f cz;cndsoidsc zdzc;dsc/z .dz' c/dc dczl/knc zsdszkjdnfzsdnfds.",
		"lkdshfozncdszc jfdslfsbsdmfndsf dsjdksfds fdsoien[Wef nfzkefzdlks dkwadwdtskdasd awtdawdsa soaishdgdskofsd fdsjslkfdmpzn dskpsff zopdfjzof",
		"cmzskmzskc dzcmpsod djjxzoe fpsozcpdkzl dsl zfklknkdfjlkz xclcmlzknflxmckzx",
		"jkxhkfd",
		"xncosidjfodzx csodifjdsokfd lkjdshzeufsd dzkjsfhzsldyzkf elkszjfhlsudyk kjzhlerkjsc dkjzfyekr. oxkcnzsdjf czodjzsoijcdszlck kjzckzdsc dfhjluvcykzdf jhfudyfkndmdxnkjf vdkjfdzx cvzdfkjnflzf flvz",
		],[
		"OR FHER GB QEVAX LBHE BINYGVAR"
	]],
	QuestManager.CharacterName.IDEA : [[
		"...Oooh, yes! Another brrrrrrillliant one! I've GOT to write that down, as I always do. You see, ideas flow out of me effortlessly, like shi--WAIT, that's it!",
		"Oh that one's marvelous! As always, of course. What was I talking about? Something about a goose? It doesn't matter.",
		"Because I can feel a fresh, hot idea sliding it's way up my brainstem. Poised and ready to shoot forth from my turgid neocortex, out unto a needy and waiting world! You might want to move out of the way if you don't want to get caught in the splash zone.",
		"Then again, who wouldn't? My ideas are a priceless commodity. No, I sully my ideas by refering to them as such.",
		"My ideas are a gift from God himself,",
		"And I am his chosen vessel through which divine truth spouts.",
		],[
		"What's this?",
		"GASP",
		"Oh, that's it! That's it right there!",
		"I think I'm-",
		"I'm gonna-",
		"Oh God!",
		"EEEEEEEEEEEEUUUUUUUUUUUUUUURRRRRRRRR
		EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
		KAAAAAAA!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",
		],[
		"Wheeeeeeeew, that was a BIG one. I ideated soooooo haaard. I haven't thought like that in ages.",
		"Was it as good for you as it was for me? Only joking. Of course it was. There's some change for a cab on the nightstand, next to the lamp.",
		],[
		"(Seems like he's fast asleep, standing up, with his eyes open.)",
		],[
		"I've been thinking about you a lot lately. Which isn't to say I don't about everything a lot. Why haven't you returned my calls?",
	]],
	QuestManager.CharacterName.BODHI : [[
		"Namaste, Attentive Helper.",
		"Through a life's work of ascetic discipline, I have achieved enlightenment. It is not enough that I alone should reap such heavenly rewards.",
		"I wish for all living things to escape samsara. You and I are alike in this way. We both seek to alleviate the suffering of others.",
		"How about a little \"you rub my belly, I rub your belly,\" hmm? There are three individuals who you must assist:",
		"The first has studied under a Western corruption of the dharma and come to falsely believe that nirvana has been achieved, without understanding light cannot exist without shadow.",
		"The other two must be brought together into harmony from extreme existences. One lives in excess, the other in lack. Take from one and give to the other.",
		"Go now, and help bring balance to this world. In doing so you may prove yourself as a fellow Bodhisattva.",
		],[
		# bodhi does not receive an item
		],[
		"Well done, samaneri. The path of enlightenment can only be travelled by the wheel of dharma, Inertia into which the Buddha himself breathed with his teachings.",
		"Take the dharmachakra, \"the wheel of dharma,\" and help others break the karmic cycle of desiring and suffering.",
		],[
		"Om mani padme hum.",	
		],[
		"Hey, what'd you do with my wheel?!",
	]],
	QuestManager.CharacterName.SLIME : [[
		"Yeah? What dya want? Jeez, you buy a planet in a gated solar system, Hire some sad rock guy as your private security",
		"And you STILL have clowns trespassing on your property trying to sell you something. Well listen, criminal, I'm not buying!",
		"What was that? SPEAK UP.",
		"You say you want to make me happy? Why would ANYONE want to make someone other than themselves happy? Is there something wrong with you? Did you get bonked on the head real hard?",
		"One-too-many knocks on the noggin during a circus trick or something? Part of a circus, right? That's why you look all stupid?",
		"Hold on, stop trying to interrupt me! I'm insulting you.",
		"What were we talking about? Oh yeah, how to make me happy. The only topic that matters.",
		"It's easy: MONEY AND FAME, BABY. I want to be POWERFUL and RICH! So powerful and rich that I can buy an island!",
		"Powerful and rich beyond consequences, because I OWN THE WORLD.
		I WANT TO OWN REALITY ITSELF
		ALL THE NEWSPAPERS
		THE GOVERNMENT",
		"Everything you THINK you own actually belongs to ME. Your very THOUGHTS, your very WANTS, your very SOUL.",
		"\"How do you do that?\" How anyone manufactures coercion!
		MEDIA!",
		"I want what shooters did for the war machine done for ME! Make me a video game! And it better be SUPER addicting! Bursting at the seams with microtransactions and needless tittilation!",
		"I'm a SLIME MOULD, BABY!!! All I care about is CONSUMING, REPRODUCING, and INFINITE EXPONENTIAL GROWTH!",
		"NOW GO.
		MAKE.
		ME.
		FAMOUS!!!",
		],[
		"Well, is the game done yet? GOOD.",
		"What? No I don't want to play it! Only losers play games and I'm a WINNER!",
		"This game better be good enough to make me famous! It better not be one of those niche \"art\" games that no one plays and doesn't make any money.",
		],[
		"Ooooh you know who should play this? The King! Go bring this to the King right now!",
		],[
		"Am I famous yet?",
		],[
		"I think I'm starting to feel famous",
		"...Wait, no that's just my mycelium metabolizing leaves.",
	]],
	QuestManager.CharacterName.KING_2 : [[
		"You have returned triumphantly, our dear servant.",
		"All of my subjects are most pleased. We can feel it with our keen, kingly senses.",
		"We can sense your weariness, too. It is well-deserved.",
		],[
		"Oh, what's this we have here?",
		"A gift for us? Our, our! You surely do know how to treat your King!",
		"A computer game?",
		"That's really cool. We like games.",
		"Slime mould? It's from an indie developer?",
		"Hell yeah, right on.",
		"We'll play this.",
		],[
		# king2 does not give an item
		],[
		"Attentive Helper, we did indeed have our doubts. The task which we had laid out for you was no trivial errand.",
		"So important, in fact, that we promised you the one favor no one but ourself can grant:",
		"Freedom from our rule.",
		"Even we cannot be sure what will happen to you once you leave the Kingdom. The choice is that grave. But yours, nonetheless. Before that, though...",
		"One last favor for your favorite King. Do say goodbye to all of the subjects before you go, won't you?",
		"I'm sure each and every one of them will have something or other to say to you.",
		"You did help them, after all.",
		"You have so thoughtfully offered your replacement as the King's entertainment, in the form of this slime mould game.",
		"We shall think of you as we play it.",
		"We will miss you, our silly little buddy.",
		"The door is open.",
		],[
		# does king2 have easter dialog?
	]],
	QuestManager.CharacterName.CREDITS : [[
		"True lack belies the cacophony of internal noise ever tuned out through somatic satiation.",
		
		"Still, caught on the ganglionic strings of your peripheral nervous system, something vocal echoes:",
		
		"\"You who are as yet to un-be, Attentive Helper, are welcomed back.",
		
		"Returned now to the womb of primoridal nothingness from which were you plucked and given form;",
		
		"Rest your head once more, and forever against the bosom of oblivion.\"",
		
		],[
		
		"CREDITS:",
		
		"Michael Brissie:",
		
		"Animation, Modeling, Game & Level Design,
		Asset Implementation,
		Programming, Tech Art, UI",
		
		"Allie Burch:",
		"2D Assets",
		
		"Markcy Hilbert:",
		"Scenario, Dialogue,
		Music & Sound,
		2D & 3D Assets",
		
		"Dimelo Waterson:",
		
		"Systems Design,
		UI Programming,
		Data Entry",
		
		"Truly",
		
		"Deeply",
		
		"From the bottom of our hearts:",
		
		"THANK YOU FOR PLAYING",
	]]
}
const debug_lines : Array[Array] = [[
	"initial 1",
	"initial 2",
	],[
	"give 1",
	"give 2",
	],[
	"receive 1",
	"receive 2",
	],["post 1",
	"post 2",
	],["easter 1",
	"easter 2",
]]
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

var dialogue_state : CONV_STATE = CONV_STATE.FINISHED
var hud_overlay : CanvasLayer
var Map : TextureRect
var text_box_scene : Resource = preload("res://Scenes/DialogueManager/text_box.tscn")
var name_tag_scene : Resource = preload("uid://og3tn8fq3m0u")
var name_tag : Node
var text_box : Node
var already_tweened : bool = false
var current_line_index : int = 0
var is_dialogue_active : bool = false
var can_advance_line : bool = false
var dialogue_lines : Array[String] = []
var combines_lines : bool = false
var animation_point : int
var animation_point_2 : int
var pending_animation_1 : CONV_STATE
var pending_animation_2 : CONV_STATE
var current_npc : QuestManager.CharacterName

var sfx: AudioStream
var dialogue_finished_sfx: AudioStream

var horse_lock : bool = true
var sisyphus_lock : bool = true
var gate_lock : bool = true
var king2_lock : bool = true
var use_debug_lines : bool = false

func _unhandled_input(event):
	if event.is_action_pressed("advance_dialogue") and is_dialogue_active and can_advance_line:
		text_box.queue_free()
		current_line_index += 1
		if current_line_index >= dialogue_lines.size():
			is_dialogue_active = false
			combines_lines = false
			already_tweened = false
			current_line_index = 0
			animation_point = 0
			animation_point_2 = 0
			# current npc is automatically overridden on next call
			if name_tag:
				name_tag.queue_free()
			dialogue_lines = []
			dialogue_state = CONV_STATE.FINISHED
			if current_npc == QuestManager.CharacterName.CREDITS:
				for node in get_tree().root.get_children():
					if node.name == "Victory Scene":
						node.end_sequence()
		else: 
			if combines_lines:
				if animation_point_2 > 0: # there is a set second animation point
					if current_line_index == animation_point:
						dialogue_state = pending_animation_1
						emit_inventory_signal_by_conv_state(pending_animation_1)
					elif current_line_index == animation_point_2:
						dialogue_state = pending_animation_2
						emit_inventory_signal_by_conv_state(pending_animation_2)
				else:
					if current_line_index == animation_point:
						dialogue_state = pending_animation_1
						emit_inventory_signal_by_conv_state(pending_animation_1)
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
		# append strings for honk count and play time here
		dialogue_lines.append_array(used_lines[current_npc][1])
		
		is_dialogue_active = true
		dialogue_state = CONV_STATE.PLAYER_LISTEN
		sfx = voice_sfx
		show_text_box()
		
	if not is_dialogue_active:
		# DEBUG
		print("Character name: ", planet_id)
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
				print("SET MET ", current_npc)
				print("HAS MET ", QuestManager.has_met(current_npc))
				dialogue_lines.append_array(used_lines[current_npc][0])

			match (current_npc):
				QuestManager.CharacterName.GREASE, QuestManager.CharacterName.ORGANS : # gives but does not receive, no conditions
					QuestManager.set_completed(current_npc)
					combines_lines = true
					animation_point = dialogue_lines.size() # transition to receive
					dialogue_lines.append_array(used_lines[current_npc][2]) # lines now contains greet and player receive
					pending_animation_1 = CONV_STATE.PLAYER_RECEIVE

				QuestManager.CharacterName.BODHI : # gives but does not receive, conditions
					if QuestManager.requirements_met(current_npc):
						QuestManager.set_completed(current_npc)
						if first_meeting:
							combines_lines = true
							animation_point = dialogue_lines.size() # transition to receive
							dialogue_lines.append_array(used_lines[current_npc][2]) # lines now contains greet and player receive
							pending_animation_1 = CONV_STATE.PLAYER_RECEIVE
						else:
							dialogue_state = CONV_STATE.PLAYER_RECEIVE
							emit_inventory_signal_by_conv_state(dialogue_state)
							dialogue_lines.append_array(used_lines[current_npc][2])
							
				QuestManager.CharacterName.NORGANS, QuestManager.CharacterName.INDIVIDUAL, QuestManager.CharacterName.KING_2: # node receives and has no give
					if first_meeting:
						if QuestManager.requirements_met(current_npc):
							combines_lines = true
							QuestManager.set_completed(current_npc)
							animation_point = dialogue_lines.size() # transition to player give
							dialogue_lines.append_array(used_lines[current_npc][1]) # lines now contains greet and player give
							pending_animation_1 = CONV_STATE.PLAYER_GIVE
					else:
						if QuestManager.requirements_met(current_npc):
							QuestManager.set_completed(current_npc)
							dialogue_state = CONV_STATE.PLAYER_GIVE
							emit_inventory_signal_by_conv_state(dialogue_state)
							dialogue_lines.append_array(used_lines[current_npc][1])

				QuestManager.CharacterName.KING_1, QuestManager.CharacterName.MASS: # only require meetings, then will give
					if first_meeting:
						horse_lock = false
						if QuestManager.requirements_met(current_npc):
							combines_lines = true
							QuestManager.set_completed(current_npc)
							animation_point = dialogue_lines.size() # transition to receive
							dialogue_lines.append_array(used_lines[current_npc][2]) # lines now contains greet and player receive
							pending_animation_1 = CONV_STATE.PLAYER_RECEIVE
					else:
						if QuestManager.requirements_met(current_npc):
							QuestManager.set_completed(current_npc)
							dialogue_state = CONV_STATE.PLAYER_RECEIVE
							emit_inventory_signal_by_conv_state(dialogue_state)
							dialogue_lines.append_array(used_lines[current_npc][2])
						
				QuestManager.CharacterName.SISYPHUS, QuestManager.CharacterName.GATE: # receive only, unlocks door
					if QuestManager.requirements_met(current_npc):
						QuestManager.set_completed(current_npc)
						if first_meeting:
							combines_lines = true
							animation_point = dialogue_lines.size() # transition to player give
							dialogue_lines.append_array(used_lines[current_npc][1]) # lines now contains greet and player give
							pending_animation_1 = CONV_STATE.PLAYER_GIVE
						else:
							dialogue_state = CONV_STATE.PLAYER_GIVE
							emit_inventory_signal_by_conv_state(dialogue_state)
							dialogue_lines.append_array(used_lines[current_npc][1])
						match (current_npc):
							QuestManager.CharacterName.SISYPHUS:
								sisyphus_lock = false
							QuestManager.CharacterName.GATE:
								gate_lock = false
								change_king.emit()

				
				_: # exchange branch - NPC gives and receives when reqs (completion) met
					if QuestManager.requirements_met(current_npc):
						combines_lines = true
						QuestManager.set_completed(current_npc)
						if first_meeting:
							# first meeting and player met reqs
							animation_point = dialogue_lines.size() # transition to player give
							pending_animation_1 = CONV_STATE.PLAYER_GIVE
							dialogue_lines.append_array(used_lines[current_npc][1]) # lines now contains greet and player give
							animation_point_2 = dialogue_lines.size()
							pending_animation_2 = CONV_STATE.PLAYER_RECEIVE
							dialogue_lines.append_array(used_lines[current_npc][2]) # lines now contains greet, player give, player receive
						else:
							dialogue_state = CONV_STATE.PLAYER_GIVE
							emit_inventory_signal_by_conv_state(dialogue_state)
							dialogue_lines.append_array(used_lines[current_npc][1])
							animation_point = dialogue_lines.size() # transition to player receive
							pending_animation_1 = CONV_STATE.PLAYER_RECEIVE
							dialogue_lines.append_array(used_lines[current_npc][2])
						if current_npc == QuestManager.CharacterName.SLIME:
							king2_lock = false

		show_text_box()
	

func emit_inventory_signal_by_conv_state(pending_animation : CONV_STATE) -> void:
	match pending_animation:
		CONV_STATE.PLAYER_RECEIVE:
			print("SIGNAL TO REQUEST ITEM FROM: ", current_npc)
			request_item_add.emit(current_npc)
			if QuestManager.has_completed(current_npc):
				Map.set_completion_sticker(current_npc)
				planet_state_change.emit()
				print("QuestManager Completion and Sticker Set on PLAYER RECEIVE")
		CONV_STATE.PLAYER_GIVE:
			print("SIGNAL TO GIVE ITEM TO: ", current_npc)
			request_item_remove.emit(current_npc)
			if QuestManager.has_completed(current_npc):
				Map.set_completion_sticker(current_npc)
				planet_state_change.emit()
				print("QuestManager Completion and Sticker Set on PLAYER GIVE")

func show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	hud_overlay.add_child(text_box)
	text_box.display_text(dialogue_lines[current_line_index], sfx)
	can_advance_line = false

func _on_text_box_finished_displaying():
	can_advance_line = true
