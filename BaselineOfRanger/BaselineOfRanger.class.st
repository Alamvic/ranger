Class {
	#name : #BaselineOfRanger,
	#superclass : #BaselineOf,
	#category : #BaselineOfRanger
}

{ #category : #baselines }
BaselineOfRanger >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			baseline: 'Minizinc'
			with: [ spec repository: 'github://tesonep/pharo-minizinc:main' ].
		spec package: 'Ranger' with: [ spec requires: #( 'Minizinc' ) ] ]
]
