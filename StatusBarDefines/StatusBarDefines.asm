;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Defines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Statusbar tile RAM location
	if !sa1 == 0
		!Freeram_SuperStatusBar_TileData	#= $7FA000
	else
		!Freeram_SuperStatusBar_TileData	#= $404000
	endif
		;^Free ram for status bar (needs $140 (320 decimal) bytes). These are the tile data, of all 160 tiles in a 32x5 grid, in the format of
		; !Freeram_SuperStatusBar_TileData+0: TTTTTTTT of Tile 0 (X=00, Y=00)
		; !Freeram_SuperStatusBar_TileData+1: YXPCCCTT of Tile 0 (X=00, Y=00)
		; !Freeram_SuperStatusBar_TileData+2: TTTTTTTT of Tile 1 (X=01, Y=00)
		; !Freeram_SuperStatusBar_TileData+3: YXPCCCTT of Tile 1 (X=01, Y=00)
		; ...
		; !Freeram_SuperStatusBar_TileData+318: TTTTTTTT of Tile 159 (X=31, Y=05)
		; !Freeram_SuperStatusBar_TileData+319: YXPCCCTT of Tile 159 (X=31, Y=05)
		;
		; Note that "#=" is used as a failsafe to prevent potential error where asar treats the numbers as strings.
	
	
;Super status bar settings:
;Notes:
; - XY positions ranges X:00~31 and Y:00~04, represents a position, in units of 8x8 tiles, and must be integers. They increases going
;   rightwards and downwards.
; -- Any XY position of a counter placed outside that range, or is a counter that spans multiple tiles placed so its second or later
;    tiles goes out of range, would write data at invalid RAM address (causes glitches, or crashes, depending on the resulting RAM).
; - Any multi-tile counters that would go past the right edge (X=31) would wrap back to the left and down 1 line like text.
; - Number without any prefix are decimal, a "$" prefix is hex, and "%" prefix is binary.
; - These only covers the counters, not the static tiles (coin symbol for the regular coin counter, the "X" for coin counter, bonus
;   stars and lives).
; - Defines with !Setting_SuperStatusBar_<Counter>_Enable means: 0 = disable (will leave out default static tiles), 1 = enable.
;   Note that some counters do have its code with gameplay impact (beyond just informing the player) in the status bar code, which
;   is also subject to being disabled as well (disabling the timer, for example, would also remove the actual time limit rather
;   than just making the timer invisible).
; - Tile positions and enabling/disabling only works on the advanced version of the SSB patch.
; - Default tile numbers and properties are in "DATA_TILES", or using Smallhacker's status bar editor. Note that this added table
;   to the game is for new row of tiles. Original tiles not provided by this patch are from a reused vanilla table at $008C81~$008CFE:
;   https://smwc.me/m/smw/rom/008C81

;Register settings
	!Setting_SuperStatusBar_IRQYPos = $26
		;^IRQ layer 3 cutoff Y position, in pixels. $26 by default. Higher value = further down the screen layer 3
		; interrupt Y position. Normally you should leave this at $26. If you're not using the last row of 8x8 tiles,
		; change this to $24.
	if !sa1 == 0
		!Setting_SuperStatusBar_DMAChannel = 1
	else
		!Setting_SuperStatusBar_DMAChannel = 2
	endif
		;^Valid values 0~7. This is the DMA channel to use. You would normally set this to some other unused channel to
		; prevent glitches with other HDMA/DMA effects and mode 7 bosses. By default it should work with vanilla and SA-1.
