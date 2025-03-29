Class {
	#name : 'RAValueConstraint',
	#superclass : 'RAConstraint',
	#category : 'Ranger-Constraints',
	#package : 'Ranger',
	#tag : 'Constraints'
}

{ #category : 'testing' }
RAValueConstraint >> initialize [

	super initialize.

]

{ #category : 'testing' }
RAValueConstraint >> isIntegerObjectOf [
	
	^ false
]

{ #category : 'printing' }
RAValueConstraint >> operator [

	self subclassResponsibility 
]
