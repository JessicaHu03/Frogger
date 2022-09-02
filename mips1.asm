#####################################################################
#
# CSC258H5S Winter 2022 Assembly Final Project
# University of Toronto, St. George
#
# Student: Wanting Hu, 1006906920
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 4 (choose the one the applies)
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. Frog point to desired direction
# 2. Row 1 and Row 2 move in different speed
# 3. Display remaining life
# 4. Death Animation
#
# Any additional information that the TA needs to know:
# - do NOT touc region3, there is a bug
# - bug: frog do not drown when in river
# - bug: cannot determine IfRegion3 is filled and win the game
# - tried to add powerup(energy) and round but gave up
#####################################################################



.data
displayAddress: .word 0x10008000
	
FrogBodyColor:	.word 0x4ebf30	# color of frog body, darker green
FrogLegColor:	.word 0x5fea3b	# color of frog legs, lighter green
FrogEyeColor:	.word 0x000000	# color of frog eyes, black
	
Red:		.word 0xff0000	# color of lifebar and blood
Yellow:		.word 0xffff00

RoadColor:	.word 0x708090
RiverColor:	.word 0x97d9f4
GrassColor:	.word 0x90EE90
DarkGrass: 	.word 0x7fffd4
	
CarColor1:	.word 0xabeffc  # color of car head, blue
CarColor2:	.word 0xad80c1	# Color of car body, scarlet 
CarColor3: 	.word 0xf03147	# color of car head, red
CarColor4: 	.word 0xeb9ca5	# color of car body, coral 
	
LogColor:	.word 0xc17f64	# color of log

FrogCoord: 	.word 0:3  # 1 is frog X coordinate, 2 is frog Y coordinate, 3 is frog direction (1=up, 2=down, 3=left, 4=right)
CarsCoord:	.word 0x708090:128  # car row moving left, road color
LogsCoord:	.word 0x97d9f4:128  # log row moving left, river color

Rates:		.word 0:4  # The rate to cycle the two logs rows and the two cars rows
		
Life:		.word 3  # the health value of frog(should be 3 unless get extra health)
Status:		.word 0:5  # The status of energy, life, region 1, region 2, region 3
	
.text

# Restar the game
Initialization:		
		la $s4, Status  # t4 -> status
		sw $zero, ($s4)  # energy status = 0
		sw $zero, 4($s4)  # life status = 0
		sw $zero, 8($s4)  # region 1 status = 0
		sw $zero, 12($s4)  # region 2 status = 0
		sw $zero, 16($s4)  # region 3 status = 0

		la $t3, Rates   # t3 = rates
		sw $zero, ($t3)  # Log1 = 0
		sw $zero, 4($t3)  # Log2 = 0
		sw $zero, 8($t3)  # Car1 = 0
		sw $zero, 12($t3)  # Car 2 = 0

		lw $s0, Life  # s0 = life
		
PartialInit:	
		sw $zero, 8($s4)  # region 1 unfilled
		sw $zero, 12($s4)  # region 2 unfilled
		sw $zero, 16($s4)  # region 3 unfilled	
# InitFrog
		la $t6, FrogCoord  # $t6 stores the X coordinate of the frog's location, and whether frog is on a log
		addi $t4, $zero, 13  # store 13 into t4 (initial X coordinate of frog)
		addi $t5, $zero, 28  # store 28 into t5 (initial Y coordinate of frog)
		sw $t4, ($t6) # store X ccordinate into t6
		sw $t5, 4($t6)  # store Y ccordinate into the next word from t6
		sw $zero, 8($t6)  # set frog to face forward initially

InitLogs:
		add $t4, $zero, $zero  # set t4 to 0
		addi $t5, $zero, 128  # set t5 to 128 (count 128 spots)
		la $t2, LogsCoord  # load the address of vehicle rows into t2
		lw $s1, RiverColor  # set s1 to store aqua
			
LogsLoop:	beq $t4, $t5, LogsLoopEnd  # while t4 < t5
		sw $s1, ($t2)  # store slate grey into the memory address
		addi $t2, $t2, 4  # increment t2 by 4 (move on to next unit)
		addi $t4, $t4, 1  # increment counter by 1
		j LogsLoop
LogsLoopEnd:	
	
InitCars:
		add $t4, $zero, $zero  # set t4 to 0
		addi $t5, $zero, 128  # set t5 to 128 (count 128 spots)
		la $t2, CarsCoord  # load the address of vehicle rows into t2
		lw $s1, RoadColor  # set s1 to store slate grey
			
CarsLoop:	beq $t4, $t5, CarsLoopEnd  # while t4 < t5
		sw $s1, ($t2)  # store slate grey into the memory address
		addi $t2, $t2, 4  # increment t2 by 4 (move on to next unit)
		addi $t4, $t4, 1  # increment counter by 1
		j CarsLoop
CarsLoopEnd:			
				
