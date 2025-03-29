Class {
	#name : 'RAConstraint',
	#superclass : 'Object',
	#instVars : [
		'operands'
	],
	#category : 'Ranger-Constraints',
	#package : 'Ranger',
	#tag : 'Constraints'
}

{ #category : 'as yet unclassified' }
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
		#bitOr: -> RABitOrConstraint.
		#bitShift: -> RABitShiftConstraint.
		#+ -> RAAddConstraint.
		#- -> RASubstractionConstraint.
		#* -> RAMultiplicationConstraint.
		#/ -> RADivisionConstraint.
		#'\\' -> RAModuloConstraint.
		#'//' -> RAQuotientConstraint.
		#asFloat -> RAIntegerToFloatConstraint.
	 } asDictionary at: anOperation
]

{ #category : 'as yet unclassified' }
RAConstraint class >> operands: operands [

	^ self new
		operands: operands;
		origin: thisContext stack copy;
		yourself
]

{ #category : 'as yet unclassified' }
RAConstraint class >> operation: anOperation operands: operands [

	^ (self constraintClassFor: anOperation) new
		operands: operands;
		simplify
]

{ #category : 'adding' }
RAConstraint >> = anotherConstraint [

	(anotherConstraint isKindOf: self class)
		ifFalse: [ ^ false ].
	^ self operands = anotherConstraint operands
]

{ #category : 'accessing' }
RAConstraint >> deMorgan [
	"Negations are not supported for the moment"
	"De Morgan's laws:
		- ~(A & B) is (~A v ~B)
		- ~(A v B) is (~A & ~B)
	"
	^ self
]

{ #category : 'accessing' }
RAConstraint >> distributeDisjunctions [
	"Distribute disjunction (v) over conjunction (^):
        - A v (B ^ C) is (A v B) ^ (A v C)
	"
	^ self
]

{ #category : 'printing' }
RAConstraint >> fndConjunctionOperands [
	^ { self }
]

{ #category : 'testing' }
RAConstraint >> isAnd [

	^ false
]

{ #category : 'testing' }
RAConstraint >> isConstant [
	
	^ false
]

{ #category : 'testing' }
RAConstraint >> isVariable [
	
	^ false
]

{ #category : 'as yet unclassified' }
RAConstraint >> mutate: mutator [

	^ self subclassResponsibility 
]

{ #category : 'microzinc' }
RAConstraint >> mzConstraintOnInterpreter: anInterpreter [
	
	self subclassResponsibility
]

{ #category : 'negating' }
RAConstraint >> negated [
	
	self subclassResponsibility
]

{ #category : 'accessing' }
RAConstraint >> operands [

	^ operands
]

{ #category : 'accessing' }
RAConstraint >> operands: anObject [

	operands := anObject
]

{ #category : 'accessing' }
RAConstraint >> operator [
	
	self subclassResponsibility 
]

{ #category : 'accessing' }
RAConstraint >> origin: aStackTrace [

]

{ #category : 'adding' }
RAConstraint >> prettyIdentifier [

	^ self class name
]

{ #category : 'adding' }
RAConstraint >> prettyString [

	^ String streamContents: [ :str |
		str nextPutAll: self prettyIdentifier.
		str nextPut: $(.
		self operands
			do: [ :op | str nextPutAll: op printString ]
			separatedBy: [ str nextPutAll: ', ' ].
		str nextPut: $)
	]
]

{ #category : 'printing' }
RAConstraint >> printOn: aStream [

	super printOn: aStream.
	aStream nextPut: $(.
	operands
		do: [ :e | aStream print: e ]
		separatedBy: [ aStream nextPutAll: ', ' ].
	aStream nextPut: $).
	
]

{ #category : 'accessing' }
RAConstraint >> removeDoubleNegation [
	"Negations are not supported for the moment"
	"Replace double negations:
		- ~~A is A
	"
	^ self
]

{ #category : 'accessing' }
RAConstraint >> removeImplications [
	"Implications and equivalences are not supported for the moment"
	"Replace implications: 
		- (A -> B) is (~A v B)
	"
	^ self
]

{ #category : 'accessing' }
RAConstraint >> removeRedundances [
	"We manage redundances of the form:
		- A v A is A
		- A ^ A is A
		- ...
	"
	^ self
]

{ #category : 'printing' }
RAConstraint >> sanitize [

	operands := operands collect: [ :operand |
		operand class = SmallInteger
			ifTrue: [ RAConstant new value: operand ]
			ifFalse: [ operand sanitize  ]
	].

	^  self
]

{ #category : 'testing' }
RAConstraint >> sanitizeOperands [
	
	operands withIndexDo: [ :element :index |
		element class = SmallInteger ifTrue: [ operands at: index put: (RAConstant new value: element) ].
	]
]

{ #category : 'as yet unclassified' }
RAConstraint >> simplify [

	^ self
]

{ #category : 'accessing' }
RAConstraint >> toCNF [
	"Step 1 - Remove implications and equivalences"
	"Step 2 - Apply De Morgan to push negations to literals" 
	"Step 3 - Remove double negations"
	"Step 4 - Distribute disjunctions"
	"Step 5 - Remove redundances"
	^ self removeImplications deMorgan removeDoubleNegation distributeDisjunctions sanitize removeRedundances
]

{ #category : 'printing' }
RAConstraint >> toString [

	^ '(' , operands first toString , ' ' , self operator , ' ' , operands second toString , ')' 
]

{ #category : 'testing' }
RAConstraint >> variables [
	
	^ operands flatCollect: [ :e | e variables ] as: Set
]
