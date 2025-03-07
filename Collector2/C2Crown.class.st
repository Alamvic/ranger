Class {
	#name : 'C2Crown',
	#superclass : 'Object',
	#instVars : [
		'selector',
		'callees',
		'callers'
	],
	#category : 'Collector2',
	#package : 'Collector2'
}

{ #category : 'accessing' }
C2Crown >> callees [

	^ callees
]

{ #category : 'accessing' }
C2Crown >> callers [

	^ callers
]

{ #category : 'accessing' }
C2Crown >> initialize [

	callees := OrderedCollection new.
	callers := OrderedCollection new
]

{ #category : 'accessing' }
C2Crown >> printOn: aStream [

	super printOn: aStream.
	aStream print: selector.
	aStream
		nextPutAll: ' callers: ';
		print: callers size.
	aStream
		nextPutAll: ' callees: ';
		print: callees size.

]

{ #category : 'accessing' }
C2Crown >> selector [

	^ selector
]

{ #category : 'accessing' }
C2Crown >> selector: anObject [

	selector := anObject
]
