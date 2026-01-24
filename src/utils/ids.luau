local Players = game:GetService("Players")

local THUMBNAIL_NAMES: { [EnumItem]: string } = {
	[Enum.ThumbnailType.HeadShot] = "AvatarHeadShot",
	[Enum.ThumbnailType.AvatarThumbnail] = "Avatar",
	[Enum.ThumbnailType.AvatarBust] = "AvatarBust",
	[Enum.ThumbnailSize.Size48x48] = "48",
	[Enum.ThumbnailSize.Size60x60] = "60",
	[Enum.ThumbnailSize.Size100x100] = "100",
	[Enum.ThumbnailSize.Size150x150] = "150",
	[Enum.ThumbnailSize.Size180x180] = "180",
	[Enum.ThumbnailSize.Size352x352] = "352",
	[Enum.ThumbnailSize.Size420x420] = "420",
}

local function rocket(id: string)
	return `@rocket/{id}`
end

local usernamesById: { [number]: string } = {}
local function fetchUsernameFromId(userId: number)
	usernamesById[userId] = Players:GetNameFromUserIdAsync(userId)
end

local function getUsername(userId: number)
	local existing = usernamesById[userId]
	if existing then
		return existing
	end
	task.spawn(fetchUsernameFromId, userId)
	return tostring(userId)
end

local function getUserThumbnail(userId: number, type: Enum.ThumbnailType, size: Enum.ThumbnailSize): string
	return `rbxthumb://type={THUMBNAIL_NAMES[type]}&id={userId}&w={THUMBNAIL_NAMES[size]}&h={THUMBNAIL_NAMES[size]}`
end

return table.freeze({
	rocket = rocket,
	getUsername = getUsername,
	getUserThumbnail = getUserThumbnail,
})
