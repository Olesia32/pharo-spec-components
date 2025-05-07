Class {
	#name : 'SearchableTablePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'searchField',
		'tablePresenter',
		'allItems',
		'displayBlock',
		'columnSelector',
		'labelToKey'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'private' }
SearchableTablePresenter >> applyFilter [ 
    | query selectedKeys filtered |

    query := searchField text asLowercase.

    selectedKeys := columnSelector selectedItems collect: [ :label |
        labelToKey at: label ifAbsent: nil
    ].

    filtered := allItems select: [ :each |
            selectedKeys anySatisfy: [ :key |
                ((each at: key ifAbsent: '') asString asLowercase) includesSubstring: query
        ]
    ].

    tablePresenter items: filtered.
]

{ #category : 'api' }
SearchableTablePresenter >> columns: assocCollection [ 
    | columns |

    labelToKey := Dictionary new.

    columns := assocCollection collect: [ :assoc |
        SpStringTableColumn new
            title: assoc key asString;
            evaluated: [ :row | row at: assoc value ifAbsent: '' ];
            beSortable;
            yourself
    ].

    tablePresenter columns: columns.

    assocCollection do: [ :assoc |
        labelToKey at: assoc key asString put: assoc value
    ].

    columnSelector items: labelToKey keys.
    columnSelector selectedIndexes: (1 to: columnSelector allItems size).

    self applyFilter.
]

{ #category : 'layout' }
SearchableTablePresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  spacing: 10;
		  add: (SpBoxLayout newHorizontal
				   spacing: 5;
				   add: searchField;
				   add: columnSelector)
		  expand: false;
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
	columnSelector := MultiSelectComboBoxPresenter new.
	allItems := #(  ).
	displayBlock := [ :item | item ]. "За замовчуванням — відображає як є"

	searchField mainPresenter whenTextChangedDo: [ self applyFilter ].
	columnSelector whenSelectionChangedDo: [ :_ | self applyFilter ].

	self focusOrder addAll: {
			searchField.
			tablePresenter }
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
