Class {
	#name : 'RAIsContextObject',
	#superclass : 'VMConstraint',
	#category : 'Ranger-VMSpecificConstraints',
	#package : 'Ranger',
	#tag : 'VMSpecificConstraints'
}

{ #category : 'as yet unclassified' }
RAIsContextObject >> mutate: mutator [

	^ mutator mutateIsContextObjectConstraint: self
]

{ #category : 'negating' }
RAIsContextObject >> negated [
	self shouldBeImplemented.
]

{ #category : 'printing' }
RAIsContextObject >> operator [ 

	^ 'IsContextObj'
]
