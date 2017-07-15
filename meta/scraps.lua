function Zone.new( id, scene, options )
	local self = {
		id = id,
		scene = scene
	}
	setmetatable( self, { __index = Zone } )

	self.states = {
		LOADING = self:newState( {
			create = function ( self, event )
				-- So it refers to the Zone, not the state
				self = self.parent

				-- First, we load ZoneData. In the finished app, this will be an i/o operation
				self.data = data.zoneData[ self.id ]

				-- Now, we create the display groups
				self.view = self.scene.view
				self.view.background = display.newGroup()
				self.view.midground = display.newGroup()
				self.view.foreground = display.newGroup()
				self.view.interface = display.newGroup()

				-- And prep the background
				local background = display.newImageRect( self.data.background, 480, 640 )
				self.view.background:insert( background )
				background.x = xn; background.y = yn

				-- Load region data
				local regionData = self.data.regionData
				self.points = regionData.points
				self.regions = {}
				for key, value in pairs( regionData.regions ) do
					self.regions[ key ] = Region.createFromData( value, self.regions, self.points )
				end

				-- Create AI and load actors
				self.ai = AI.new()
				for key, actor in pairs( self.data.actors ) do
					self.ai:register( key, Actor.new( actor.species, actor.role ) )
				end

				-- Enter LOADED state
				self:enterState( "LOADED" )
			end
		} ),
		LOADED = self:newState( {
			willShow = function ( self, event )

			end,
			didShow = function ( self, event )

			end
		} )
	}

	if options ~= nil and options.states ~= nil then
		for key, value in pairs( options.states ) do
			self.states[key] = value
		end
	end

	self.state = self.states.LOADING

	return self
end

function Action.wanderInRegion( actor, region, speed, variance )
	if variance == nil then variance = 12 end
	local self = {
		actor = actor,
		region = region,
		speed = speed,
		direction = math.random()*tau,
		buffer = variance*speed,
		variance = tau/variance
	}

	function self:update( delta )
		local step = delta*self.speed
		local buffer = delta*self.buffer

		local mod = ( math.random() - 0.5 )*self.variance
		local newDir = self.direction+mod

		local leader = {
			self.actor.group.x + buffer*math.cos( newDir ),
			self.actor.group.y + buffer*math.sin( newDir )
		}

		while not fn.inBounds( leader ) or not self.region.contains( leader ) do
			newDir = newDir + 0.2*mod
			leader = {
				self.actor.group.x + buffer*math.cos( newDir ),
				self.actor.group.y + buffer*math.sin( newDir )
			}
		end

		self.actor.group:translate( step*math.cos( newDir ), step*math.sin( newDir ) )
		self.direction = newDir

	end

	setmetatable( self, ActionMT )
	return self
end