# DrawLogs	
		la $t8, LogsCoord #t8 = LogCoord
		lw $s1, LogColor  # s1 = log color	
			
		# Row 1
		sw $s1, 0($t8)
		sw $s1, 4($t8)
		sw $s1, 8($t8)
		sw $s1, 12($t8)
		sw $s1, 16($t8)
		sw $s1, 20($t8)
		sw $s1, 24($t8)
		sw $s1, 28($t8)	
		sw $s1, 32($t8)	
		
		sw $s1, 64($t8)
		sw $s1, 68($t8)
		sw $s1, 72($t8)
		sw $s1, 76($t8)
		sw $s1, 80($t8)
		sw $s1, 84($t8)
		sw $s1, 88($t8)
		sw $s1, 92($t8)
		sw $s1, 96($t8)	
			
			
		# Row 2
		sw $s1, 128($t8)
		sw $s1, 132($t8)
		sw $s1, 136($t8)
		sw $s1, 140($t8)
		sw $s1, 144($t8)
		sw $s1, 148($t8)
		sw $s1, 152($t8)
		sw $s1, 156($t8)	
		sw $s1, 160($t8)	
		
		sw $s1, 192($t8)
		sw $s1, 196($t8)
		sw $s1, 200($t8)
		sw $s1, 204($t8)
		sw $s1, 208($t8)
		sw $s1, 212($t8)
		sw $s1, 216($t8)
		sw $s1, 220($t8)
		sw $s1, 224($t8)	
				
		# row 3
		sw $s1, 288($t8)
		sw $s1, 292($t8)
		sw $s1, 296($t8)
		sw $s1, 300($t8)
		sw $s1, 304($t8)
		sw $s1, 308($t8)
		sw $s1, 312($t8)
		sw $s1, 316($t8)	
		sw $s1, 320($t8)	

		sw $s1, 352($t8)
		sw $s1, 356($t8)
		sw $s1, 360($t8)
		sw $s1, 364($t8)
		sw $s1, 368($t8)
		sw $s1, 372($t8)
		sw $s1, 376($t8)
		sw $s1, 380($t8)
	
		# row 4
		sw $s1, 416($t8)
		sw $s1, 420($t8)
		sw $s1, 424($t8)
		sw $s1, 428($t8)
		sw $s1, 432($t8)
		sw $s1, 436($t8)
		sw $s1, 440($t8)
		sw $s1, 444($t8)		
		sw $s1, 448($t8)	
		
		sw $s1, 480($t8)
		sw $s1, 484($t8)
		sw $s1, 488($t8)
		sw $s1, 492($t8)
		sw $s1, 496($t8)
		sw $s1, 500($t8)
		sw $s1, 504($t8)
		sw $s1, 508($t8)
		
# DrawCars
		la $t7, CarsCoord  # $t7 holds address of vehicleRow1
		
		# Row 1
		lw $s1, CarColor1  # s1 is blue
		lw $s2, CarColor2  # s2 is scarlet 
		sw $s1, 16($t7)
		sw $s1, 20($t7)
		sw $s1, 24($t7)
		sw $s2, 28($t7)
		sw $s2, 32($t7)
		sw $s2, 36($t7)
		sw $s2, 40($t7)
		sw $s2, 44($t7)
		sw $s1, 80($t7)
		sw $s1, 84($t7)
		sw $s1, 88($t7)
		sw $s2, 92($t7)
		sw $s2, 96($t7)
		sw $s2, 100($t7)
		sw $s2, 104($t7)
		sw $s2, 108($t7)
		
		# Row 2
		sw $s1, 144($t7)
		sw $s1, 148($t7)
		sw $s1, 152($t7)
		sw $s2, 156($t7)
		sw $s2, 160($t7)
		sw $s2, 164($t7)
		sw $s2, 168($t7)
		sw $s2, 172($t7)
		sw $s1, 208($t7)
		sw $s1, 212($t7)
		sw $s1, 216($t7)
		sw $s2, 220($t7)
		sw $s2, 224($t7)
		sw $s2, 228($t7)
		sw $s2, 232($t7)
		sw $s2, 236($t7)
			
		# Row 3
		lw $s1, CarColor3  # s1 is red
		lw $s2, CarColor4 # s2 is coral
		sw $s2, 256($t7)
		sw $s2, 260($t7)
		sw $s2, 264($t7)
		sw $s2, 268($t7)
		sw $s2, 272($t7)
		sw $s1, 276($t7)
		sw $s1, 280($t7)
		sw $s1, 284($t7)	
		sw $s2, 320($t7)
		sw $s2, 324($t7)
		sw $s2, 328($t7)
		sw $s2, 332($t7)
		sw $s2, 336($t7)
		sw $s1, 340($t7)
		sw $s1, 344($t7)
		sw $s1, 348($t7)
			
		# Row 4
		sw $s2, 384($t7)
		sw $s2, 388($t7)
		sw $s2, 392($t7)
		sw $s2, 396($t7)
		sw $s2, 400($t7)
		sw $s1, 404($t7)
		sw $s1, 408($t7)
		sw $s1, 412($t7)	
		sw $s2, 448($t7)
		sw $s2, 452($t7)
		sw $s2, 456($t7)
		sw $s2, 460($t7)
		sw $s2, 464($t7)
		sw $s1, 468($t7)
		sw $s1, 472($t7)
		sw $s1, 476($t7)
			

# Game Start
DrawCanvas:	lw $t0, displayAddress # t0 = display address
		lw $t1, GrassColor # t1 = GrassColor
		add $t4, $zero, $zero  # t4 = 0 
		addi $t5, $zero, 192   # t5 = 192

TopStart:	beq $t4, $t5, TopEnd  # while $t4 != $t5
		sw $t1, ($t0)  # paint
		addi $t4, $t4, 1  # t4++
		addi $t0, $t0, 4  # next unit
		j TopStart  # jump to TopStart	
TopEnd: 	


# Region 1
		lw $t4, 8($s4)  # t4 = region1 status
		beq $t4, 1, CompletedRegion1 # if region1 is touched, fill it in
						# else, leave it unfilled

		lw $s1, displayAddress # s1 = address for display
		addi $s1, $s1, 256  # next row
		lw $t1, DarkGrass # t1 = DarkGrass
		add $t4, $zero, $zero  # t4 = 0
		addi $t5, $zero, 4   # t5 = 4 

Region1Start:	beq $t4, $t5, Region1End  # while $t4 != $t5
		sw $t1, 8($s1)  # paint the square unfilled
		sw $t1, 12($s1)  
		sw $t1, 16($s1)  
		sw $t1, 20($s1)  
		addi $s1, $s1, 128  # next row
		addi $t4, $t4, 1  # t4 ++
		j Region1Start  # jump to Region1Start	
