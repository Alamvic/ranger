Class {
	#name : #RAValueConstraint,
	#superclass : #RAConstraint,
	#instVars : [
		'resultVariable'
	],
	#category : #Ranger
}

{ #category : #testing }
RAValueConstraint >> initialize [

	super initialize.
	resultVariable := ClVariable new name: UUID new asString
]

{ #category : #accessing }
RAValueConstraint >> resultVariable [
	
	^ resultVariable
]

{ #category : #accessing }
RAValueConstraint >> variables [
	
	^ { resultVariable } , super variables asArray
]
