// {LIST has VAR} only if LIST = (VAR) or until LIST += VAR
LIST suspects = (securityGuard), museumOfMummiesOwner, exWife, museumJanitor, family, familyFather, busDriver, schoolTeacher, schoolStudents, soccerPlayers, regionalMuseumCurator
LIST unlockedLocations = museumOfMummiesOwnerHome, janitorHome, familyHome, highSchool, regionalMuseum
LIST unlockedChoices = askAboutKey, askAboutInsurance, askAboutAssault, askAboutIncident, askAboutVan, speakWithJanitor, askAboutSickJanitor, examineExhibitPhoto
LIST carriedItems = key, wrongWarrant, correctWarrant

// Ink variables (declared above) are camelCase. All other variables are underscore_case

// All # tags are used by EvaluateTags() of InkManager.cs to change background or character image.

// If a knot or stich has any choices that loop back to itself, the intro text must be attached to each outside divert going there, so the intro text isn't repeated every choice loop (so when you're asking someone questions the intro text isn't repeated each time).


The Case of the Missing Mummy
+[New Game] You reach the Museum of Mummies in the afternoon. The security guard lets you in. -> museum_of_mummies


== all_locations ==
# LOCATION all_locations
+[Go to the Museum of Mummies] -> museum_of_mummies
+{unlockedLocations has museumOfMummiesOwnerHome}[Go to the Museum of Mummies owner's home] The Mummy Museum owner's lavish home is atop the cliffs overlooking Guanajuato. There's a small, outdoor garden along one side of the house. -> museum_of_mummies_owner_home
+{unlockedLocations has museumOfMummiesOwnerHome}[Go to the owner's home] The Mummy Museum owner's lavish home is atop the cliffs overlooking Guanajuato. There's a small, outdoor garden along one side of the house. -> museum_of_mummies_owner_home
+{unlockedLocations has janitorHome}[Go to the janitor's home] -> janitor_home
+{unlockedLocations has familyHome}[Go to the family's home] -> family_home
+{unlockedLocations has highSchool}[Go to the high school] -> high_school
+{unlockedLocations has regionalMuseum}[Go to the Regional Museum of Guanajuato] -> regional_museum
+[Go to the police station] -> police_station


/*--------------------------------------------------------------------------------
    Museum of Mummies
--------------------------------------------------------------------------------*/
== museum_of_mummies ==
# LOCATION museum_of_mummies
The museum is dark except for the lit exhibits. The stone floor and ceiling is like that of a tomb.
+[Enter the crime scene] -> museum_of_mummies.crime_scene
+[Speak with the security guard] The security guard sits at a desk facing the entrance. His eyes are tired, but it's clear that recent events have him on edge. Atop the desk is a sign-in sheet. -> museum_of_mummies.security_guard
+[Leave the Museum of Mummies] -> all_locations
+[Leave] -> all_locations

= crime_scene
Along one side of this long room is a display case housing nearly a dozen mummies standing shoulder to shoulder. There is a small gap towards the center of the mummies.
+[Enter the Employees-Only door] The Employees-Only door opens into a narrow hallway. A door on the left is marked 'Storage'. A door at the far end is marked 'Exit'. Hanging on the wall is a framed picture of a man holding a mop. The bottom of the frame is labeled: Employee of the Month. -> employees_only_area
+[Leave the crime scene] -> museum_of_mummies
+[Leave] -> museum_of_mummies

= employees_only_area
// As this is a transition area, the Employees-Only door opening text is attached to the diverts instead of being right here.
+{carriedItems has key}[Enter the 'Storage' door] You unlock the 'Storage' door with the key. -> storage_room
+{not(carriedItems has key)}[Enter the 'Storage' door] The 'Storage' door is locked. You are not able to enter.
+[Enter the 'Exit' door] This door leads to an alley behind the museum. You try to go back inside the museum, but find the 'Exit' door is locked from the outside. There's no way to open the door from out here, not even a keyhole. You have to go all the way back around to the entrance to get back inside the museum. -> museum_of_mummies
    // |Remembering that there's no way to open the 'Exit' door from the outside, you hold the door open with your foot. -> employees_only_area} // I can't include diverts within variable text? I could use a flag, but bleh!
+[Leave the Employees-Only area] -> museum_of_mummies
+[Leave] -> museum_of_mummies
- -> employees_only_area

= storage_room
+[Leave the storage room] -> employees_only_area
+[Leave] -> employees_only_area

= security_guard
# CHARACTER security_guard
+[Ask about the missing mummy] "Luckily it wasn't one of our more notable displays. Thankfully the owner took out insurance on all of the displays last month."
    ~ suspects += museumOfMummiesOwner
    ~ unlockedChoices += askAboutInsurance
+[Ask about the sign-in sheet] "Sure, here you go." He slides the clipboard across the desk to you. "We had a highschool class come through. Not much else." Looking over the sign-in sheet you get the name of the highschool, the teacher, and twenty of the students. You also get the name of a family of four, who signed in after the students.
    ~ suspects += (schoolTeacher, schoolStudents, family)
    ~ unlockedLocations += highSchool
+{suspects has schoolTeacher}[Ask about the teacher] "She seemed a little overwhelmed, like this was her first rodeo. I couldn't offer any help, though. I have to stay here at the front desk unless there's an emergency."
+{suspects has schoolTeacher}[Ask about the students] "A rowdy bunch. I let them know the legal consequences of messing with the exhibits. Based on what happened... I'm not sure it took."
+{suspects has family}[Ask about the family] "Oh, nearly forgot about them. Yeah, last to come through was a father with his three kids. Seemed like a nice guy, and his kids were well behaved."
    ~ suspects += familyFather
+{museum_of_mummies.employees_only_area}[Ask about the 'Exit' door] "Anyone can open it from the inside in case there's a fire, but you can't open it from the outside. I've locked myself out a few times that way and had to circle around to the entrance. There's no other way in."
+{museum_of_mummies.employees_only_area}[Ask about the 'Storage' door] "The storage room is in the employees only area, near the main exhibits. We keep it locked at all times, though. You'll need a key to get in."
    ~ unlockedChoices += askAboutKey
+{museum_of_mummies.employees_only_area}[Ask about the employee of the month] "That would be the janitor. The owner put up that 'Employee of the Month' picture to try and make him feel appreciated, but I don't think that's the problem. No one likes cleaning this place at night, and I don't blame them. None of our janitors have stayed on for more than a year."
    ~ suspects += (museumOfMummiesOwner, museumJanitor)
+{unlockedChoices has askAboutKey}[Ask about the key] "We keep the storage room and each of the display cases locked at all times. I also lock the entrance when I leave at closing. The only people with the key are myself, the owner, and the janitor."
    ~ carriedItems += key
    ~ suspects += (museumOfMummiesOwner, museumJanitor)
+{suspects has museumOfMummiesOwner}[Ask about the owner] "He's only here once a week and doesn't like to be bothered. I'll give you his home address, just don't tell him you got it from me."
    ~ unlockedLocations += museumOfMummiesOwnerHome
+{suspects has museumJanitor}[Ask about the janitor] "He comes into clean after closing. He's been out sick this week, though. Here's his address."
    ~ unlockedChoices += askAboutSickJanitor
    ~ unlockedLocations += janitorHome
+[Leave the security guard] -> museum_of_mummies
+[Leave] -> museum_of_mummies
- -> museum_of_mummies.security_guard


/*--------------------------------------------------------------------------------
    Owner's Home
--------------------------------------------------------------------------------*/
== museum_of_mummies_owner_home ==
# LOCATION mummy_museum_owner_home
+[Examine the garden] The tomatoes of this neglected garden have shriveled and died in the heat. -> museum_of_mummies_owner_home
+[Ring the doorbell] A portly, well dressed man answers the door, a scowl on his face. "What do you want?" He reeks of aftershave. -> museum_of_mummies_owner_home.owner
+[Leave the Mummy Museum owner's home] -> all_locations
+[Leave the owner's home] -> all_locations
+[Leave] -> all_locations

= owner
# CHARACTER mummy_museum_owner
+[Ask about the missing mummy] "The mummy wasn't special. We have six more just like it in the storage room. Here, I have a picture." The owner returns inside his home, then emerges a short while later, handing you a photo. "I'll expect that back before you leave."
    ~ unlockedChoices += examineExhibitPhoto
+{unlockedChoices has examineExhibitPhoto}[Examine the photo] {|The owner goes back inside and emerges a short while later, handing you a photo. "I'll expect that back before you leave."} The photo shows a display case housing nearly a dozen mummies standing shoulder to shoulder. Towards the center of the mummies, one is placed on its knees and a bit more forward, its face almost touching the glass.
+{unlockedChoices has askAboutInsurance}[Ask about the insurance] "How did you hear about that? Yeah, I took it out last month on all of our displayed exhibits. Don't give me any of that 'How convenient' nonsense. If we have to keep the museum closed another day, the thief could've at least taken a few more mummies to make it worth our while." As if suddenly realizing he's talking to a police officer, he hurriedly changes the subject. "You know who you should be investigating? That curator for the Regional Museum."
    ~ suspects += regionalMuseumCurator
+{suspects has regionalMuseumCurator}[Ask about the curator] "That's right, she's the curator for the Regional Museum. She keeps harassing me about 'donating' one of our mummies. I tell her, 'My museum's got one thing, and I'm not about to just hand it over.' She's always at the Regional Museum. That lady doesn't have a personal life."
    ~ unlockedLocations += regionalMuseum
+[Ask about the garden] "It was my wife's. Well, make that ex-wife." He scowls harder and {spits on his own shoe. He looks up to see if you noticed, then awkardly drags the front of his shoe across the doormat.|thinks better of spitting this time.}
    ~ suspects += exWife
+{suspects has exWife}[Ask about the ex-wife] "The divorce isn't final yet. I get the house. She's getting everything else."
+{unlockedChoices has askAboutKey}[Ask about the key] "The same key is used for the entrance after hours, each of the display cases, and the storage room." He pulls a set of keys from his pocket and holds one up. "I've given a copy to the security guard and another to the janitor. You can borrow the security guard's key if you need it."
    ~ suspects += (securityGuard, museumJanitor)
+{suspects has museumJanitor}[Ask about the janitor] "Hired him about three months back. We can't seem to hang onto the same janitor for very long. A superstitious lot, they can't handle being in the museum alone at night. We have to hire someone new every year. They always ask if they can come and clean in the morning, but that would cut into our hours, and I'm not having that!"
+{museum_of_mummies.employees_only_area}[Ask about the employee of the month] The owner proudly straightens up. "Ah, noticed that, did you? Well, even though the janitor has only been with us three months, I feel he deserved a little recognition. That's the kind of owner I am. I want everyone to feel appreciated, so they don't leave and give me more work to do finding their replacement."
    ~ suspects += museumJanitor
+[Leave the owner's home] -> all_locations
+[Leave the owner] The owner gives you a half-hearted wave goodbye. "Let me know if you find anything." -> all_locations
+[Leave] -> all_locations
- -> museum_of_mummies_owner_home.owner


/*--------------------------------------------------------------------------------
    Regional Museum
--------------------------------------------------------------------------------*/
== regional_museum ==
# LOCATION regional_museum
This granary storehouse became a fortress under Spanish occupation, then a prison under French occupation. But today it stands as the Regional Museum. It is filled with murals and displays depicting its bloody history.
+[Ask about the curator] You get the attention of one of the staff. A minute later an authoritative woman in a pantsuit joins you at one of the displays. Her nametag denotes her as the curator. "How can I help you, officer?" -> regional_museum.curator
+[Leave the Regional Museum] -> all_locations
+[Leave] -> all_locations

= curator
# CHARACTER regional_museum_curator
+[Ask about the Museum of Mummies] "It certainly brings in the tourists. I visited just last year. It's a wonderful museum, despite its current owner."
+[Ask about the security guard] "I can't say I've met him. I mean, I make it a point to visit all the local museums every now and then, but I can't say I've had a conversation with him."
+[Ask about the missing mummy] "I don't know what you're talking about. If that owner has lost something, he has no one but himself to blame!"
+[Ask about the owner] "That man can't be reasoned with. He's a stubborn fool, and turns down any request that doesn't directly benefit him."
+[Ask about the owner's accusation] "Oh, I see. Because I asked him to loan some of his unused exhibits for a temporary display at my museum, he's pointing the finger at me? The nerve of that man!" The curator strains her hands in front of her, as if choking someone. She quickly regains her composure and returns her attention to you. "Museums in Mexico frequently share their exhibits, sending displays on tours around the country. It's quite common, unless you're a prick."
+[Leave the Regional Museum] -> all_locations
+[Leave the curator] The curator sees you out. "Farewell. I wish you luck in your investigation." -> all_locations
+[Leave] -> all_locations
- -> regional_museum.curator


/*--------------------------------------------------------------------------------
    Family's home
--------------------------------------------------------------------------------*/
== family_home ==
# LOCATION family_home
You enter the apartment building and find the door listed in the address. You hear the sounds of children loudly playing inside.
+[Knock on the door] You hear a muffled "Coming!" A short while later, the door opens a crack. A small giggling child attempts to wedge his head through the door near the bottom, but he's pulled back. A man with a wild beard opens the door the rest of the way and steps out into the hallway. "Sorry, they're a bit wild after dinner. Is there something I can help you with?" -> family_home.father
+[Leave the apartment] -> all_locations
+[Leave] -> all_locations

= father
# CHARACTER family_father
+[Ask about the Museum of Mummies] "I love that place. Super creepy. This was the first time I brought my kids, though."
+[Ask about the missing mummy] "Missing?" His easy demeanor drops and he looks alarmed. "Listen, I don't know anything about that." He scratches his beard in thought. "Actually, now that I think about it, I noticed they got rid of that kneeling mummy in the big display case. They change the displays sometimes, so I didn't think anything of it. I was a little disappointed because it's the only mummy that's eye level with you if you're short like my kids." He chuckles evily, then hurriedly adds, "Or, you know, it's eye level if you bend over a bit."
+[Ask about the security guard] "Yeah, the guy at the front desk? Nice guy. My kids liked him."
+[Ask about the owner] "Of the museum? I don't know who that is."
+{unlockedChoices has askAboutAssault}[Ask about the assault] {The father makes sure the door behind him is closed and speaks a little more quietly. "Look, that was from a long time ago. I did my time and I'd rather put it all behind me. I don't want my past mistakes haunting my kids."|"Fine, if you're not going to drop it... My oldest son isn't mine. Not technically, anyways. His real father is a real scumbag, and when I heard what he was doing with his partial custody... I lost it. I got put away for a while after that."}
+[Leave the apartment] -> all_locations
+[Leave] -> all_locations
- -> family_home.father


/*--------------------------------------------------------------------------------
    Janitor's home
--------------------------------------------------------------------------------*/
== janitor_home ==
# LOCATION janitor_home
You enter the apartment building and knock on the door listed in the address. There is no answer and no sounds from within.
+[Leave the janitor's home] -> all_locations
+[Leave] -> all_locations


/*--------------------------------------------------------------------------------
    High School
--------------------------------------------------------------------------------*/
== high_school ==
# LOCATION high_school
{||You see a janitor mopping the floor. He looks very familiar. ~ unlockedChoices += speakWithJanitor}
+{not high_school.teacher}[Ask about the teacher] The front office directs you to a classroom just down the hall. The teacher is inside wiping down the chalkboard. Her skewed glasses and frizzy hair cause her to appear disheveled. She jumps a bit as you enter. "Uh oh, the police? But I didn't lose a single one this time!" -> high_school.teacher
+{high_school.teacher}[Speak with the teacher] -> high_school.teacher
+{unlockedChoices has speakWithJanitor}[Speak with the janitor] The janitor continues mopping as you approach. -> high_school.janitor
+{suspects has busDriver}[Speak with the bus driver] You go out to the parking lot where you remember seeing an idling schoolbus. Through the open door you see a large woman with short blond hair sitting behind the wheel reading a magazine. -> high_school.bus_driver
+{suspects has soccerPlayers}[Speak with the soccer players] You go out to the yard where a dozen students in jerseys run drills. After speaking with the coach, you pull the four players from the field trip aside. -> high_school.soccer_players
+[Leave the high school] -> all_locations
+[Leave] -> all_locations

= teacher
# CHARACTER school_teacher
+[Ask about negligence] She gives an exasperated sigh at having to recount this story again. "I used to teach third grade, but, let's just say there was an 'incident' on one of our field trips. Afterwards, the school board offered me this position instead."
    ~ unlockedChoices += askAboutIncident
+{unlockedChoices has askAboutIncident}[Ask about the 'incident'] "It could've happened to anybody! You take your eyes off those kids for a second, and, well... Back when I taught third grade, we had a field trip to a farm. I must've miscounted the kids as we were getting on the bus to leave, or maybe we had an extra? In any case, they found one of the boys from the class wandering the road a few miles down from the farm. He was fine. The parents, not so much. The school board agreed it was an honest mistake, could've happened to anybody." She repeats this last point, nodding to herself assuredly.
+[Ask about the Museum of Mummies] "The place creeps me out, but the students really seemed to enjoy it. I can always tell when they're enjoying something because they yell at each other instead of at me. The field trip mostly went off without a hitch. Normally at museums I'm always having to shout, 'Don't touch that!' But because everything there is behind locked glass, I just followed along with a cleaning rag to clean up their finger smudges."
+[Ask about the missing mummy] {"Missing? Oh." Her eyes go wide as she imagines the worst possible scenario. "Ohhhhhhh..." She walks around the classroom in a daze, first touching the chalkboard, then her desk, as if to say goodbye.|} "You must believe me, none of the students walked out of there with a mummy! I would've noticed! I think. No, I definitely would've noticed a mummy, even if they gave it a backpack and a hat!" After giving it a bit more thought, she adds, "You may want to ask the bus driver as well. You know, just to confirm."
    ~ suspects += busDriver
+[Ask about the security guard] "Ah, a man with authority." The teacher starts to swoon, but then nearly stumbles. "I was having a mess of a time getting us all checked in, but he really helped me out. I've never seen the students so orderly! Of course, it didn't last long. Once we were past the checkpoint, they scattered every which way. Ah, but for just a moment..." She gets a distant look in her eye, remembering a better time.
+[Ask about the owner] "I don't know him. The only man I remember being there was that strapping security guard."
+[Ask about the students] "Let me save you some time. If the police are involved, you probably want to talk to the biggest troublemakers in my class. All four of them should be at soccer practice out in the yard."
    ~ suspects += soccerPlayers
+{unlockedChoices has speakWithJanitor}[Ask about the janitor] "He mostly keeps to himself and his job. I think he keeps his guard up because sometimes the students mess with him. Last week I saw him speaking with some of the students from my class. I thought they were harrassing him at first, but then they parted like it was just normal conversation."
+[Leave the teacher] -> high_school
+[Leave] -> high_school
- -> high_school.teacher

= soccer_players
# CHARACTER soccer_players
+{suspects has schoolTeacher}[Ask about the teacher] "She's fine. Teaches us stuff." Another chimes in, "Tries, anyways."
+{suspects has schoolStudents}[Ask about the students] "You want to know about the rest of our class? Most of them are losers." Another quietly adds, "Except Francesca."
    The original speaker leans in conspiratorially and loudly whispers, "He has a thing for Francesca."
+{suspects has busDriver}[Ask about the bus driver] "She's loud. She's always yelling at us to be quiet, but she's the one that should shut up."
+{unlockedChoices has speakWithJanitor}[Ask about the janitor] "Ummm... Who? The janitor? We don't really know him." All four of the soccer players nod their heads in agreement.
+{unlockedChoices has askAboutVan}[Ask about the van] "So what if we left in a van? We had to get back to school in time for practice. It doesn't mean that we did anything!"
+[Ask about the security guard] "He was kind of lame. He didn't even have a gun! We totally could've rushed him." Another quickly adds, "Not that we'd want to, of course."
+[Ask about the Museum of Mummies] "Normally our field trips suck, but this one was actually cool!" Another adds nonchalantly, "It's alright. I'd already been there a few times before."
+[Ask about the missing mummy] The four soccer players all look at each other. "What does that have to do with us? We couldn't touch any of the mummies, even if we wanted to! They were all behind glass!"
+[Leave the soccer players] -> high_school
+[Leave] -> high_school
- -> high_school.soccer_players

= bus_driver
# CHARACTER bus_driver
+{suspects has schoolTeacher}[Ask about the teacher] "She always seems a little overwhelmed. I tell her, you need to raise your voice sometimes or these kids will run all over you. But I suppose it's her job to teach math and science, not discipline."
+{suspects has schoolStudents}[Ask about the students] "A rowdy bunch. Either we're going somewhere boring and they're loud, or we're going somewhere they're excited about and they're STILL loud."
+{suspects has soccerPlayers}[Ask about the soccer players] "Oh, I know exactly who you're talking about. They're the worst of the bunch. Thankfully, they had some sports thing they needed to get to after the field trip, so I didn't have to put up with them on the bus. They left the museum early in their van they had parked around the back."
    ~ unlockedChoices += askAboutVan
+{unlockedChoices has speakWithJanitor}[Ask about the janitor] "Can't say I know the guy. I've seen him a few times taking out the trash and washing the windows. Not my type. He's a bit scrawny for me." She gives you a wink.
+[Ask about the security guard] "There was a security guard? Was he handsome? I waited out in the parking lot, so I never came inside." She grumbles her disappointment. "I bet he was handsome."
+[Ask about the Museum of Mummies] "We arrived around noon. I took lunch and waited in the parking lot. We were there a little over an hour. I never went inside, though. I've seen enough dead bodies."
+[Ask about the missing mummy] "A missing what? Uh oh. I guess that's the last field trip we'll be making there then."
+[Leave the bus driver] -> high_school
+[Leave] -> high_school
- -> high_school.bus_driver

= janitor
# CHARACTER museumJanitor
+{suspects has schoolTeacher}[Ask about the teacher] "I don't talk too much to the faculty. I just keep my head down and do my job."
+{suspects has schoolStudents}[Ask about the students] "They can be messy and inconsiderate, but what good is a janitor without messy, inconsiderate people? I'd be out of a job if they were angels."
+{suspects has soccerPlayers}[Ask about the soccer players] "After their games and practices, I pickup the yard. So yeah, I've seen them around. But I don't know them, and I don't care to."
+{suspects has busDriver}[Ask about the bus driver] "I see her now and then in the parking lot. I'm not sure she ever leaves the bus while she's here. Just picks up students and drops them off."
+[Ask about the Museum of Mummies] The janitor sighs. "Yeah, I work there too. I could use the extra money, but I'm not sure it's worth it. Sure, sometimes the students give me a hard time, but at least they're alive. They're not just kneeling there, silently watching me."
+[Ask about the missing mummy] "So what if a mummy goes missing? The place is stocked full. We have more mummies than glass. In any case, I haven't been there for a week. I've been sick."
    ~ unlockedChoices += askAboutSickJanitor
+{unlockedChoices has askAboutSickJanitor}[Ask about his sickness] "It's not so much a throat thing, as it is... a mental health day. I've been stressed out, and I could just use a break from one of my two jobs."
+{suspects has museumOfMummiesOwner}[Ask about the owner] The janitor leans in closer towards you. "This stays between me and you? He's an asshole. I almost never ask for anything, but when I do he can't wait to say no. But... he's an asshole that pays."
+{suspects has securityGuard}[Ask about the security guard] "He's always been nice to me, ever since I first started working there."
+{unlockedChoices has askAboutKey}[Ask about the key] The janitor subconciously reaches for the key ring at his side. "Right, the key to the museum. I don't have it with me... It's at home." He stumbles over his words.
+[Leave the janitor] -> high_school
+[Leave] -> high_school
- -> high_school.janitor


/*--------------------------------------------------------------------------------
    Police Station
--------------------------------------------------------------------------------*/
== police_station ==
# LOCATION police_station
+[Search police records] Using police records, you can lookup anyone's address and criminal history. You sit down at the computer and log in. -> police_records
+[Get a warrant for suspect] -> warrant_filing
+[Leave the police station] -> all_locations
+[Leave] -> all_locations

= police_records
+{suspects has securityGuard}[Lookup the security guard] There's a home address listed, but the security guard should still be at the Museum of Mummies.
+{suspects has museumOfMummiesOwner}[Lookup the owner] The owner of the Museum of Mummies was charged with tax evasion but was never convicted. The listed address puts him on the cliffs overlooking Guanajuato. // Restraining order by ex-wife?
    ~ unlockedLocations += museumOfMummiesOwnerHome
+{suspects has exWife}[Lookup the ex-wife] The address listed is the same as the Mummy Museum owner's address.
    ~ unlockedLocations += museumOfMummiesOwnerHome
+{suspects has museumJanitor}[Lookup the janitor] Several charges of petty robbery from ten years ago are listed on the janitor's criminal record. He was too young to even drive at the time, so the sentencing was light. His home address is in an apartment building.
    ~ unlockedLocations += janitorHome
+{suspects has schoolTeacher}[Lookup the teacher] The teacher's criminal history is largely blank, though there are notes of some dropped charges of negligence with children.
+{suspects has soccerPlayers}[Lookup the soccer players] Each of them has a few misdemeanors under their belt: Criminal mischief, vandalism, petty theft. Enough to decorate their criminal record and rack up some hefty fines.
+{suspects has busDriver}[Lookup the bus driver]
+{suspects has family}[Lookup the family] You get a few addresses matching the family's last name. After a few phone calls, you narrow it down.
    ~ unlockedLocations += familyHome
+{suspects has familyFather}[Lookup the father] You get the address of an apartment. You also find the father has some criminal history from eight years ago: Aggravated assault.
    ~ unlockedLocations += familyHome
+{suspects has regionalMuseumCurator}[Lookup the Regional Museum curator]
+[Log out of police records] -> police_station
+[Log out] -> police_station
- -> police_records

= warrant_filing
*{suspects has securityGuard && carriedItems hasnt wrongWarrant}[Get a warrant for the security guard]
    ~ carriedItems += wrongWarrant
*{suspects has securityGuard && carriedItems has wrongWarrant}[Get a warrant for the security guard] -> END
*{suspects has museumOfMummiesOwner && carriedItems hasnt wrongWarrant}[Get a warrant for the owner]
    ~ carriedItems += wrongWarrant
*{suspects has museumOfMummiesOwner && carriedItems has wrongWarrant}[Get a warrant for the owner] -> END
*{suspects has museumJanitor && carriedItems hasnt wrongWarrant}[Get a warrant for the janitor]
    ~ carriedItems += wrongWarrant
*{suspects has museumJanitor && carriedItems has wrongWarrant}[Get a warrant for the janitor] -> END
*{suspects has schoolTeacher && carriedItems hasnt wrongWarrant}[Get a warrant for the teacher]
    ~ carriedItems += wrongWarrant
*{suspects has schoolTeacher && carriedItems has wrongWarrant}[Get a warrant for the teacher] -> END
*{suspects has busDriver && carriedItems hasnt wrongWarrant}[Get a warrant for the bus driver]
    ~ carriedItems += wrongWarrant
*{suspects has busDriver && carriedItems has wrongWarrant}[Get a warrant for the bus driver] -> END
*{suspects has familyFather && carriedItems hasnt wrongWarrant}[Get a warrant for the father]
    ~ carriedItems += wrongWarrant
*{suspects has familyFather && carriedItems has wrongWarrant}[Get a warrant for the father] -> END
*{suspects has regionalMuseumCurator && carriedItems hasnt wrongWarrant}[Get a warrant for the Regional Museum curator]
    ~ carriedItems += wrongWarrant
*{suspects has regionalMuseumCurator && carriedItems has wrongWarrant}[Get a warrant for the Regional Museum curator] -> END
*{suspects has soccerPlayers && carriedItems hasnt wrongWarrant}[Get a warrant for the soccer players] -> END
*{suspects has soccerPlayers && carriedItems has wrongWarrant}[Get a warrant for the soccer players] -> END
+[Don't get a warrant yet] -> police_station
+[Leave] -> police_station
- -> police_station

= first_false_accusation  // Use these for conditionals and text instead of wrongWarrant and correctWarrant of carriedItems list
-> police_station

= second_false_accusation
-> END
