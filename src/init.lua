local TweenService = game:GetService("TweenService")
local FreeThread: thread? = nil

local function DestroyTween(tween: Tween)
	local thread = FreeThread :: thread

	while true do
		FreeThread = nil

		tween.Completed:Wait()
		tween:Destroy()

		FreeThread = thread
		tween = coroutine.yield() :: Tween
	end
end

-- A nicer tween function which also makes sure
-- that the tween created is destroyed once completed.
return function(
	instance: Instance,
	tweenInfo: TweenInfo,
	properties: {[string]: any}
): Tween

	assert(
		typeof(instance) == 'Instance',
		"Must be an instance"
	)

	assert(
		typeof(tweenInfo) == 'TweenInfo',
		"Must be TweenInfo"
	)

	assert(
		typeof(properties) == 'table',
		"Must be a table"
	)

	local tween: Tween = TweenService:Create(instance, tweenInfo, properties)
	tween:Play()

	if FreeThread == nil then
		FreeThread = coroutine.create(DestroyTween) :: thread
	end
	task.spawn(FreeThread :: thread, tween)

	return tween
end
