Class {
	#name : 'RAIsNonCharacterObject',
	#superclass : 'RAValueConstraint',
	#category : 'Ranger-VMSpecificConstraints',
	#package : 'Ranger',
	#tag : 'VMSpecificConstraints'
}

{ #category : 'as yet unclassified' }
RAIsNonCharacterObject >> mutate: mutator [

	^ mutator mutateIsNonCharacterConstraint: self
]

{ #category : 'negating' }
RAIsNonCharacterObject >> mzConstraintOnInterpreter: anInterpreter [

	^ operands first typeTag notEquals: 2
]

{ #category : 'negating' }
RAIsNonCharacterObject >> negated [
	
	^ RAIsCharacterObject operands: self operands
]
