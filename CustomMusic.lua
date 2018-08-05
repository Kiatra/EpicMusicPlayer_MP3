--Created by PlaylistCreator version 4.0
local EpicMusicPlayer = LibStub("AceAddon-3.0"):GetAddon("EpicMusicPlayer")
if not EpicMusicPlayer then return end
local playlist0 = {
	["listName"] = "MyMusic",
	["playlistVersion"] = "4.0",
	["playlistType"] = "generated",
	{
		["Album"] = "Action & Drama #1",
		["Song"] = "Blasphemy",
		["Name"] = "03 - Blasphemy.mp3",
		["Length"] = 83,
		["Artist"] = "Immediate Music",
	},
	{
		["Album"] = "Themes For Orchestra And Choir (Disc 2)",
		["Song"] = "Serenata",
		["Name"] = "05 Serenata.mp3",
		["Length"] = 172,
		["Artist"] = "Immediate Music",
	},
	{
		["Album"] = "Themes For Orchestra and Choir 2 - Abbey Road (Disc 1)",
		["Song"] = "With Great Power",
		["Name"] = "05 With Great Power.mp3",
		["Length"] = 110,
		["Artist"] = "Immediate Music",
	},
	{
		["Album"] = "Themes For Orchestra And Choir (Disc 1)",
		["Song"] = "Liberation!",
		["Name"] = "08 Liberation!.mp3",
		["Length"] = 106,
		["Artist"] = "Immediate Music",
	},
	{
		["Album"] = "Themes For Orchestra And Choir (Disc 1)",
		["Song"] = "Fahrenheit",
		["Name"] = "14 Fahrenheit.mp3",
		["Length"] = 126,
		["Artist"] = "Immediate Music",
	},
	{
		["Album"] = "Themes For Orchestra and Choir 2 - Abbey Road (Disc 1)",
		["Song"] = "Rising Empire",
		["Name"] = "15 Rising Empire.mp3",
		["Length"] = 109,
		["Artist"] = "Immediate Music",
	},
	{
		["Album"] = "Themes For Orchestra and Choir 2 - Abbey Road (Disc 2)",
		["Song"] = "Epicon",
		["Name"] = "16 Epicon.mp3",
		["Length"] = 109,
		["Artist"] = "Immediate Music",
	},
	{
		["Album"] = "Action & Drama #1",
		["Song"] = "Desperate Hour",
		["Name"] = "19 - Desperate Hour.mp3",
		["Length"] = 36,
		["Artist"] = "Immediate Music",
	},
	{
		["Album"] = "Themes For Orchestra And Choir (Disc 1)",
		["Song"] = "Blasphemy 2.0",
		["Name"] = "26 Blasphemy 2.0.mp3",
		["Length"] = 72,
		["Artist"] = "Immediate Music",
	},
}
EpicMusicPlayer:AddPlayList("playlist", playlist0, false)
