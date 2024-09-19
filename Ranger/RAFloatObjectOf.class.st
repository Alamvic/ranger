Class {
	#name : 'RAFloatObjectOf',
	#superclass : 'RAValueConstraint',
	#category : 'Ranger-VMSpecificConstraints',
	#package : 'Ranger',
	#tag : 'VMSpecificConstraints'
}

{ #category : 'as yet unclassified' }
RAFloatObjectOf >> mutate: mutator [

	^ mutator mutateIsFloatObjectOfConstraint: self
]