Region1End: 	
		j CompletedRegion1End # jump to CompletedRegion1End

CompletedRegion1:
		lw $s1, displayAddress # s1 = display address
		lw $t1, GrassColor # $t1 = GrassColor
		add $t4, $zero, $zero  # t4 = 0
		addi $t5, $zero, 4   # t5 = 4
		addi $s1, $s1, 256  # next row

CompletedRegion1Loop:
		beq $t4, $t5, CompletedRegion1End  # while t4 ?= t5
		sw $t1, 8($s1)  # filled the square
		sw $t1, 12($s1)  
		sw $t1, 16($s1)  
		sw $t1, 20($s1)  
		addi $s1, $s1, 128  # next row
		addi $t4, $t4, 1  # t4++
		j CompletedRegion1Loop # jump to CompletedRegion1Loop
CompletedRegion1End:
		
	
	
# Region 2
		lw $t4, 12($s4)  # t4 = region1 status
		beq $t4, 1, CompletedRegion2  # if area2 is touched, fill it in
						# else, leave it unfilled
					
		lw $s1, displayAddress # s1 = display address
		lw $t1, DarkGrass # t1 = DarkGrass
		add $t4, $zero, $zero  # t4 = 0 
		addi $t5, $zero, 4   # t5 = 4
		addi $s1, $s1, 256  # next row

Region2Start:	beq $t4, $t5, Region2End # while t4 != t5
		sw $t1, 48($s1)  # draw the square
		sw $t1, 52($s1) 
		sw $t1, 56($s1)  
		sw $t1, 60($s1)  
		addi $s1, $s1, 128  # next row
		addi $t4, $t4, 1  # t4 ++
		j Region2Start  # jump to Region2Start
Region2End: 	
		j CompletedRegion2End  # jump to CompletedRegion2End

CompletedRegion2:
		lw $s1, displayAddress # s1 = display address
		lw $t1, GrassColor # $t1 = GrassColor
		add $t4, $zero, $zero  # t4 = 0
		addi $t5, $zero, 4   # t5 = 4
		addi $s1, $s1, 256  # next row

CompletedRegion2Loop:
		beq $t4, $t5, CompletedRegion2End  # while t4 ?= t5
		sw $t1, 8($s1)  # filled the square
		sw $t1, 12($s1)  
		sw $t1, 16($s1)  
		sw $t1, 20($s1)  
		addi $s1, $s1, 128  # next row
		addi $t4, $t4, 1  # t4++
		j CompletedRegion2Loop # jump to CompletedRegion1Loop
CompletedRegion2End:
			

# Region 3		
		lw $t4, 16($s4)  # t4 = region1 status
		beq $t4, 1, CompletedRegion3  # if area2 is touched, fill it in
						# else, leave it unfilled
						
		lw $s1, displayAddress # s1 = display address
		lw $t1, DarkGrass # t1 = DarkGrass
		add $t4, $zero, $zero  # t4 = 0 
		addi $t5, $zero, 4   # t5 = 4
		addi $s1, $s1, 256  # next row

Region3Start:	beq $t4, $t5, Region3End # while t4 != t5
		sw $t1, 88($s1)  # draw the square
		sw $t1, 92($s1) 
		sw $t1, 96($s1)  
		sw $t1, 100($s1)  
		addi $s1, $s1, 128  # next row
		addi $t4, $t4, 1  # t4 ++
		j Region3Start  # jump to Region3Start
Region3End: 	
		j CompletedRegion3End  # jum to CompletedRegion3End

CompletedRegion3:
		lw $s1, displayAddress # s1 = display address
		lw $t1, GrassColor # $t1 = GrassColor
		add $t4, $zero, $zero  # t4 = 0
		addi $t5, $zero, 4   # t5 = 4
		addi $s1, $s1, 256  # next row

CompletedRegion3Loop:
		beq $t4, $t5, CompletedRegion3End  # while t4 != t5
		sw $t1, 8($s1)  # filled the square
		sw $t1, 12($s1)  
		sw $t1, 16($s1)  
		sw $t1, 20($s1)  
		addi $s1, $s1, 128  # next row
		addi $t4, $t4, 1  # t4++
		j CompletedRegion3Loop # jump to CompletedRegion3Loop
CompletedRegion3End:	
			


# Logs
		add $s6, $zero, $zero # s6 = 0
		addi $s7, $zero, 3 #s7 = 3

LogsIteration:	beq $s6, $s7, LogsIterationEnd # while s6 != s7
		add $t2, $zero, $t8  # t2 = next row
		add $t4, $zero, $zero  # t4 = 0
		addi $t5, $zero, 32  # t5 = 32
		
Log1Start:	beq $t4, $t5, Log1End # while t4 != t5
		lw $t1, ($t2) # t1 = LogColor
		sw $t1, ($t0)  # paint
		addi $t0, $t0, 4  # next unit
		addi $t4, $t4, 1  # t4 ++
		addi $t2, $t2, 4  # t2 += 4
		j Log1Start  # jump to Log1Start				
Log1End:	addi $s6, $s6, 1 # s6++
		j LogsIteration #jump to LogsIteration

LogsIterationEnd:
	
		addi $t2, $t8, 128  # t2 = next row
		add $t4, $zero, $zero  # t4 = 0
		addi $t5, $zero, 32  # t5 = 32
Log2Start:	beq $t4, $t5, Log2End # while t4 != t5
		lw $t1, ($t2) # t1 = LogColor
		sw $t1, ($t0)  # paint
		addi $t0, $t0, 4  # next unit
		addi $t4, $t4, 1  # t4 ++
		addi $t2, $t2, 4  # t2 += 4
		j Log2Start  # jump to Log2Start	
		
