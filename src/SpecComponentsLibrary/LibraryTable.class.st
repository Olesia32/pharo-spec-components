Class {
	#name : 'LibraryTable',
	#superclass : 'SpPresenter',
	#instVars : [
		'table',
		'originalData'
	],
	#category : 'SpecComponentsLibrary-Examples',
	#package : 'SpecComponentsLibrary',
	#tag : 'Examples'
}

{ #category : 'layout' }
LibraryTable >> defaultLayout [ 
	^ SpBoxLayout newVertical
		spacing: 10;
		add: table;
		yourself
]

{ #category : 'initialization' }
LibraryTable >> initializePresenters [

	table := PaginatedTablePresenter new.
	table
		columns: {
				('Назва' -> #title).
				('Автор' -> #author).
				('Жанр' -> #genre).
				('Рік' -> #year).
				('Наявність' -> #available) };
		itemsPerPage: 15.
	table table isEditable.
	self loadData
]

{ #category : 'initialization' }
LibraryTable >> initializeWindow: arg1 [

	arg1 title: 'Бібліотечний каталог'
]

{ #category : 'as yet unclassified' }
LibraryTable >> loadData [

	| path csvContents headers rows |
	path := FileLocator downloads / 'ukrainian_books_catalog_unique.csv'.
	csvContents := path readStream contents asString lines.
	csvContents isEmpty ifTrue: [ ^ self ].

	headers := (csvContents first findTokens: ',') collect: [ :h |
		           h withoutQuoting asSymbol ].
	rows := csvContents allButFirst collect: [ :line |
			        | values dict |
			        values := line findTokens: ','.
			        headers size = values size ifFalse: [ ^ nil ].

			        dict := Dictionary new.
			        headers with: values do: [ :key :val |
					        | cleanVal |
					        cleanVal := ((val beginsWith: '"') and: [
						                     val endsWith: '"' ])
						                    ifTrue: [ val copyFrom: 2 to: val size - 1 ]
						                    ifFalse: [ val ].

					        dict at: key put: (key = #year
							         ifTrue: [ cleanVal asInteger ]
							         ifFalse: [ cleanVal ]) ].
			        dict ].
	originalData := rows.
	table items: originalData
]
