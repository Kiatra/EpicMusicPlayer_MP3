'*************************************** EpicMusicPlayer Playlist Creator ***************************************
'*                  					
'*                      		by Jessica Sommer aka kiatra
'*				   (https://github.com/Kiatra/EpicMusicPlayer_MP3)
'*
'* if you want to modify or include this with your addon, please ask first.
'*
'* Set folder with the music eg: "C:\Program Files\World of Warcraft\MyMusic"
'* The folder MUST be within the World of Warcraft folder.
musicfolder = "..\..\..\MyMusic"
'* This is where the addon (not this script) will look for the music. It's relative to the WoW folder.
realtiveMusicFolder = "MyMusic\\"

'************************************************ For Developers ************************************************
'*
'*				Adding new ingame music to the addon after game patches
'*
'* To create a playlist from extracted game music: 
'* 1. extract the sound files from the path sound/music/thewarwithin/.. with a tool like wow.export
'* 2. create a folder called gamemusic and move the sound folder in there 
'* 3. download a listfile and put it in the same folder like this script. 
'*	(We need the IDs in there to play the songs.)
'* 4. Run this script.
'****************************************************************************************************************
gamemusic = ".\gamemusic"
listfile = ".\listfile.csv"
'****************************************************************************************************************
scripVersion = "4.1"

'force the script to run in from a console
CheckStartMode

'count ids not found in the listfile for a extracted song
missingIDs = 0

'check Windows Version
dim indexTitle, indexArtist, indexAlbum, indexTime

if getWindowsVersion() > "5.1" or getWindowsVersion() = "10." then
	'Windows Vista, 7, 8, 8.1, and 10
	indexTitle = 21
	indexArtist = 20
	indexAlbum = 14
	indexTime = 27
elseif getWindowsVersion() = "5.1" then
	'Windows XP
	indexTitle = 10
	indexArtist = 16
	indexAlbum = 17
	indexTime = 21
else
	WScript.Echo "This playlist generator does not work with your windows version. Version: " & getWindowsVersion()
	Wscript.Quit
end if

dim totalNumberOfSongs, listCount
totalNumberOfSongs = 0
set objShell = CreateObject("Shell.Application")
set objFSO = createobject("Scripting.FileSystemObject")


if isAddingGameMusicMode() then
	WScript.Echo "GAME MUSIC MODE: Found folder " & gamemusic &", adding game music mode is ON!"
	Dim objDictionary
	Set objDictionary = CreateObject("Scripting.Dictionary")
	addingGameMusic = 1
	musicfolder = gamemusic
	readListfile()