Log2End:	add $s6, $zero, $zero # s6 = 0
		addi $s7, $zero, 3 # s7 = 3


LogsIteration2:	beq $s6, $s7, LogsIteration2End # while s6 != s7
		addi $t2, $t8, 256  # t2 = next row
		add $t4, $zero, $zero  # t4 = 0
		addi $t5, $zero, 32  # t5 =32
		
Log3Start:	beq $t4, $t5, Log3End # while t4 != t5
		lw $t1, ($t2) # t1 = LogColor
		sw $t1, ($t0)  # paint
		addi $t0, $t0, 4  # next unit
		addi $t4, $t4, 1  # t4 ++
		addi $t2, $t2, 4  # t2 += 4
		j Log3Start  # jump to Log3Start		
Log3End:	addi $s6, $s6, 1 # s6 ++
		j LogsIteration2	# jump to LogsIteration2

LogsIteration2End:	

		addi $t2, $t8, 384  # t2 = next row
		add $t4, $zero, $zero  # t4 = 0
		addi $t5, $zero, 32  # t5 = 32
		
Log4Start:	beq $t4, $t5, Log4End
		lw $t1, ($t2) # t1 = LogColor
		sw $t1, ($t0)  # paint 
		addi $t0, $t0, 4  # next unit
		addi $t4, $t4, 1  # t4 ++
		addi $t2, $t2, 4  # t2 += 4
		j Log4Start  # jump to Log4Start	
		
Log4End:	


# Middle Safe Zone
		add $t4, $zero, $zero  # t4 = 0
		addi $t5, $zero, 128  # t5 = 128	
		lw $t1, GrassColor  # t1 = GrassColor
		
MiddleStart:	beq $t4, $t5, MiddleEnd  # while t4 != t5
		sw $t1, ($t0)  # paint 
		addi $t0, $t0, 4  # next unit
		addi $t4, $t4, 1  # t4 ++
		j MiddleStart  # jump to MiddleStart		
MiddleEnd: 	


# Cars
		add $t4, $zero, $zero  # t4 = 0
		addi $t5, $zero, 32  # t5 = 32
		add $t2, $zero, $t7  # t2 = CarsCoord
	
Cars11Start:	beq $t4, $t5, Cars11End  # while t4 != t5
		lw $t1, ($t2) # t1 = CarColor
		sw $t1, ($t0)  # paint
		addi $t0, $t0, 4  # next unit
		addi $t4, $t4, 1  # t4 ++
		addi $t2, $t2, 4  # t2 += 4
		j Cars11Start  # jump to Cars1Start				
Cars11End:	


		add $t4, $zero, $zero  # t4 = 0
		addi $t5, $zero, 32  # t5 = 32 		
			
Cars12Start:	beq $t4, $t5, Cars12End  # while t4 != t5
		lw $t1, ($t2) # t1 = CarColor
		sw $t1, ($t0)  # paint
		addi $t0, $t0, 4  # next unit
		addi $t4, $t4, 1  # t4 ++
		addi $t2, $t2, 4  # t2 += 4
		j Cars12Start  # jump to Cars12Start				
Cars12End:	


		add $t4, $zero, $zero  # t4 = 0
		addi $t5, $zero, 32  # t5 = 32
		add $t2, $zero, $t7  # t2 = next row
		addi $t2, $t2, 128  # t2 = next row
	
Cars13Start:	beq $t4, $t5, Cars13End  # while t4 != t5
		lw $t1, ($t2) # t1 = CarColor
		sw $t1, ($t0)  # paint
		addi $t0, $t0, 4  # next unit
		addi $t4, $t4, 1  # t4 ++
		addi $t2, $t2, 4  # t2 += 4
		j Cars13Start  # jump to Cars13Start				
Cars13End:	


		add $t4, $zero, $zero  # t4 = 0
		addi $t5, $zero, 32  # t5 = 32
		add $t2, $zero, $t7  # t2 = next row

Cars14Start:	beq $t4, $t5, Cars14End  # while t4 != t5
		lw $t1, ($t2) # t1 = CarColor
		sw $t1, ($t0)  # paint
		addi $t0, $t0, 4  # next unit
		addi $t4, $t4, 1  # t4 ++
		addi $t2, $t2, 4  # t2 += 4
		j Cars14Start  # jump to Cars14Start			
Cars14End:	


		add $t4, $zero, $zero  # t4 = 0
		addi $t5, $zero, 32  # t5 = 32
		add $t2, $zero, $t7  # t2 = next row
		addi $t2, $t2, 256  # it2 = next next row
		
Cars21Start:	beq $t4, $t5, Cars21End  # while t4 != t5
		lw $t1, ($t2) # t1 = CarColor
		sw $t1, ($t0)  # paint
		addi $t0, $t0, 4  # next unit
		addi $t4, $t4, 1  # t4 ++
		addi $t2, $t2, 4  # t2 += 4
		j Cars21Start  # jump to Cars21Start				
Cars21End:	

		add $t4, $zero, $zero  # t4 = 0
		addi $t5, $zero, 32  # t5 = 32
		
Cars22Start:	beq $t4, $t5, Cars22End  # while t4 != t5
		lw $t1, ($t2) # t1 = CarColor
		sw $t1, ($t0)  # paint
		addi $t0, $t0, 4  # next unit
		addi $t4, $t4, 1  # t4 ++
		addi $t2, $t2, 4  # t2 += 4
		j Cars22Start  # jump to Cars22Start				
Cars22End:	


		add $t4, $zero, $zero  # t4 = 0
		addi $t5, $zero, 32  # t5 = 32
		addi $t2, $t7, 384  # $t2 += 3 next row