;Display settings
	;Time (the digits, not the word "TIME")
		!Setting_SuperStatusBar_Time_Enable = 1		;>display time limit: 0 = false (will be black squares on 1st and 2nd digits,
			;^Note that this alone doesn't disable time bonus on level completion.
		!Setting_SuperStatusBar_Time_XPos #= 19
		!Setting_SuperStatusBar_Time_YPos #= 3
		!Setting_SuperStatusBar_Time_CountdownSpeed = $28	;>Number of frames between each the timer decrement, lower = faster. $28 by default, $3C would be real a second (1 frame = 1/60th of a second). NOTE: Setting this to 0 will decrement by 1 per frame.
		!Setting_SuperStatusBar_Time_LowWarning = 1		;>0 = No, 1 = Yes (turns red below 100, beeps below 10).
	;Score (numbers only). Note, this only covers the "active" digits, where the tiles can change. There is one inactive digit which is a fake "0" at the end and the score is actually stored in memory divided by 10
	;(a "10" on the HUD means 1 in memory). That last 0 is a static tile not written every frame. If you move this, you'll need to modify the fake 0 as well (it shall be located at
	;Score_XPos + 6, in this default case, 23+6 = 29).
		!Setting_SuperStatusBar_Score_Enable = 1	;>Note: When disabled, will still display "0" (static tile) on last tile. Recommend installing a "Disable Score" patch if you set this to 0.
		!Setting_SuperStatusBar_Score_XPos #= 23
		!Setting_SuperStatusBar_Score_YPos #= 3
	;Lives
		!Setting_SuperStatusBar_Lives_Enable = 1	;>Disabling would only affect display
		!Setting_SuperStatusBar_Lives_XPos #= 4
		!Setting_SuperStatusBar_Lives_YPos #= 3
	;Coin
		!Setting_SuperStatusBar_Coins_Enable = 1
		!Setting_SuperStatusBar_Coins_XPos #= 28
		!Setting_SuperStatusBar_Coins_YPos #= 2
	;Player name ("MARIO"/"LUIGI")
		!Setting_SuperStatusBar_PlayerName_Enable = 1
		!Setting_SuperStatusBar_PlayerName_XPos #= 2
		!Setting_SuperStatusBar_PlayerName_YPos #= 2
	;Yoshi/Dragon coin
		!Setting_SuperStatusBar_DragonCoin_Enable = 1	;>Disabling would only affect display
		!Setting_SuperStatusBar_DragonCoin_XPos #= 8
		!Setting_SuperStatusBar_DragonCoin_YPos #= 2
		!Setting_SuperStatusBar_DragonCoin_Empty = $FC	;>Tile number when yoshi coin is not collected
		!Setting_SuperStatusBar_DragonCoin_Full = $2E	;>Tile number when yoshi coin is collected
	;Bonus stars
		!Setting_SuperStatusBar_BonusStars_Enable = 1
			;^Note that vanilla goal WILL STILL USE bonus stars, despite this disabled. Recommended using custom goal (or goal screen) instead.
			; - 0 = Disable
			; - 1 = Enable (8x16 digits)
			; - 2 = Enable (8x8 digits)
		!Setting_SuperStatusBar_BonusStars_XPos #= 12    ;\XY position, OF THE BOTTOM-LEFT CORNER of the 2x2 8x8 pixel tiles. If set to be 8x8 pixels rather than 8x16 pixels digits, then it's the 10s place digit.
		!Setting_SuperStatusBar_BonusStars_YPos #= 03    ;/Note that if set to use 8x16 and is placed at Y=0, would write the top-half of the digits at invalid address, thus a failsafe is added.
	;Item box
		!Setting_SuperStatusBar_ItemBox_PixelXPos         = $78 ;\XY position (in pixels) the item box is DISPLAYED, but not
		!Setting_SuperStatusBar_ItemBox_PixelYPos         = $0F ;/where it drops from. Relative to screen.
		!Setting_SuperStatusBar_ItemBox_DropPos_PixelXPos = $78 ;\XY position of a dropped item.
		!Setting_SuperStatusBar_ItemBox_DropPos_PixelYPos = $20 ;/
		!Setting_SuperStatusBar_ItemBox_Prop = %00110000 ;>Sprite YXPPCCCT (not YXPCCCTT) handler (please see smw disassembly at $0090B7, it's ORA'ed at $00)
		!Setting_SuperStatusBar_ItemBox_OAMExtraBits = %00000010 ;>Extra bits: %00000000 = 8x8, %00000010 = 16x16. Don't use any other values.

