Class {
	#name : #RAIsNonCharacerObject,
	#superclass : #RAValueConstraint,
	#category : #'Ranger-VMSpecificConstraints'
}

{ #category : #negating }
RAIsNonCharacerObject >> mzConstraintOnInterpreter: anInterpreter [

	^ operands first typeTag notEquals: 1
]

{ #category : #negating }
RAIsNonCharacerObject >> negated [
	
	^ RAIsIntegerObject operands: self operands
]
