Class {
	#name : 'StepCircleMorph',
	#superclass : 'Morph',
	#instVars : [
		'text',
		'isCurrent',
		'surface'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'drawing' }
StepCircleMorph >> drawOn: aCanvas [ 
    surface displayOnMorphicCanvas: aCanvas at: self bounds origin.
]

{ #category : 'initialization' }
StepCircleMorph >> initialize [ 
    super initialize.
    self extent: 30@30.
    self borderWidth: 0.
    self cornerStyle: #circle. 
    text := '1'.
    isCurrent := false.
    surface := AthensCairoSurface extent: self extent.
    self renderAthens.
]

{ #category : 'accessing' }
StepCircleMorph >> isCurrent: aBool [ 
    isCurrent := aBool.
    self renderAthens.
    self changed
]

{ #category : 'rendering' }
StepCircleMorph >> renderAthens [
 | font |
 font := LogicalFont familyName: 'Arial' pointSize: 10.
 surface drawDuring: [ :canvas |
 surface clear.
 canvas.
 canvas drawShape: (0@0 extent: self extent).
 canvas setFont: font.
 canvas setPaint: Color red.
 canvas
 pathTransform translateX: 20 Y: 20 + (font getPreciseAscent);
 scaleBy: 2; rotateByDegrees: 32.
 canvas drawString: 'Hello Athens in Pharo/Morphic' ]
]

{ #category : 'accessing' }
StepCircleMorph >> text: aString [ 
    text := aString.
    self renderAthens.
    self changed.

]
