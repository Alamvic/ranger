Class {
	#name : 'RAFloatObjectOf',
	#superclass : 'VMConstraint',
	#category : 'Ranger-VMSpecificConstraints',
	#package : 'Ranger',
	#tag : 'VMSpecificConstraints'
}

{ #category : 'as yet unclassified' }
RAFloatObjectOf >> mutate: mutator [

	^ mutator mutateIsFloatObjectOfConstraint: self
]

{ #category : 'printing' }
RAFloatObjectOf >> operator [ 

	^ 'FloatObjOf'
]