Cars23Start:	beq $t4, $t5, Cars23End  # while t4 != t5
		lw $t1, ($t2) # t1 = CarColor
		sw $t1, ($t0)  # paint
		addi $t0, $t0, 4  # next unit
		addi $t4, $t4, 1  # t4 ++
		addi $t2, $t2, 4  # t2 += 4
		j Cars23Start  # jump to Cars23Start				
Cars23End:	


		add $t4, $zero, $zero  # t4 = 0
		addi $t5, $zero, 32  # t5 = 32
		addi $t2, $t7, 256  # $t2 += 2 next row
		
Cars24Start:	beq $t4, $t5, Cars24End  # while t4 != t5
		lw $t1, ($t2) # t1 = CarColor
		sw $t1, ($t0)  # paint
		addi $t0, $t0, 4  # next unit
		addi $t4, $t4, 1  # t4 ++
		addi $t2, $t2, 4  # t2 += 4
		j Cars24Start  # jump to Cars24Start			
Cars24End:	


# Bottom
		add $t4, $zero, $zero  # t4 = 0
		addi $t5, $zero, 192  # t5 = 192
		lw $t1, GrassColor  # t1 = GrassColor
		
BottomStart:	beq $t4, $t5, BottomEnd  # while t4 != t5
		sw $t1, ($t0)  # paint 
		addi $t0, $t0, 4  # next unit
		addi $t4, $t4, 1  # t4 ++
		j BottomStart  # jump to BottomStart	
BottomEnd: 	
	

# Frog
		lw $t0, displayAddress  # t0 = display address
		lw $t4, ($t6) # t4 = FrogCoordX
		lw $t5, 4($t6) # t5 = frogCoordY
		
		sll $t2, $t5, 5  # t2 = 32*frogCoordY 
		add $t2, $t2, $t4  # t2 += frogCoordX
		sll $t2, $t2, 2  # shift to multiply 4
		add $t0, $t0, $t2  # crusor(t0) point to the frogCoord
		
		add $t4, $zero, $zero  # t4 = 0
		add $s1, $zero, $zero   # s1 = 0
		addi $s2, $zero, 4  # s2 = 4 
		add $t2, $zero, $t0  # t2 = t0

# Collision		
Collision:	
		beq $s1, $s2, CollisionLoopEnd   # while s1 < s2
		
		lw $t1, ($t2)  # t1 = frogBodyColor
		
		# if (color on t0 == Carcolor), frog die
		beq $t1, 0xabeffc, Death 
		beq $t1, 0xad80c1, Death
		beq $t1, 0xf03147, Death 
		beq $t1, 0xeb9ca5, Death  
			
			
		lw $t1, 4($t2)  # t1 = frogLegColor
		# if (color on t0 == Carcolor), frog die
		beq $t1, 0xabeffc, Death 
		beq $t1, 0xad80c1, Death
		beq $t1, 0xf03147, Death 
		beq $t1, 0xeb9ca5, Death  
		
		add $t4, $t4, $t1  # t4 += t1
				
		lw $t1, 8($t2)  # t1 = frogEyeColor
		# if (color on t0 == Carcolor), frog die
		beq $t1, 0xabeffc, Death 
		beq $t1, 0xad80c1, Death
		beq $t1, 0xf03147, Death 
		beq $t1, 0xeb9ca5, Death   
		
		add $t4, $t4, $t1  # t4 += t1	

		
		lw $t1, RiverColor  # t1 = RiverColor
		sll $t1, $t1, 4  # shift t1 to multiply 16
		beq $t4, $t1, Death  # if the frog in river, frog die
					# else frog can stand half body on log, half body in river, not die
CollisionLoopEnd:




# 4 Directions		
		lw $t1, FrogBodyColor  # t1 = FrogBody Color
		lw $s1, FrogEyeColor  # s1 = FrogEyeColor
		lw $s2, FrogLegColor  # s2 = FrogLegColor
# If Direction:	
		lw $t4, 8($t6)  # t4 = frog direction
		beq $t4, 2, Downward  #if direction = 2, facing downward	
		beq $t4, 3, Left  # if direction = 3, facing left
		beq $t4, 4, Right # if direction = 4, facing right
		j Forward #  otherwise, facing forward
	
Downward:	
		add $t4, $zero, $zero  # t4 = 0
		addi $t5, $zero, 2 # t5 = 2
BodyDownward:	
		beq $t4, $t5, BodyDownwardEnd  # while t4 < t5
		sw $s2, ($t0)  # Frog leg
		sw $t1, 4($t0)  # Frog Body
		sw $t1, 8($t0)  # Frog Body
		sw $s2, 12($t0)  # Frog Leg
		addi $t0, $t0, 128  # next row
		addi $t4, $t4, 1  # t4 ++
		j BodyDownward
BodyDownwardEnd:	

		sw $t1, 4($t0)  # Body
		sw $t1, 8($t0)  # Body
		addi $t0, $t0, 128  # next row
		sw $s1, ($t0)  # eye
		sw $s1, 12($t0)  # eye
		j DirectionEnd   # jump to DirectionEnd
		

Left:	
		sw $s1, ($t0)  # eye
		sw $s2, 8($t0)  # leg
		sw $s2, 12($t0)  # leg
		addi $t0, $t0, 128  # next row

		add $t4, $zero, $zero  # t4 = 0
		addi $t5, $zero, 2 # t5 = 5
BodyLeft:	beq $t4, $t5, BodyLeftEnd  # while t4 != t5:
		sw $t1, 4($t0)  # body
		sw $t1, 8($t0)  # body
		sw $t1, 12($t0)  # body
		addi $t0, $t0, 128  # next row
		addi $t4, $t4, 1  # t4++
		j BodyLeft		
BodyLeftEnd:	
		sw $s1, ($t0)  # eye
		sw $s2, 8($t0)  # pleg
		sw $s2, 12($t0)  # leg
		j DirectionEnd  # jump to DirectionEnd


