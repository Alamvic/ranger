Class {
	#name : #RAConstraint,
	#superclass : #Object,
	#instVars : [
		'operands',
		'origin'
	],
	#category : #Ranger
}

{ #category : #'as yet unclassified' }
RAConstraint class >> constraintClassFor: anOperation [

	^ { 
		#~= -> RANotEqualsConstraint.
		#= -> RAEqualsConstraint.
		#> -> RAGreaterConstraint.
		#>= -> RAGreaterOrEqualsConstraint.
		#< -> RALessConstraint.
		#<= -> RALessOrEqualsConstraint.
		
		"Arithmetics"
		#bitAnd: -> RABitAndConstraint.
		#bitShift: -> RABitShiftConstraint.
		#+ -> RAAddConstraint.
		#- -> RASubstractionConstraint.
	 } asDictionary at: anOperation
]

{ #category : #'as yet unclassified' }
RAConstraint class >> operands: operands [

	^ self new
		operands: operands;
		yourself
]

{ #category : #'as yet unclassified' }
RAConstraint class >> operation: anOperation operands: operands [

	^ (self constraintClassFor: anOperation) new
		operands: operands;
		normalize
]

{ #category : #adding }
RAConstraint >> = anotherConstraint [

	(anotherConstraint isKindOf: self class)
		ifFalse: [ ^ false ].
	^ self operands = anotherConstraint operands
]

{ #category : #adding }
RAConstraint >> addToSolver: aSolver withVariables: variables interpreter: anObject [

	self subclassResponsibility
]

{ #category : #testing }
RAConstraint >> isConstant [
	
	^ false
]

{ #category : #testing }
RAConstraint >> isVariable [
	
	^ false
]

{ #category : #negating }
RAConstraint >> negated [
	
	self subclassResponsibility
]

{ #category : #converting }
RAConstraint >> normalize [

	^ self
]

{ #category : #accessing }
RAConstraint >> operands [

	^ operands
]

{ #category : #accessing }
RAConstraint >> operands: anObject [

	operands := anObject
]

{ #category : #accessing }
RAConstraint >> origin: aStackTrace [

	origin := aStackTrace
]

{ #category : #adding }
RAConstraint >> prettyIdentifier [

	^ self class name
]

{ #category : #adding }
RAConstraint >> prettyString [

	^ String streamContents: [ :str |
		str nextPutAll: self prettyIdentifier.
		str nextPut: $(.
		self operands
			do: [ :op | str nextPutAll: op prettyString ]
			separatedBy: [ str nextPutAll: ', ' ].
		str nextPut: $)
	]
]

{ #category : #printing }
RAConstraint >> printOn: aStream [

	super printOn: aStream.
	aStream nextPut: $(.
	operands
		do: [ :e | aStream print: e ]
		separatedBy: [ aStream nextPutAll: ', ' ].
	aStream nextPut: $).
	
]

{ #category : #testing }
RAConstraint >> variables [
	
	^ operands flatCollect: [ :e | e variables ] as: Set
]
