Class {
	#name : 'ButtonPresenter1',
	#superclass : 'SpButtonPresenter',
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'accessing' }
ButtonPresenter1 >> backgroundColor: aColor [

	self build.
	self adapter widget backgroundColor: aColor.
	self build
]

{ #category : 'building' }
ButtonPresenter1 >> build [

	super build.
	self adapter widget ifNotNil: [ self adapter widget color: Color red ]
]

{ #category : 'initialization' }
ButtonPresenter1 >> initialize [

	super initialize.
	self removeStyle: 'button.flat'.
	self removeStyle: 'button.small'.
	self removeStyle: 'button.large'.
	self whenBuiltDo: [
			| morph |
			morph := self adapter widget.
			morph fillStyle: (SolidFillStyle color: Color red).
			morph highlightColor: Color pink.
			morph changed ]
]
