;This patch modifes the vanilla tiles that were reused despite the super status bar patches "Advanced" and
;"Compatability" being applied. See DefaultTiles.png for reference.
;If you want to easily change all tiles within a row more easily, I strongly recommend using notepad++,
;and hold down ALT, then either:
; - With a mouse, click and drag, or;
; - hold down SHIFT, and expand the box with the arrow keys.
;
;Tables here are the same format as the aformentioned patches.
	org $008C81
		;Top 4 tiles of the item box
			db $3A,%00111000	;>(14, 01)
			db $3B,%00111000	;>(15, 01)
			db $3B,%00111000	;>(16, 01)
			db $3A,%01111000	;>(17, 01)
	org $008C89
		;Top RAM-editable row:
			db $30,%00101000	;>(02, 02) \Player name
			db $31,%00101000	;>(03, 02) |
			db $32,%00101000	;>(04, 02) |
			db $33,%00101000	;>(05, 02) |
			db $34,%00101000	;>(06, 02) /
			db $FC,%00111000	;>(07, 02)
			db $FC,%00111100	;>(08, 02) \Yoshi coin counter (via repeated icons)
			db $FC,%00111100	;>(09, 02) |
			db $FC,%00111100	;>(10, 02) |
			db $FC,%00111100	;>(11, 02) /
			db $FC,%00111000	;>(12, 02) \Upper half of bonus stars
			db $FC,%00111000	;>(13, 02) /
			db $4A,%00111000	;>(14, 02) >Part of item box border
			db $FC,%00111000	;>(15, 02) \Space for sprite item box
			db $FC,%00111000	;>(16, 02) /
			db $4A,%01111000	;>(17, 02) >Part of item box border
			db $FC,%00111000	;>(18, 02)
			db $3D,%00111100	;>(19, 02) \"TIME"
			db $3E,%00111100	;>(20, 02) |
			db $3F,%00111100	;>(21, 02) /
			db $FC,%00111000	;>(22, 02)
			db $FC,%00111000	;>(23, 02)
			db $FC,%00111000	;>(24, 02)
			db $2E,%00111100	;>(25, 02) >Coin symbol
			db $26,%00111000	;>(26, 02) >"X"
			db $FC,%00111000	;>(27, 02)
			db $FC,%00111000	;>(28, 02) \Coin counter
			db $00,%00111000	;>(29, 02) /
		;Bottom RAM-editable row:
			db $26,%00111000	;>(03, 03) >"X"
			db $FC,%00111000	;>(04, 03) \Lives counter
			db $00,%00111000	;>(05, 03) /
			db $FC,%00111000	;>(06, 03)
			db $FC,%00111000	;>(07, 03)
			db $FC,%00111000	;>(08, 03)
			db $64,%00101000	;>(09, 03) >Star symbol
			db $26,%00111000	;>(10, 03) >"X"
			db $FC,%00111000	;>(11, 03)
			db $FC,%00111000	;>(12, 03) \Lower half of Bonus stars
			db $FC,%00111000	;>(13, 03) /
			db $4A,%00111000	;>(14, 03) >Part of Item box border
			db $FC,%00111000	;>(15, 03) \Space for item box border
			db $FC,%00111000	;>(16, 03) /
			db $4A,%01111000	;>(17, 03) >Part of Item box border
			db $FC,%00111000	;>(18, 03)
			db $FE,%00111100	;>(19, 03) \Time digits
			db $FE,%00111100	;>(20, 03) |
			db $00,%00111100	;>(21, 03) /
			db $FC,%00111000	;>(22, 03)
			db $FC,%00111000	;>(23, 03) \Score (active digits)
			db $FC,%00111000	;>(24, 03) |
			db $FC,%00111000	;>(25, 03) |
			db $FC,%00111000	;>(26, 03) |
			db $FC,%00111000	;>(27, 03) |
			db $FC,%00111000	;>(28, 03) /
			db $00,%00111000	;>(29, 03) >Score (static 0, not written every frame)
	org $008CF7
		;Bottom 4 tiles of the item box
			db $3A,%10111000	;>(14, 04)
			db $3B,%10111000	;>(15, 04)
			db $3B,%10111000	;>(16, 04)
			db $3A,%11111000	;>(17, 04)