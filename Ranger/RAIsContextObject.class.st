Class {
	#name : 'RAIsContextObject',
	#superclass : 'RAValueConstraint',
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
