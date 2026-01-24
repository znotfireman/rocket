export type TitleLike = { title: string, [any]: any }

local function compareByTitle<L, R>(lhs: L & TitleLike, rhs: R & TitleLike)
	return lhs.title < rhs.title
end

return compareByTitle
