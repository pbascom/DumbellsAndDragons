composer, json = require "composer", "json"

class Encounter
	new: =>
		@scene = composer.newScene!
		@scene.create = ( event ) =>
			view = @view
			print("create")
		@scene.show = ( event ) =>
			view, phase = @view, @phase
			if phase == "will"
				print("show; will")
			elseif phase == "did"
				print("show; did")
		@scene.hide = ( event ) =>
			view, phase = @view, @phase
			if phase == "will"
				print("hide; will")
			elseif phase == "did"
				print("hide; did")
		@scene.destroy = ( event ) =>
			view = @view
			print("destroy")
		@scene\addEventListener( "create",  @scene )
		@scene\addEventListener( "show",    @scene )
		@scene\addEventListener( "hide",    @scene )
		@scene\addEventListener( "destroy", @scene )
		self

Encounter