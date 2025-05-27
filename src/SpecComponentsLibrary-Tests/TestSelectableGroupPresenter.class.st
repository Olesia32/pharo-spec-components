Class {
	#name : 'TestSelectableGroupPresenter',
	#superclass : 'AbstractSelectableGroupPresenter',
	#category : 'SpecComponentsLibrary-Tests',
	#package : 'SpecComponentsLibrary-Tests'
}

{ #category : 'building' }
TestSelectableGroupPresenter >> buildButton [

	^ LabelPresenter new text: 'dummy'
]