Right:	
		sw $s2, ($t0)  # leg
		sw $s2, 4($t0)  # leg
		sw $s1, 12($t0)  # eye
		addi $t0, $t0, 128  # next row

		add $t4, $zero, $zero  # t4 = 0
		addi $t5, $zero, 2 # t5 = 2
BodyRight:	beq $t4, $t5, BodyRightEnd  # while t4 != t5:
		sw $t1, ($t0)  # body
		sw $t1, 4($t0)  # body
		sw $t1, 8($t0)  # body
		addi $t4, $t4, 1  # t4 ++
		
		addi $t0, $t0, 128  # next row
		j BodyRight
BodyRightEnd:	
		sw $s2, ($t0)  # leg
		sw $s2, 4($t0)  # leg
		sw $s1, 12($t0)  # eye
		j DirectionEnd  # jump to DirectionEnd

Forward: 	
		sw $s1, ($t0)  # eyes
		sw $s1, 12($t0) 
		addi $t0, $t0, 128  # next row
		sw $t1, 4($t0)  # body
		sw $t1, 8($t0)  # body
		addi $t0, $t0, 128  # next row
		
		add $t4, $zero, $zero  # t4 =0	
		addi $t5, $zero, 2 # t5 = 2
BodyForward:	beq $t4, $t5, DirectionEnd  # while t4 != t5
		sw $s2, ($t0)  # leg
		sw $t1, 4($t0)  # body
		sw $t1, 8($t0)  # body
		sw $s2, 12($t0)  # leg
		addi $t4, $t4, 1  # t4++
		addi $t0, $t0, 128  # next row
		j BodyForward	
DirectionEnd:	


# Life	
		lw $t0, displayAddress  # t0 = display address
		li $t4, 2 # t4 = frogCoordX
		li $t5, 30 # t5 = frogCoordY
		
		sll $t2, $t5, 5  # shift t2 to multiply 32
		add $t2, $t2, $t4  # t2 += t4
		sll $t2, $t2, 2  # shift t2 to multiply 4
		add $t0, $t0, $t2  # t0 = new cursor
		
		lw $s1, Yellow  # s1 = yellow
		lw $s2, Red  # s2 = red
		
		beq $s0, 1, OneOverThree   # if life = 1, 1/3 bar
		beq $s0, 2, TwoOverThree   # if life = 2, 2/3 bar
		beq $s0, 3, Full   # if life = 3, full bar


# color 1/3 bar red
OneOverThree:	sw $s2, ($t0)  
		sw $s2, 4($t0) 
		sw $s1, 8($t0) 
		sw $s1, 12($t0) 
		sw $s1, 16($t0) 
		sw $s1, 20($t0) 
		j LifeEnd	

# color 2/3 bar red			
TwoOverThree:	sw $s2, ($t0) 
		sw $s2, 4($t0) 
		sw $s2, 8($t0) 
		sw $s2, 12($t0) 
		sw $s1, 16($t0) 
		sw $s1, 20($t0)
		j LifeEnd
			
# color full bar red	
Full:		sw $s2, ($t0)  
		sw $s2, 4($t0) 
		sw $s2, 8($t0) 
		sw $s2, 12($t0) 
		sw $s2, 16($t0) 
		sw $s2, 20($t0) 
LifeEnd:

# service 32 for 16ms (60 times per second as required)
SLEEP:	
		li $v0, 32
		li $a0, 16  
		syscall


# Animation
		addi $t5, $zero, 30  # t5 = 30
		j RefreshLog1  # jump to RefreshLog1

	
RefreshLog1:	lw $t1, ($t3)  # t1 = t3
		beq $t1, $t5, ResetLog1Num  # when t1 = t5, do ResetLog1Counte
		addi $t1, $t1, 1  # t1 ++
		sw $t1, ($t3)  #t1 = t3
		j Log1ResetEnd  # jump to Log1ResetEnd
		
ResetLog1Num:
		add $t1, $zero, $zero  # t1 = 0
		sw $t1, ($t3)  # t1 = t3
		add $t2, $zero, $t8  # t2 = LogCoord
		lw $t1, ($t2)  # t1 = t2(color1)
		lw $s1, 128($t2)  # s1 = t2(next color1)
		add $t4, $zero, $zero  # t4 = 0
		addi $t5, $zero, 31  # t5 = 31
RefreshLog1Loop:	
		beq $t4, $t5, RefreshLog1End  # while t4 != t5
		lw $s2, 4($t2)  # s2 = t2(color2)
		lw $s3, 132($t2)  # s3 = t2(next color2)
		sw $s2, ($t2)	# s2 = t2(color1)
		sw $s3, 128($t2)  # s3 = s1 = t2(next color1)
			
		addi $t4, $t4, 1  # t4 ++
		addi $t2, $t2, 4  # t2 += 4
		j RefreshLog1Loop  # jump to RefreshLog1Loop	
RefreshLog1End:	
		sw $t1, ($t2)  # t1 = (t2)
		sw $s1, 128($t2)  # t1 = (t2 next row)	
		
		lw $t2, 4($t6)  # t2 = frogCoordY
		beq $t2, 6, RefreshFrog1  # if frog on log, do RefreshFrog1 
		j RefreshFrog1End   # jump to RefreshFrog1End
			
RefreshFrog1:	
		lw $t4, ($t6)  # t4 = t6
		subi $t4, $t4, 1  # t4 -= 1
		sw $t4, ($t6)  # t6 = t4	
RefreshFrog1End:

Log1ResetEnd:


# Log 2
		addi $t5, $zero, 50  # t5 = 50
		j RefreshLog2  # jump to RefreshLog2
	
