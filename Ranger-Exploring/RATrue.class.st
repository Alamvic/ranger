Class {
	#name : 'RATrue',
	#superclass : 'RAConstant',
	#category : 'Ranger-Exploring-Exploring',
	#package : 'Ranger-Exploring',
	#tag : 'Exploring'
}

{ #category : 'printing' }
RATrue >> fndConjunctionOperands [

	 ^ {}
]

{ #category : 'initialization' }
RATrue >> initialize [

	super initialize.
	value := true.
]
