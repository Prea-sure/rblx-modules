--[[ Generalized (G)UI handler that acts on UIs depending on state given. Includes UI filtering and more.
    To be updated.
]]


local TweenService = game:GetService("TweenService")



local TWEEN_CONFIGS = {}

local FILTER = {}

local UIManager = {}
UIManager.__index = UIManager


type properties = {[string]: any}

type GUI: {
    root: GuiObject?,
    properties: properties,
    connections: table
}



export type UIManager = setmetatable<GUI, typeof(UIManager)> -- New type solver.


function UIManager.Assign(root): UIManager
    local self = {}
    self.root = root
    self.properties = {} :: properties
    self.Connections = connections


    self.originalProps = {}


    return setmetatable(self, UIManager)
end



function UIManager:Act()
    
end





function UIManager:Filter()

end



function UIManager:checkConns()

end


function UIManager:CleanConns()
    
end

return UIManager
