--[[ Generalized (G)UI handler that acts on UIs depending on state given. Includes UI filtering and more.
    To be updated.
]]


local TweenService = game:GetService("TweenService")



local TWEEN_CONFIGS = {
	Hover = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
	Click = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
	Rotate = TweenInfo.new(7, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
}

local FILTER = {} -- Customize filter table to names of UIs to be filtered.

local UIManager = {}
UIManager.__index = UIManager


type properties = {[string]: any}

type GUI: {
    root: GuiObject?,
    properties: properties,
    connections: table
}



export type UIManager = setmetatable<GUI, typeof(UIManager)> -- New type solver, equivalent to: export type UIManager = typeof(setmetatable({} :: GUI, UIManager))


function UIManager.Assign(root): UIManager
    local self = {}
    self.root = root
    self.properties = {} :: properties
    self.Connections = connections


    self.originalProps = {}
    self.originalProps.Size = root.Size
    self.originalProps.Position = root.Position

    return setmetatable(self, UIManager)
end



function UIManager:Act(state: string)
    if not self.connections then return end

    if state == "Hovering" then
		
		local hoverProps = self.properties.hoverProps or {}
		
		local mouseEnterConn = self.root.MouseEnter:Connect(function()
			local hoverTween = TweenService:Create(self.root, TWEEN_CONFIGS.Hover, hoverProps)
			hoverTween:Play()
			
		end)
		
		table.insert(self.connections, mouseEnterConn)
		
		local mouseLeaveConn = self.root.MouseLeave:Connect(function()
			local hoverResetTween = TweenService:Create(self.root, TWEEN_CONFIGS.Hover, self.originalProps)
			hoverResetTween:Play()
		end)
		
		table.insert(self.connections, mouseLeaveConn)
		
	elseif state == "Clicking" then

		local clickConn = self.root.MouseButton1Click:Connect(function()
			
			local originalSize = self.root.Size
			local clickTween = TweenService:Create(self.root, TWEEN_CONFIGS.Click, {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset - 4, originalSize.Y.Scale, originalSize.Y.Offset - 4)})
			clickTween:Play()
			clickTween.Completed:Connect(function()
				local returnTween = TweenService:Create(self.root, TWEEN_CONFIGS.Click, {Size = originalSize})
				returnTween:Play()
			end)
			
		end)
		
		table.insert(self.connections, clickConn)
	end
end
end


function UIManager:SetHoverProps(props: properties)
    self.properties.hoverProps = props
    return self
end

function UIManager:Filter()
    if self.root then
        for _, element in ipairs(FILTER) do
			if self.root.Name:match(element) then
				self:CleanConns()
			end
		end
    end
end



function UIManager:checkConns()
    if not self.Connections or #self.Connections == 0 then return end
    return true
end


function UIManager:CleanConns()
    if self:checkConns() then return end
    if self.Connections then
        for _, connection in ipairs(self.Connections) do
            connection:Disconnect()
        end
        self.Connections = nil -- Nil is 'falsy.'
    end
end

return UIManager
