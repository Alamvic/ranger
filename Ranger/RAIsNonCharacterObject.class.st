Class {
	#name : #RAIsNonCharacterObject,
	#superclass : #RAValueConstraint,
	#category : #'Ranger-VMSpecificConstraints'
}

{ #category : #negating }
RAIsNonCharacterObject >> mzConstraintOnInterpreter: anInterpreter [

	^ operands first typeTag notEquals: 2
]

{ #category : #negating }
RAIsNonCharacterObject >> negated [
	
	^ RAIsCharacterObject operands: self operands
]
