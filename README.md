# EpicMusicPlayer_MP3
Script to create a playlist for [EpicMusicPlayer](https://github.com/Kiatra/EpicMusicPlayer)

Project on [CurseForge](https://www.curseforge.com/wow/addons/epicmusicplayer_mp3) 

### Adding music to the player
1. Create a folder named "MyMusic" in your World of Warcraft folder e.g: C:/Program Files/World of Warcraft/_retail_ for retail and under ../_classic_ for classic.
2. Copy the songs you want into that folder (Reminder: They must be mp3 format to be used).
3. In the EpicMusicPlayer_MP3 folder double-click the "PlaylistCreator.vbs" file.
4. Start the game and enjoy your music. 

### Developers

#### Creating a playlist of extracted game music for the main addon

1. Extract the music with a exporter like [wow.tools.local](https://github.com/Marlamin/wow.tools.local/) or [wow.export](https://github.com/Kruithne/wow.export) 
2. Create a folder 'gamemusic' in the folder of this script and put the extracted sound folder there 
(your folder structure should look like ./gamemusic/sound/music/...)
3. Add a [listfile.csv](https://github.com/wowdev/wow-listfile) into the folder of this script.
4. Run PlaylistCreator.vbs (The created playlist 'GameMusic.lua' will be in the gamemusic folder.)
5. Open the file GameMusic.lua and remove the first playlist in the file.
6. Rename the playlist e.g 'Shadowlands'
7. Copy the list into the EpicMusicPlayer/gamemusic/Shadowlands.lua and add the file to the EpicMusicPlayer.toc  
