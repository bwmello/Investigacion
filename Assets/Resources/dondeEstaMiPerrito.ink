// {LIST has VAR} only if LIST = (VAR) or until LIST += VAR
LIST unlockedLocations = employeesOnlyArea, storageRoom, mummyMuseumCuratorHome, janitorHome, familyHome, highSchool, regionalMuseum
LIST suspects = (securityGuard), mummyMuseumCurator, janitor, father, busDriver, students, regionalMuseumCurator


The Case of the Missing Mummy
+[New Game] You reach the Museum of Mummies in the afternoon. The security guard lets you in. -> mummy_museum


== all_locations ==
# LOCATION all_locations
+[Go to the Museum of Mummies] -> mummy_museum
+{unlockedLocations has mummyMuseumCuratorHome}[Go to the Mummy Museum curator's home] -> mummy_museum_curator_home
+{unlockedLocations has janitorHome}[Go to the janitor's home] -> janitor_home
+{unlockedLocations has familyHome}[Go to the family's home] -> family_home
+{unlockedLocations has highSchool}[Go to the high school] -> high_school
+{unlockedLocations has regionalMuseum}[Go to the Regional Museum of Guanajuato] -> regional_museum
+[Go to the police station] -> police_station


== mummy_museum ==
# LOCATION mummy_museum
The museum is dark except for the lit exhibits. The stone floor and ceiling is like that of a tomb.
+[Investigate the crime scene] -> mummy_museum.crime_scene
+{unlockedLocations has employeesOnlyArea}[Enter the "Employees Only" area] The "Employees Only" door opens into a narrow hallway. A door on the left is marked "Storage". A door at the far end is marked "Exit". -> employees_only_area
+[Speak with the security guard] -> mummy_museum.security_guard
+[Leave the Museum of Mummies] -> all_locations

= crime_scene
+[Open the "Employees Only" door] The "Employees Only" door opens into a narrow hallway. A door on the left is marked "Storage". A door at the far end is marked "Exit".
    ~ unlockedLocations += employeesOnlyArea
    -> employees_only_area
+[Leave the crime scene] -> mummy_museum

= employees_only_area
// As this is a transition area, the "Employees Only" door opening text is attached to the diverts instead of being right here.
+{unlockedLocations has storageRoom}[Open the "Storage" door] You unlock the "Storage" door with the key. -> storage_room
+{not(unlockedLocations has storageRoom)}[Open the "Storage" door] The "Storage" door is locked. You're not able to enter.
+[Open the "Exit" door] This door leads to the alley behind the museum. It's the only exit besides the front entrance.
+[Leave the "Employees Only" area] -> mummy_museum
- -> employees_only_area

= storage_room
+[Leave the storage room] -> employees_only_area

= security_guard
# CHARACTER security_guard
+[Ask about the missing mummy] The security guard says, "The mummy wasn't special. We have six more just like it in the storage room." // TODO mentions storage room here, but can't ask about storage room until employees_only_area?
+[Ask about the storage room] The security guard says, "The storage room is in the employees only area, near the main exhibits. Here, take my key."
    ~ unlockedLocations += storageRoom
+{unlockedLocations has storageRoom}[Ask about the key] The security guard says, "We keep the exhibits and the storage room locked at all times. The only people with the key are myself, the museum curator, and the janitor."
+[Leave the security guard] -> mummy_museum
- -> mummy_museum.security_guard


== mummy_museum_curator_home ==
# CHARACTER mummy_museum_curator
+[Leave the Mummy Museum curator's home] -> all_locations


== janitor_home ==
+[Leave the janitor's home] -> all_locations


== family_home ==
+[Leave the family's home] -> all_locations


== high_school ==
+[Leave the high school] -> all_locations


== regional_museum ==
+[Leave the Regional Museum] -> all_locations


== police_station ==
+[Search police records] -> police_records
+[Get a warrant for suspect] -> warrant_filing
+[Leave the police station] -> all_locations

= police_records
Using police records, you can lookup anyone's criminal history. You sit down at the computer and log in.
+{suspects has securityGuard}[Lookup the security guard]
+{suspects has mummyMuseumCurator}[Lookup the Mummy Museum curator]
+{suspects has janitor}[Lookup the janitor]
+{suspects has busDriver}[Lookup the bus driver]
+{suspects has students}[Lookup the students]
+{suspects has father}[Lookup the father]
+{suspects has regionalMuseumCurator}[Lookup the Regional Museum curator]
+[Log out of police records] -> police_station
- -> police_records

= warrant_filing
*{suspects has securityGuard}[Get a warrant for the security guard]
*{suspects has mummyMuseumCurator}[Get a warrant for the Mummy Museum curator]
*{suspects has janitor}[Get a warrant for the janitor]
*{suspects has busDriver}[Get a warrant for the bus driver]
*{suspects has students}[Get a warrant for the students]
*{suspects has father}[Get a warrant for the father]
*{suspects has regionalMuseumCurator}[Get a warrant for the Regional Museum curator]
+[Don't get a warrant yet] -> police_station
- -> END