elseif not objFSO.FolderExists(musicfolder) then
	if musicfolder = "..\..\..\..\mymusic" then
		WScript.Echo "Music Folder not found: " & objFSO.GetFolder("..\..\..\..\").Path & "\MyMusic"
	else
		WScript.Echo "Music Folder not found: " & musicfolder
	end if
	Wscript.Quit
end if

musicfolder = objFSO.GetFolder(musicfolder).Path

const adTypeText = 2
const adSaveCreateOverWrite = 2
dim BinaryStream
set BinaryStream = CreateObject("ADODB.Stream")
BinaryStream.Type = adTypeText
BinaryStream.CharSet = "utf-8"
BinaryStream.Open

'WScript.Echo "Generating the playlist, this may take some time..."
BinaryStream.WriteText "--Created by PlaylistCreator.vbs version " & scripVersion & " (https://github.com/Kiatra/EpicMusicPlayer_MP3)" & Vbcrlf
BinaryStream.WriteText "local EpicMusicPlayer = LibStub(""AceAddon-3.0""):GetAddon(""EpicMusicPlayer"")" & Vbcrlf
BinaryStream.WriteText "if not EpicMusicPlayer then return end" & Vbcrlf

set objFolder = objFSO.GetFolder(musicfolder)
set folder = objShell.NameSpace(musicfolder)
playlistIndex = 0
'create a playlist for all the files in the music folder
writePlaylistHeader(objFSO.GetFolder(musicfolder).Name)
WScript.Echo "Generating playlist: " & objFSO.GetFolder(musicfolder).Name
listCount = 0
for each file in folder.items
	x = getSongInfo(file,folder)
next
BinaryStream.WriteText "}" & Vbcrlf
BinaryStream.WriteText "EpicMusicPlayer:AddPlayList(""playlist"", playlist" & playlistIndex & ", false)" & Vbcrlf
playlistIndex = playlistIndex + 1

'create a playlist for each subfolder of the music folder
for each objFolder in objFolder.SubFolders
	if objFolder.Files.Count > 0 or objFolder.Subfolders.count > 0 then
		CreatePlaylist objFolder.Path
		playlistIndex = playlistIndex + 1
	end if
next

if isAddingGameMusicMode() then
	BinaryStream.SaveToFile "GameMusic.lua", adSaveCreateOverWrite
else
	BinaryStream.SaveToFile "CustomMusic.lua", adSaveCreateOverWrite
end if

WScript.Echo "Done! " & Vbcrlf & totalNumberOfSongs & " music files written to Playlist."
if writeGameMusicInfo = 1 then
	WScript.Echo Vbcrlf & "Files in the folder named ""sound"" were added as game music and will not play if they are not present in the game data."
end if

if missingIDs > 0 then
	WScript.Echo Vbcrlf & missingIDs & " files had a missing id in the listfile. Update your listfile.csv!"
end if

'enum all files from given directory
sub GetFiles(byval strDirectory)
	set objFolder = objFSO.GetFolder(strDirectory)
	set folder = objShell.NameSpace(strDirectory)
	for each file in folder.items
		'wscript.echo file
		x = getSongInfo(file,folder)
	next
	for each objFolder in objFolder.SubFolders
		GetFiles objFolder.Path
	next
end sub

sub CreatePlaylist(byval strDirectory)
	'strPlayListName = strDirectory
	'write playlist head
	writePlaylistHeader(objFSO.GetFolder(strDirectory).Name)
	'write music files
	WScript.Echo "Generating playlist for files in: " & objFSO.GetFolder(strDirectory).Name
	listCount = 0
	GetFiles strDirectory
	'write end of playlist
	BinaryStream.WriteText "}" & Vbcrlf
	
	if addingGameMusic then
		BinaryStream.WriteText "if LE_EXPANSION_LEVEL_CURRENT > 7 then" & Vbcrlf
	end if
	
	BinaryStream.WriteText "EpicMusicPlayer:AddPlayList(nil, playlist" & playlistIndex & ", false)" & Vbcrlf
	
	if addingGameMusic then
		BinaryStream.WriteText "end"
	end if
end sub

function getSongInfo(file,folder)
	dim album, title, time, artist, ext, path
	ext = Ucase(Right(file.Path, 3))
	if ext = "MP3" then
		title = Replace(folder.GetDetailsOf(file, indexTitle) , """", "")
		artist = Replace(folder.GetDetailsOf(file, indexArtist) , """", "")
		album = Replace(folder.GetDetailsOf(file, indexAlbum) , """", "")
		time = getTime(file,folder)
		'remove musicdir from path
		path = Right(file.Path,len(file.Path)-len(musicfolder)-1)
		'wscript.echo title & " - " & file
		if title = "" and len(file) > 4 then title = Left(file,len(file)-4) end if
		if time > 0 then
			listCount = listCount + 1
			totalNumberOfSongs = totalNumberOfSongs + 1
			
			if addingGameMusic then
				dim id
				id = getId(path)
				if id = "00000" then
					WScript.Echo totalNumberOfSongs & " ID not found in listfile for path: " & path
				end if
			else
				x = writeSong(outfile, path, album, time, title, artist)
				WScript.Echo totalNumberOfSongs & " Writing: " & path & " ID: " & id & " runtime: " & time & "s"  
			end if
		end if
	end if
end function

function getTime(file,objFolder)
	dim time
	'get time from file hh:mm:ss
	time=objFolder.GetDetailsOf(file, indexTime)
	time=Split(time,":")

	if (UBound(time) - LBound(time) + 1)  > 2 then
		' convert hours, minutes and seconds strings to numbers and sumerize them
		getTime = (CInt(time(0))*60+CInt(time(1)))*60+CInt(time(2))
	else
		getTime = 0
	end if
end function

sub writePlaylistHeader(listName)
	BinaryStream.WriteText "local playlist" & playlistIndex &  " = {" & Vbcrlf
	BinaryStream.WriteText "	[""listName""] = """ & listName &"""," & Vbcrlf
	BinaryStream.WriteText "	[""playlistVersion""] = ""4.0""," & Vbcrlf
	
	if addingGameMusic then
		BinaryStream.WriteText "	[""locked""] =  ""true""," & Vbcrlf
	else
		BinaryStream.WriteText "	[""playlistType""] = ""generated""," & Vbcrlf
	end if
	
	BinaryStream.WriteText "	{" & Vbcrlf

end sub

function writeSong(outfile,path,album,time,title,artist)
	if listCount > 1 then
		BinaryStream.WriteText "	{" & Vbcrlf
	end if
	BinaryStream.WriteText "		[""Album""] = """ & album & ""","& Vbcrlf
	BinaryStream.WriteText "		[""Song""] = """ & title & ""","& Vbcrlf
	BinaryStream.WriteText "		[""Name""] = """ & Replace(path, "\", "\\") & ""","& Vbcrlf
	BinaryStream.WriteText "		[""Length""] = " & time &","& Vbcrlf
	BinaryStream.WriteText "		[""Artist""] = """ & artist & ""","& Vbcrlf
	if addingGameMusic = 1 then
			BinaryStream.WriteText "		[""WoW""] =  """ & "true" & ""","& Vbcrlf
			BinaryStream.WriteText "		[""Id""] =  """ & getId(path) & ""","& Vbcrlf
	end if
	BinaryStream.WriteText "	},"& Vbcrlf
end function

function isAddingGameMusicMode()
	isAddingGameMusicMode = objFSO.FolderExists(gamemusic)
end function

function getWindowsVersion()
	'Option Explicit
	dim objWMI, objItem, colItems
	dim strComputer, VerOS, VerBig, Ver9x, Version9x, OS, OSystem

	on error resume next
	strComputer = "."
	set objWMI = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
	set colItems = objWMI.ExecQuery("Select * from Win32_OperatingSystem",,48)

	for each objItem in colItems
		VerBig = Left(objItem.Version,3)
	next

	getWindowsVersion = VerBig
	set objWMI = nothing
	set colItems = nothing
end function

function getId(ByVal path)
	id = "00000"
	path = Replace(path, "\", "/")
	If objDictionary.Exists(path) Then
		id = objDictionary(path)
	else
		missingIDs = missingIDs + 1
	end if
	getId = id
end function

function readListfile()
	if not objFSO.FileExists(listfile) then
		WScript.Echo "Listfile missing in " & listfile
		Wscript.Quit
	end if
	dim fs,objTextFile
	set fs=CreateObject("Scripting.FileSystemObject")
	set objTextFile = fs.OpenTextFile(listfile)
	dim arrStr

	index = 0
	WScript.Echo "Reading listfile..."
	Do while NOT objTextFile.AtEndOfStream
	  arrStr = split(objTextFile.ReadLine,";")

	  index = index + 1
	  if left(arrStr(1),11) = "sound/music" then
	    objDictionary.Add arrStr(1), arrStr(0)
	  end if
	Loop
	wscript.echo "sound/music path has " &  objDictionary.Count & " items"
	objTextFile.Close
	set objTextFile = Nothing
	set fs = Nothing
end function 'readListfile

sub CheckStartMode
	' Returns the running executable as upper case from the last \ symbol
	strStartExe = UCase( mid( wscript.fullname, instrRev(wscript.fullname, "\") + 1 ) )

	if not strStartExe = "CSCRIPT.EXE" then
	' This wasn't launched with cscript.exe, so relaunch using cscript.exe explicitly!
	' wscript.scriptfullname is the full path to the actual script

	set oSh = CreateObject("wscript.shell")
		if WScript.Arguments.Count > 0 then
			oSh.Run "cmd /k cscript.exe """ & wscript.scriptfullname & """" & " " & WScript.Arguments(0)
		else
			oSh.Run "cmd /k cscript.exe """ & wscript.scriptfullname & """"
		end if
		wscript.quit
	end if
end sub

set BinaryStream = nothing
set objFolder = nothing
set folder = nothing
set objShell = nothing
set objFSO = nothing
set objDictionary = nothing
