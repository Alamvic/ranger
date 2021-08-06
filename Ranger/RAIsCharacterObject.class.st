Class {
	#name : #RAIsCharacterObject,
	#superclass : #RAValueConstraint,
	#category : #'Ranger-Interpreter'
}

{ #category : #negating }
RAIsCharacterObject >> mzConstraintOnInterpreter: anInterpreter [

	^ operands first typeTag equals: 2
	"
	Maybe we should check that the character value is in range?
	 and: (self
			   isInSmallIntegerRangeConstraintFor: operands first integerValue
			   inInterpreter: anInterpreter)"
]

{ #category : #negating }
RAIsCharacterObject >> negated [
	
	^ RAIsNonCharacterObject operands: self operands
]