RefreshLog2:	lw $t1, 4($t3)  # t1 = t3(color2)
		beq $t1, $t5, ResetLog2Num  # when t1 = t5, ResetLog2Num
		addi $t1, $t1, 1  # t1 ++
		sw $t1, 4($t3)  #t3 = t3(color2)
		j Log2ResetEnd  # jump to Log2ResetEnd
		
ResetLog2Num:	
		add $t1, $zero, $zero  # t1 = 0
		sw $t1, 4($t3)  # t3 = t1
		addi $t2, $t8, 380  # t2 = t8 +380		
		lw $t1, ($t2)  # t1 = t2
		lw $s1, 128($t2)  # s1 = t2 next row
		
		add $t4, $zero, $zero  # t4 = 0
		addi $t5, $zero, 31  # t5 = 31
RefreshLog2Loop:	
		beq $t4, $t5, RefreshLog2End  # while t4 != t5
		lw $s2, -4($t2)  # s2 = t2(secondlast)
		lw $s3, 124($t2)  # s3 = t2(next row)
		sw $s2, ($t2)	# overwrite t2 with s2
		sw $s3, 128($t2)  # overwrite t2(next row) with s3
			
		addi $t4, $t4, 1  # t4 ++
		addi $t2, $t2, -4  # t2 -= 4
		j RefreshLog2Loop  # jump to RefreshLog2Loop
			
RefreshLog2End:	
		sw $t1, ($t2)  # overwrite t2 with t1
		sw $s1, 128($t2)  # overwrite t2(next row) with s1
			
		lw $t2, 4($t6)  # t2 = frogCoordY
		beq $t2, 10, RefreshFrog2  # if frog on log, update RefreshFrog2
		j Log2ResetEnd   # jump to Log2ResetEnd
			
RefreshFrog2:	lw $t4, ($t6)  # t4 = frogCoordX
		addi $t4, $t4, 1  # t4 ++
		sw $t4, ($t6)  # overwrite t6 with t4	
			 			
Log2ResetEnd:


# Cars refresh
		addi $t5, $zero, 20  # t5 = 20
		j RefreshCars1  # jump to RefreshCars1
	
RefreshCars1:	lw $t1, 8($t3)  # t1 = t3(color3)
		beq $t1, $t5, ResetCars1Num  # when t1 = t5, do ResetCars1Num
		addi $t1, $t1, 1  # t1 ++
		sw $t1, 8($t3)  #overwrite t3[3] with t1
		j RefreshCars1End  # jump to RefreshCars1End
		
ResetCars1Num:	
		add $t1, $zero, $zero  # t1 = 0
		sw $t1, 8($t3)  # overwrite t3[3] with t1
		
		add $t2, $zero, $t7  # t1 = CarCoord
		lw $t1, ($t2)  # t1 = t2
		lw $s1, 128($t2)  # s1 = t2(next row)
			
		add $t4, $zero, $zero  # t4 = 0 
		addi $t5, $zero, 31  # t5 = 31
RefreshCars1Loop:	
		beq $t4, $t5, Cars1LoopEnd  # while t4 != t5	
		lw $s2, 4($t2)  # s2 = t2[2]
		lw $s3, 132($t2)  # s3 = t2[2](next row)
		sw $s2, ($t2)	# overwrite t2 with s2
		sw $s3, 128($t2)  # overwrite t2(next row) with s3
		addi $t4, $t4, 1  # t4 ++
		addi $t2, $t2, 4  # t2 += 4
		j RefreshCars1Loop  # jump to RefreshCars1Loop
			
Cars1LoopEnd:	
		sw $t1, ($t2)  # overwrite t2 with t1
		sw $s1, 128($t2)  # overwrite t2(next row) with s1
			 			
RefreshCars1End:

		addi $t5, $zero, 45  # t5 = 45
		j RefreshCars2  # jump to RefreshCars2
RefreshCars2:	lw $t1, 12($t3)  # t1 = t3[3]
		beq $t1, $t5, ResetCars2Num  # when t1 = t5, ResetCars2Num 
		addi $t1, $t1, 1  # t1++
		sw $t1, 12($t3)  #overwrite t3[3] with t1
		j AnimationEnd  # jump to AnimationEnd 
		
ResetCars2Num:	
		add $t1, $zero, $zero  # t1 = 0
		sw $t1, 12($t3)  # overwrite t3[3] with t1
		addi $t2, $t7, 380  # t2 = t7 + 380
		lw $t1, ($t2)  # t1 = t2
		lw $s1, 128($t2)  # s1 = t2(next row)
		add $t4, $zero, $zero  # t4 = 0 
		addi $t5, $zero, 31  # t5 = 31
RefreshCars2Loop:	
		beq $t4, $t5, Cars2LoopEnd  # while t4 != t5
		lw $s2, -4($t2)  # s2 = t2(second last)
		lw $s3, 124($t2)  # s3 = t2(next row)
		sw $s2, ($t2)	# overwrite t2 with s2
		sw $s3, 128($t2)  # overwrite t2 with s3
		addi $t2, $t2, -4  # t2 -= 4
		addi $t4, $t4, 1  # t4++
		j RefreshCars2Loop  # jump to RefreshCars2Loop
			
Cars2LoopEnd:	sw $t1, ($t2)  # overwrite t2 with t1
		sw $s1, 128($t2)  # overwrite t2(next row) with s1
			 		
AnimationEnd:


# Check keyboard status
		lw $t4, 0xffff0000  # t4 = keyboard stroke
		beq $t4, 1, Keys  # if stroke, keyboardInput
		j KeysEnd  # if there was no input, jump to KeysEnd
	
Keys:		lw $t4, 0xffff0004   # t4 = keyboard stroke status
		beq $t4, 119, strokeW  # if stroke W, do strokeW
		beq $t4, 97, strokeA  # if stroke A, do strokeA
		beq $t4, 115, strokeS  # if stroke S, do strokeS
		beq $t4, 100, strokeD   # if stroke D, do strokeD
		
