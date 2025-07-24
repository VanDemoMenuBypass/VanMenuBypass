-- Script đặt trong ServerScriptService
local debris = game:GetService("Debris")

-- Ví dụ tạo vật phẩm rơi và tự hủy sau 30 giây
local function spawnAndCleanupItem(position)
	local item = Instance.new("Part")
	item.Position = position
	item.Size = Vector3.new(2, 2, 2)
	item.Anchored = false
	item.Parent = workspace

	-- Thêm item vào hệ thống Debris để tự xóa sau 30 giây
	debris:AddItem(item, 30)
end

-- Gọi thử
spawnAndCleanupItem(Vector3.new(0, 20, 0))