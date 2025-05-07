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
	self build.
]