strokeW:	lw $t5, 4($t6)  # t5 = frogCoordY
		subi $t5, $t5, 1  # t5 --
		sw $t5, 4($t6) # overwrite t6[2] with new t5
		addi $t4, $zero, 1 # t4 = 1
		sw $t4, 8($t6)  # overwrite t6[2] with t4 (facing forward)
		j KeysEnd
		
strokeA:	lw $t5, ($t6) # t5 = frogCoordX
		subi $t5, $t5, 1  # t5 --
		sw $t5, ($t6)  # overwrite t6 with new t5
		addi $t4, $zero, 3 # t4 = 3
		sw $t4, 8($t6)  # overwrite t6[3] with t4 (facing left) 
		j KeysEnd
		
		
strokeS:	lw $t5, 4($t6)  # t5 = frogCoordY
		addi $t5, $t5, 1  # t5 ++
		sw $t5, 4($t6) # overwrite t6[2] with new t5
		addi $t4, $zero, 2  # t4 = 2
		sw $t4, 8($t6)  # overwrite t6[3] with new t4 (facing down)
		j KeysEnd
		
strokeD:	lw $t5, ($t6) # t5 = frogCoordX
		addi $t5, $t5, 1  # t5 ++
		sw $t5, ($t6)  # overwrite t6 with new t5
		addi $t4, $zero, 4  # t4 = 4
		sw $t4, 8($t6)  # overwrite t6[3] with t4 (facing right)
		j KeysEnd
KeysEnd:  


# Check Status
IfYCoord:	lw $t4, 4($t6)  # t4 = frogCoordY
		beq $t4, 2, IfRegion1Coord  # if t4 = 2, IfRegion1Coord
		j DrawCanvas  # else jump to DrawBoard
		
		
IfRegion1Coord:	
		lw $t4, ($t6)  # t4 = frogCoordX
		beq $t4, 2, IfRegion1Filled  # if t4 = 2, IfRegion1Filled
		j IfRegion2Coord  # else jump to IfRegion2Coord

IfRegion1Filled:
		lw $t4, 8($s4)  # t4 = region1 status
		beq $t4, 0, FillRegion1 # if region 1 is unfilled, fill it
		j DrawCanvas  # else jump to DrawCanvas
		
FillRegion1:	addi $t4, $zero, 1  # t4 = 1
		sw $t4, 8($s4)  # region 1 is now filled
		lw $t5, 12($s4)  # check region 2
		beq $t5, 0, PartialInit  # if both filled, PartialInit 
		j DrawCanvas  # jump to DrawCanvas
		
IfRegion2Coord:	
		lw $t4, ($t6)  # t4 = frogCoordX
		beq $t4, 12, IfRegion2Filled  # if t4 = 12, IfRegion2Filled
		j DrawCanvas  # else, jump to DrawCanvas
		
		
IfRegion2Filled:
		lw $t4, 12($s4)  # t4 = region2 status
		beq $t4, 0, FillRegion2 # if region 2 is unfilled, fill it
		j IfRegion3Coord # else jump to IfRegion3Coord
			
FillRegion2:	addi $t4, $zero, 1  # t4 = 1
		sw $t4, 12($s4)  # region 2 is now filled
		lw $t5, 8($s4)  # check region 1
		beq $t5, 0, PartialInit # if both filled, PartialInit 
		j DrawCanvas  # else jump to DrawCanvas

IfRegion3Coord:	
		lw $t4, ($t6)  # t4 = frogCoordX
		beq $t4, 32, IfRegion3Filled  # if t4 = 2, IfRegion3Filled
		j IfRegion3Coord  # else jump to IfRegion3Coord

IfRegion3Filled:
		lw $t4, 8($s4)  # t4 = region1 status
		beq $t4, 0, FillRegion3 # if region 3 is unfilled, fill it
		j DrawCanvas  # else jump to DrawCanvas
			
FillRegion3:	addi $t4, $zero, 1  # t4 = 1
		sw $t4, 8($s4)  # region 3 is now filled
		lw $t5, 12($s4)  # check region 2
		beq $t5, 0, PartialInit  # if both filled, PartialInit 
		j DrawCanvas  # jump to DrawCanvas

Final:		j PartialInit  # jump to PartialInit


Death:	
		lw $t0, displayAddress  # t0 = displayAddress

		lw $t4, ($t6) # t4 = frogCoordX
		lw $t5, 4($t6) # t5 = frogCoordY
		
		sll $t2, $t5, 5  # shift t2 to multiply 32 
		add $t2, $t2, $t4  # t2 = t2 + t4
		sll $t2, $t2, 2  # shift t2 to multiply 4
		add $t0, $t0, $t2  # t0 = new cursor
		
		lw $t4, Red  # t4 = red
		
		# draw the pieces of frog when collided
		sw $t4, 8($t0) 
		sw $t4, 132($t0)  
		sw $t4, 136($t0) 
		sw $t4, 264($t0)  
		sw $t4, 384($t0)  
		sw $t4, 388($t0)  

		# sleep for 300 ms		
Sleep:		li $v0, 32  
		li $a0, 300 
		syscall
		
		lw $t1, FrogBodyColor 
		
		sw $t4, 260($t0) 
		sw $t4, 268($t0)  
		sw $t4, 392($t0)  
		sw $t4, 512($t0)
		sw $t1, 524($t0) 

		# sleep for 300 ms
		li $v0, 32 
		li $a0, 300 
		syscall
		
		beq $s0, 1, Initialization  # if still have 1 life, Initialization 
		subi $s0, $s0, 1  	# otherwise decrement current health by 1
		j PartialInit  	# nelse jump to PartialInit
	
Exit:
	li $v0, 10 # terminate the program gracefully
	syscall 
	
	
	
	
	
