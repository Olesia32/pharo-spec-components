Class {
	#name : 'PresenterDecoratorTest',
	#superclass : 'TestCase',
	#category : 'SpecComponentsLibrary-Tests',
	#package : 'SpecComponentsLibrary-Tests'
}

{ #category : 'tests' }
PresenterDecoratorTest >> testWrap [

	| instance wrappedFromInstance wrappedFromClass newClassInstance |
	instance := SpLabelPresenter new.
	instance label: 'Test'.

	wrappedFromInstance := PresenterDecorator wrap: instance.

	self assert: (wrappedFromInstance isKindOf: BasePresenter).
	self assert: wrappedFromInstance mainPresenter identicalTo: instance.
	wrappedFromInstance color: '#gray'.
	self
		assert: (wrappedFromInstance styleProperties at: #color)
		equals: '#gray'.

	wrappedFromClass := PresenterDecorator wrap: SpButtonPresenter.
	newClassInstance := wrappedFromClass mainPresenter.

	self assert: (wrappedFromClass isKindOf: BasePresenter).
	self assert: (newClassInstance isKindOf: SpButtonPresenter).
	self assert: newClassInstance ~~ instance.
	wrappedFromClass fontSize: 14.
	self
		assert: (wrappedFromClass styleProperties at: #fontSize)
		equals: 14
]