;Don't modify anything below here unless you know what you're doing.
	;This function converts XY position to address.
		if not(defined("FunctionGuard_StatusBarFunctionDefined"))
			;^This if statement prevents an issue where "includeonce" is "ignored" if two ASMs files
			; incsrcs to the same ASM file with a different path due to asar not being able to tell
			; if the incsrc'ed file is the same file: https://github.com/RPGHacker/asar/issues/287
			
			;^Yes, this if statement seems rendundant. But it some rare chance a future ASM resource need this define
			; file rather than its own define file that have a define pointing to what this define file defines !Freeram_SuperStatusBar_TileData.
			; This incsrc problem happens when having a tool ASM file's routines resource and the main ASM file both incsrc to a
			; define file with a macro/define.
			
			function SuperStatusBarXYToAddr(x, y) = !Freeram_SuperStatusBar_TileData+(x*2)+(y*32*2)
			
			macro CheckSuperStatusBarXYPositionValid(x, y)
				assert and(and(greaterequal(<x>, 0), lessequal(<x>, 31)), and(greaterequal(<y>, 0), lessequal(<y>, 4))), "Coordinate out of range."
			endmacro
		endif
	;This checks if values entered are wrong
		%CheckSuperStatusBarXYPositionValid(!Setting_SuperStatusBar_Time_XPos, !Setting_SuperStatusBar_Time_YPos)
		%CheckSuperStatusBarXYPositionValid(!Setting_SuperStatusBar_Score_XPos, !Setting_SuperStatusBar_Score_YPos)
		%CheckSuperStatusBarXYPositionValid(!Setting_SuperStatusBar_Lives_XPos, !Setting_SuperStatusBar_Lives_YPos)
		%CheckSuperStatusBarXYPositionValid(!Setting_SuperStatusBar_Coins_XPos, !Setting_SuperStatusBar_Coins_YPos)
		%CheckSuperStatusBarXYPositionValid(!Setting_SuperStatusBar_PlayerName_XPos, !Setting_SuperStatusBar_PlayerName_YPos)
		%CheckSuperStatusBarXYPositionValid(!Setting_SuperStatusBar_DragonCoin_XPos, !Setting_SuperStatusBar_DragonCoin_YPos)
		%CheckSuperStatusBarXYPositionValid(!Setting_SuperStatusBar_BonusStars_XPos, !Setting_SuperStatusBar_BonusStars_YPos)
		assert and(greaterequal(!Setting_SuperStatusBar_DMAChannel, 0), lessequal(!Setting_SuperStatusBar_DMAChannel, 7)), "Invalid DMA channel to use."
		assert not(and(equal(!Setting_SuperStatusBar_BonusStars_Enable, 1), equal(!Setting_SuperStatusBar_BonusStars_YPos, 0))), "8x16 graphic digit bonus stars cannot be placed at Y=0."
	;Calculate some stuff for defines
		!Setting_SuperStatusBar_Time_XYToAddress #= SuperStatusBarXYToAddr(!Setting_SuperStatusBar_Time_XPos, !Setting_SuperStatusBar_Time_YPos)
		!Setting_SuperStatusBar_Score_XYToAddress #= SuperStatusBarXYToAddr(!Setting_SuperStatusBar_Score_XPos, !Setting_SuperStatusBar_Score_YPos)
		!Setting_SuperStatusBar_Lives_XYToAddress #= SuperStatusBarXYToAddr(!Setting_SuperStatusBar_Lives_XPos, !Setting_SuperStatusBar_Lives_YPos)
		!Setting_SuperStatusBar_Coins_XYToAddress #= SuperStatusBarXYToAddr(!Setting_SuperStatusBar_Coins_XPos, !Setting_SuperStatusBar_Coins_YPos)
		!Setting_SuperStatusBar_PlayerName_XYToAddress #= SuperStatusBarXYToAddr(!Setting_SuperStatusBar_PlayerName_XPos, !Setting_SuperStatusBar_PlayerName_YPos)
		!Setting_SuperStatusBar_DragonCoin_XYToAddress #= SuperStatusBarXYToAddr(!Setting_SuperStatusBar_DragonCoin_XPos, !Setting_SuperStatusBar_DragonCoin_YPos)
		!Setting_SuperStatusBar_BonusStars_XYToAddress #= SuperStatusBarXYToAddr(!Setting_SuperStatusBar_BonusStars_XPos, !Setting_SuperStatusBar_BonusStars_YPos)
		
		!Setting_SuperStatusBar_Reg_43X0 #= $4300+(!Setting_SuperStatusBar_DMAChannel<<4)
		!Setting_SuperStatusBar_Reg_DMAEnable = (1<<!Setting_SuperStatusBar_DMAChannel)
;Valid numbers for these offsets: $000-$13F
;Use even numbers ONLY!
;Properties (palette/ect) are set in the DATA_TILES tables, or using Smallhacker's status bar editor
;They are not updated automatically if you just change these 
;If you move the time counter, for example, it will probably be white until you change the properties byte
;of the tiles it writes to (through ASM, since it writes using DMA).

;If you want to remove a counter/routine controlled tile(s), change the "1"'s in labels that have "!Enable"
;in its name to 0. Note that it does not guarantee there will be a blank tile left behind when removed.