Class {
	#name : 'BasePresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'presenter',
		'mockApp'
	],
	#category : 'SpecComponentsLibrary-Tests',
	#package : 'SpecComponentsLibrary-Tests'
}

{ #category : 'running' }
BasePresenterTest >> setUp [
	super setUp.
	presenter := BasePresenter new.
   presenter mainPresenter: SpLabelPresenter new.

    mockApp := MockAppWithStyle new.
    presenter application: mockApp.
]

{ #category : 'tests' }
BasePresenterTest >> testGenerateAndApplyStyle [

	presenter fontSize: 14.

	self assert: presenter mainPresenter styles isNotEmpty.
	self assert: (presenter mainPresenter styles anySatisfy: [ :s |
			 s = (presenter instVarNamed: 'appliedStyleName') ])
]

{ #category : 'tests' }
BasePresenterTest >> testSetStyleProperties [

	presenter fontSize: 16.
	presenter backgroundColor: '#white'.
	self assert: (presenter styleProperties at: #fontSize) equals: 16.
	self
		assert: (presenter styleProperties at: #backgroundColor)
		equals: '#white'
]
