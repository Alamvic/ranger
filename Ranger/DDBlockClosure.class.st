Class {
	#name : #DDBlockClosure,
	#superclass : #Object,
	#instVars : [
		'home',
		'ast'
	],
	#category : #Ranger
}

{ #category : #'as yet unclassified' }
DDBlockClosure class >> on: aRBBlockNode home: aFrame [

	^ self new
		ast: aRBBlockNode;
		home: aFrame;
		yourself
]

{ #category : #accessing }
DDBlockClosure >> ast [

	^ ast
]

{ #category : #accessing }
DDBlockClosure >> ast: anObject [

	ast := anObject
]

{ #category : #accessing }
DDBlockClosure >> home [

	^ home
]

{ #category : #accessing }
DDBlockClosure >> home: anObject [

	home := anObject
]
