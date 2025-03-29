Class {
	#name : 'RAFalse',
	#superclass : 'RAConstant',
	#category : 'Ranger-Exploring-Exploring',
	#package : 'Ranger-Exploring',
	#tag : 'Exploring'
}

{ #category : 'printing' }
RAFalse >> fndConjunctionOperands [

	 ^ self
]

{ #category : 'initialization' }
RAFalse >> initialize [

	super initialize.
	value := false.
]
