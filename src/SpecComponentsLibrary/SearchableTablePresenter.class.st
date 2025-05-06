Class {
	#name : 'SearchableTablePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'searchField',
		'tablePresenter',
		'allItems',
		'displayBlock',
		'columnSelector'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'private' }
SearchableTablePresenter >> applyFilter [ 
    | query selectedKeys filtered |
    query := searchField text asLowercase.
    selectedKeys := columnSelector selectedItem collect: [ :assoc | assoc key ].

    filtered := allItems select: [ :each |
    (selectedKeys isEmpty
        or: [ selectedKeys includes: #__all__ ])
        or: [
            selectedKeys anySatisfy: [ :key |
                ((each at: key ifAbsent: '') asString asLowercase) includesSubstring: query
            ]
        ]
].


    tablePresenter items: filtered
]

{ #category : 'layout' }
SearchableTablePresenter >> columns: assocCollection [ 
    | columns keyLabelPairs|
    columns := assocCollection collect: [ :assoc |
        SpStringTableColumn new
            title: assoc key asString;
            evaluated: [ :row | row at: assoc value ifAbsent: '' ];
            beSortable;
            yourself
    ].

    tablePresenter columns: columns.
    keyLabelPairs := assocCollection collect: [ :assoc | assoc value -> assoc key asString ].
    columnSelector items: ( { #__all__ -> 'Усі колонки' } , keyLabelPairs ).
    columnSelector display: [ :pair | pair value ].
    columnSelector selectIndex: 1.
]

{ #category : 'layout' }
SearchableTablePresenter >> defaultLayout [ 
    ^ SpBoxLayout newVertical
        spacing: 10;
        add: (SpBoxLayout newHorizontal
                  spacing: 5;
                  add: searchField;
                  add: columnSelector expand: false) expand: false;
        add: tablePresenter;
        yourself
]

{ #category : 'layout' }
SearchableTablePresenter >> displayUsing: aBlock [ 
    displayBlock := aBlock
]

{ #category : 'initialization' }
SearchableTablePresenter >> initializePresenters [ 
    searchField := TextInputPresenter new.
    tablePresenter := SpTablePresenter new.
    columnSelector := SpDropListPresenter new.
    allItems := #().
    displayBlock := [ :item | item ].  "За замовчуванням — відображає як є"

    searchField mainPresenter whenTextChangedDo: [ self applyFilter ].
    columnSelector whenSelectionChangedDo: [ :_ | self applyFilter ].

    self focusOrder addAll: { searchField. tablePresenter }.
]

{ #category : 'api' }
SearchableTablePresenter >> items: aCollection [ 
    allItems := aCollection asOrderedCollection.
    self applyFilter.
]

{ #category : 'accessing' }
SearchableTablePresenter >> selectedItem [ 
    ^ tablePresenter selectedItem
]

{ #category : 'enumerating' }
SearchableTablePresenter >> whenSelectedItemChangedDo: aBlock [ 
    tablePresenter whenSelectedItemChangedDo: aBlock
]
